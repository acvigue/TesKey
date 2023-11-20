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
    
    init(domain: Domain, vin: String) {
        super.init()
        self.signer = Signer(vin: vin, sessionManager: self);
    }
    
    // UpdateSessionInfo allows Signer to resync session state with a Verifier.
    // A Verifier may include info in an authentication error message when the error may have resulted
    // from a desync. The Signer can update its session info and then reattempt transmission.
    
    //Called when Dispatcher receives a valid SessionInfo response
    func updateSessionInfo(_ info: SessionInfo) {
        if(!epoch.elementsEqual(info.epoch) || (setTime <= info.clockTime)) {
            counter = max(info.counter, 1)
            
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
    
    func signVCSECUnsignedMessage(_ msg: UnsignedMessage) -> ToVCSECMessage {
        self.counter += 1;
        var u32BE = counter.bigEndian
        let gcm = GCM(iv: withUnsafeBytes(of: Data(bytes: &u32BE, count: 4), Array.init), mode: .detached)
        let aes = try! AES(key: withUnsafeBytes(of: getSigner().agreedSymmetricKey!, Array.init), blockMode: gcm, padding: .noPadding)
        let encrypted = try! aes.encrypt([UInt8](msg.serializedData()))
        
        logger.debug("nonce: \(Data(bytes: &u32BE, count: 4).hexEncodedString()), counter: \(self.counter)")
        
        var toMessage = ToVCSECMessage()
        
        var ciphertext = Data()
        ciphertext.append(contentsOf: encrypted)
        
        logger.debug("AES: \(ciphertext.hexEncodedString())")

        var tag = Data()
        tag.append(contentsOf: gcm.authenticationTag!)
        
        toMessage.signedMessage.protobufMessageAsBytes = ciphertext
        toMessage.signedMessage.signature = tag
        toMessage.signedMessage.counter = self.counter
        toMessage.signedMessage.keyID = getSigner().getKeyId()
        
        logger.debug("\(toMessage.textFormatString())")
        
        return toMessage
    }
}
