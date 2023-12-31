// SessionManager.swift
//  TesKey Watch App
//
//  Created by aiden on 11/16/23.
//  
//

import Foundation
import CoreData
import os
import CryptoSwift

class SessionManager: NSObject {
    private var setTime: UInt32 = 0;
    private var counter: UInt32 = 0;
    private var epoch: Data = Data();
    private var timeZero: NSDate = NSDate.now as NSDate;
    private var logger = Logger(subsystem: "Tesla", category: "SessionManager")
    private var defaults = UserDefaults();
    private var signer: Signer?;
    private var uuid: UUID;
    
    init(domain: Domain, uuid: UUID) {
        self.uuid = uuid
        self.counter = UInt32((defaults.value(forKey: "me.vigue.teskey.counter.\(self.uuid.uuidString)") ?? 0) as! Int)
        super.init()
        self.signer = Signer(uuid: uuid, sessionManager: self);
    }
    
    // UpdateSessionInfo allows Signer to resync session state with a Verifier.
    // A Verifier may include info in an authentication error message when the error may have resulted
    // from a desync. The Signer can update its session info and then reattempt transmission.
    
    //Called when Dispatcher receives a valid SessionInfo response
    func updateSessionInfo(_ info: SessionInfo) {
        if(!epoch.elementsEqual(info.epoch) || (setTime <= info.clockTime)) {
            //counter = max(info.counter, 1)
            //defaults.setValue(counter, forKey: "me.vigue.teskey.counter.\(self.uuid.uuidString)")
            
            epoch = Data(info.epoch)
            setTime = info.clockTime
            timeZero = epochStartTime(epochTime: info.clockTime)
        }
        self.signer?.setVerifierPubKey(info.publicKey)
    }
    
    func epochStartTime(epochTime: UInt32) -> NSDate {
        var date = NSDate.now
        let calendar = NSCalendar.autoupdatingCurrent
        
        date = calendar.date(byAdding: .second, value: -1 * Int(epochTime), to: date)!
        return date as NSDate
    }
    
    func getSessionStorageKey() {
        
    }
    
    func getSigner() -> Signer {
        return signer!
    }
    
    func signRoutableMessage() {
        
    }
    
    func updateCounter(_ ct: Int) {
        counter = UInt32(ct)
        defaults.setValue(counter, forKey: "me.vigue.teskey.counter.\(self.uuid.uuidString)")
    }
    
    func signVCSECUnsignedMessage(_ msg: UnsignedMessage) -> ToVCSECMessage {
        self.counter += 1;
        defaults.setValue(counter, forKey: "me.vigue.teskey.counter.\(self.uuid.uuidString)")
        let nonce: [UInt8] = withUnsafeBytes(of: counter.bigEndian, Array.init)
        let key: [UInt8] = Array(getSigner().agreedSymmetricKey!)
        
        let gcm = GCM(iv: nonce, mode: .detached)
        let aes = try! AES(key: key, blockMode: gcm, padding: .noPadding)
        let encrypted = try! aes.encrypt([UInt8](msg.serializedData()))
        
        logger.debug("nonce: \(Data(nonce).hexEncodedString()), counter: \(self.counter)")
        
        var toMessage = ToVCSECMessage()
        
        toMessage.signedMessage.protobufMessageAsBytes = Data(encrypted)
        toMessage.signedMessage.signature = Data(gcm.authenticationTag!)
        toMessage.signedMessage.counter = self.counter
        toMessage.signedMessage.keyID = getSigner().getKeyId()
        
        logger.debug("\(toMessage.textFormatString())")
        
        return toMessage
    }
}
