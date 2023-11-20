// Dispatcher.swift
//  TesKey
//
//  Created by aiden on 11/17/23.
//  
//

import Foundation
import os
import Dispatch
import CryptoKit
import UIKit

protocol DispatcherDelegate: AnyObject {
    func write(_ data: Data)
    func requestAuthorization()
    func authorizationRequested()
    func enumerating()
    func authorized()
    func getVehicleAppState() -> VehicleAppState
}

class QueuedMessageContext: NSObject {
    var message: RoutableMessage = RoutableMessage()
    var retryCount: Int = 0
    var workItem: DispatchWorkItem?
    var response: RoutableMessage = RoutableMessage()
}

class Dispatcher: NSObject {
    private var uuid: UUID;
    private var logger = Logger(subsystem: "Tesla", category: "Dispatcher")
    weak var delegate: DispatcherDelegate?
    private var infotainmentSessionManager: SessionManager;
    private var vcsecSessionManager: SessionManager;
    let queue = DispatchQueue(label: "bleQueue")
    var messages: [String: QueuedMessageContext] = [:];
    
    init(uuid: UUID) {
        self.uuid = uuid
        self.infotainmentSessionManager = SessionManager(domain: .infotainment, uuid: uuid)
        self.vcsecSessionManager = SessionManager(domain: .vehicleSecurity, uuid: uuid)
    }
    
    //MARK: Callable Commands
    
    // Called when characteristics are discovered, *attempts to* sets up encrypted AES/ECDH sessions
    // w/ VCSEC and Infotainment
    // Also called once key is installed on vehicle if key needs to be added to whitelist
    func initializeSessions() {
        //Infotainment
        var iRoutableMessage = RoutableMessage()
        iRoutableMessage.toDestination.domain = .infotainment
        iRoutableMessage.sessionInfoRequest.publicKey = infotainmentSessionManager.getSigner().getPublicKey()
        //self.writeCommand(iRoutableMessage, authType: .None)
        
        //VCSEC
        iRoutableMessage.toDestination.domain = .vehicleSecurity
        self.writeCommand(iRoutableMessage, authType: .None)
    }
    
    func addKeyToWhitelist() {
        logger.info("asking vehicle to whitelist key")
        var unsignedMessage = UnsignedMessage()
        unsignedMessage.whitelistOperation.addKeyToWhitelistAndAddPermissions.key.publicKeyRaw = vcsecSessionManager.getSigner().getPublicKey()
        unsignedMessage.whitelistOperation.addKeyToWhitelistAndAddPermissions.keyRole = .driver
        unsignedMessage.whitelistOperation.metadataForKey.keyFormFactor = .iosDevice
        do {
            let toVCSECPayload = try unsignedMessage.serializedData()

            var routableMessage = ToVCSECMessage()
            routableMessage.signedMessage.protobufMessageAsBytes = toVCSECPayload
            routableMessage.signedMessage.signatureType = .presentKey
            let toVCSECMessage = try routableMessage.serializedData()
            self.delegate?.write(toVCSECMessage)
            self.delegate?.authorizationRequested()
        } catch {
            logger.fault("\(error)")
        }
    }
    
    //MARK: Message Handling
    func handleRoutableMessage(_ ctx: QueuedMessageContext) {
        let _ = ctx.message
        let response = ctx.response
        
        if(response.sessionInfo.status == .keyNotOnWhitelist) {
            delegate?.requestAuthorization()
            return
        } else {
            delegate?.enumerating()
            if(response.fromDestination.domain == .vehicleSecurity) {
                vcsecSessionManager.updateSessionInfo(response.sessionInfo)
                
                //Our key is on the whitelist, we now also have the vehicle's ephemeral key.
                //Tell VCSEC we're connected.
                var unsignedMessage = UnsignedMessage()
                unsignedMessage.authenticationResponse.authenticationLevel = .authenticationLevelNone
                let toVCSECMessage = vcsecSessionManager.signVCSECUnsignedMessage(unsignedMessage)
                try! delegate!.write(toVCSECMessage.serializedData())
            } else if(response.fromDestination.domain == .infotainment) {
                infotainmentSessionManager.updateSessionInfo(response.sessionInfo)
            }
            
            
            
        }
    }
    
