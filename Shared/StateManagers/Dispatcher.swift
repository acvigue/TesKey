// Dispatcher.swift
//  TesKey
//
//  Created by aiden on 11/17/23.
//  
//

import Foundation
import os
import Dispatch

protocol DispatcherDelegate: AnyObject {
    func write(_ data: Data)
    func requestAuthorization()
}

class QueuedMessageContext: NSObject {
    var message: RoutableMessage = RoutableMessage()
    var retryCount: Int = 0
    var workItem: DispatchWorkItem?
    var response: RoutableMessage = RoutableMessage()
}

class Dispatcher: NSObject {
    private var vin: String;
    private var logger = Logger(subsystem: "Tesla", category: "Dispatcher")
    weak var delegate: DispatcherDelegate?
    private var infotainmentSessionManager: SessionManager;
    private var vcsecSessionManager: SessionManager;
    let queue = DispatchQueue(label: "bleQueue")
    var messages: [String: QueuedMessageContext] = [:];
    
    init(vin: String) {
        self.vin = vin
        self.infotainmentSessionManager = SessionManager(domain: .infotainment, vin: vin)
        self.vcsecSessionManager = SessionManager(domain: .vehicleSecurity, vin: vin)
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
        self.writeCommand(iRoutableMessage, authType: .None)
        
        //VCSEC
        iRoutableMessage.toDestination.domain = .vehicleSecurity
        self.writeCommand(iRoutableMessage, authType: .None)
    }
    
    func addKeyToWhitelist() {
        logger.info("asking vehicle to whitelist key")
        /*
         &vcsec.UnsignedMessage{
                 SubMessage: &vcsec.UnsignedMessage_WhitelistOperation{
                     WhitelistOperation: &vcsec.WhitelistOperation{
                         SubMessage: &vcsec.WhitelistOperation_AddKeyToWhitelistAndAddPermissions{
                             AddKeyToWhitelistAndAddPermissions: &vcsec.PermissionChange{
                                 Key: &vcsec.PublicKey{
                                     PublicKeyRaw: publicKey.Bytes(),
                                 },
                                 KeyRole: role,
                             },
                         },
                         MetadataForKey: &vcsec.KeyMetadata{
                             KeyFormFactor: formFactor,
                         },
                     },
                 },
             }
         */
        var unsignedMessage = UnsignedMessage()
        unsignedMessage.whitelistOperation.addKeyToWhitelistAndAddPermissions.key.publicKeyRaw = vcsecSessionManager.getSigner().getPublicKey()
        unsignedMessage.whitelistOperation.addKeyToWhitelistAndAddPermissions.keyRole = .driver
        unsignedMessage.whitelistOperation.metadataForKey.keyFormFactor = .iosDevice
        do {
            var toVCSECPayload = try unsignedMessage.serializedData()
            
            var routableMessage = RoutableMessage()
            routableMessage.toDestination.domain = .vehicleSecurity
            routableMessage.protobufMessageAsBytes = toVCSECPayload
            self.writeCommand(routableMessage, authType: .None)
        } catch {
            
        }
    }
    
    //MARK: Message Handling
    func handleMessage(_ ctx: QueuedMessageContext) {
        let initialRequest = ctx.message
        let response = ctx.response
        
        if(response.sessionInfo.status == .keyNotOnWhitelist) {
            delegate?.requestAuthorization()
            return
        }
    }
    
    //MARK: Characteristic R/W
    func receivedData(_ data: Data) {
        let goodData = data
        logger.debug("RX: \(goodData.hexEncodedString())")
        do {
            let decodedMessage = try RoutableMessage(serializedData: goodData)
            
            if(decodedMessage.hasToDestination && decodedMessage.toDestination.routingAddress.isEmpty && decodedMessage.toDestination.domain == .broadcast) {
                logger.debug("dropping message to broadcast domain!")
            } else {
                if(messages[decodedMessage.requestUuid.hexEncodedString()] != nil) {
                    logger.info("got response for request \(decodedMessage.requestUuid.hexEncodedString()): \(decodedMessage.textFormatString())")
                    
                    //Cancel the message context's executor
                    
                    var thisMessageContext = messages[decodedMessage.requestUuid.hexEncodedString()]!
                    thisMessageContext.response = decodedMessage
                    
                    messages[decodedMessage.requestUuid.hexEncodedString()]!.workItem?.cancel()
                    messages[decodedMessage.requestUuid.hexEncodedString()] = nil
                    
                    //Handle the message
                    handleMessage(thisMessageContext)
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
        
        var itemAsContext = QueuedMessageContext()
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