    func handleVCSECMessage(_ msg: FromVCSECMessage) {
        logger.info("got FromVCSEC: \(msg.textFormatString())")
        switch(msg.subMessage) {
        case .whitelistInfo(let whitelist):
            let keyId = vcsecSessionManager.getSigner().getKeyId()
            
            whitelist.whitelistEntries.forEach { entry in
                if(keyId.elementsEqual(entry.publicKeySha1)) {
                    //Our key is now whitelisted!
                    logger.info("our key is now on the whitelist, reenumerate.")
                    delegate?.enumerating()
                    initializeSessions()
                }
            }
            break
        case .commandStatus(let commandStatus):
            if(commandStatus.operationStatus != .operationstatusOk) {
                delegate?.requestAuthorization()
                return
            }
            switch(commandStatus.subMessage) {
            case .signedMessageStatus(let sms):
                delegate?.authorized()
                vcsecSessionManager.updateCounter(Int(sms.counter + 1))
            default:
                break
            }
        case .appDeviceInfoRequest(let deviceInfoRequest):
            if(deviceInfoRequest == .appDeviceInfoRequestGetModelNumber) {
                var unsignedMessage = UnsignedMessage()
                var modelBytes = Data()
                SHA256.hash(data: Data(hex: UIDevice.current.name)).withUnsafeBytes { byte in
                    modelBytes.append(contentsOf: byte)
                }
                unsignedMessage.appDeviceInfo.hardwareModelSha256 = modelBytes
                unsignedMessage.appDeviceInfo.os = .ios
                unsignedMessage.appDeviceInfo.uwbavailable = .unavailableUnsupportedDevice
                unsignedMessage.appDeviceInfo.phoneVersion.osVersionMajor = 17
                unsignedMessage.appDeviceInfo.phoneVersion.osVersionMinor = 1
                let toVCSECMessage = vcsecSessionManager.signVCSECUnsignedMessage(unsignedMessage)
                try! delegate!.write(toVCSECMessage.serializedData())
            }
        case .authenticationRequest(let authRequest):
            if(delegate?.getVehicleAppState() == .controllable) {
                var unsignedMessage = UnsignedMessage()
                unsignedMessage.authenticationResponse.authenticationLevel = authRequest.requestedLevel
                let toVCSECMessage = vcsecSessionManager.signVCSECUnsignedMessage(unsignedMessage)
                try! delegate!.write(toVCSECMessage.serializedData())
            }
        default: break
        }
    }
    
    //MARK: Characteristic R/W
    func receivedData(_ data: Data) {
        logger.debug("RX: \(data.hexEncodedString())")
        do {
            let decodedMessage = try RoutableMessage(serializedData: data)
            
            if(decodedMessage.hasToDestination && decodedMessage.toDestination.routingAddress.isEmpty && decodedMessage.toDestination.domain == .broadcast) {
                if(decodedMessage.fromDestination.domain == .vehicleSecurity) {
                    let decodedVCSECMessage = try FromVCSECMessage(serializedData: decodedMessage.protobufMessageAsBytes)
                    handleVCSECMessage(decodedVCSECMessage)
                }
            } else {
                if(messages[decodedMessage.requestUuid.hexEncodedString()] != nil) {
                    logger.info("got message: \(decodedMessage.textFormatString())")
                    logger.info(" -> for request \(decodedMessage.requestUuid.hexEncodedString())")
                    
                    //Cancel the message context's executor
                    let thisMessageContext = messages[decodedMessage.requestUuid.hexEncodedString()]!
                    thisMessageContext.response = decodedMessage
                    
                    messages[decodedMessage.requestUuid.hexEncodedString()]!.workItem?.cancel()
                    messages[decodedMessage.requestUuid.hexEncodedString()] = nil
                    
                    //Handle the message
                    handleRoutableMessage(thisMessageContext)
                } else {
                    let decodedVCSECMessage = try FromVCSECMessage(serializedData: data)
                    handleVCSECMessage(decodedVCSECMessage)
                }
            }
        } catch {
            logger.error("could not deserialize to RoutableMessage!")
        }
    }
    
    func writeCommand(_ msg: RoutableMessage, authType: AuthMethod) {
        var smsg = Data()
        var msgUUID = ""
        if(msg.toDestination.domain == .infotainment) {
            let resp = infotainmentSessionManager.getSigner().encode(msg, authType)
            smsg = resp.signedMessage
            msgUUID = resp.messageUUID
        }
        if(msg.toDestination.domain == .vehicleSecurity) {
            let resp = vcsecSessionManager.getSigner().encode(msg, authType)
            smsg = resp.signedMessage
            msgUUID = resp.messageUUID
        }
        
        let itemAsContext = QueuedMessageContext()
        itemAsContext.message = msg
        itemAsContext.workItem = DispatchWorkItem {
            if(self.messages[msgUUID]!.retryCount < 3) {
                self.logger.info("sending \(msgUUID): \(msg.textFormatString())")
                self.delegate?.write(smsg)
                self.messages[msgUUID]!.retryCount = self.messages[msgUUID]!.retryCount + 1
                
                //Reschedule this for 3 seconds in the future.
                let timeout = DispatchTime.now().advanced(by: .seconds(2))
                self.queue.asyncAfter(deadline: timeout, execute: (self.messages[msgUUID]?.workItem!)!)
            }
        }
        
        messages[msgUUID] = itemAsContext
        
        queue.async(execute: (messages[msgUUID]?.workItem!)!)
    }
}
