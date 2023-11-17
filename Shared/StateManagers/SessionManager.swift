// SessionManager.swift
//  TesKey Watch App
//
//  Created by aiden on 11/16/23.
//  
//

import Foundation
import CoreData
import os

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
            counter = info.counter
            
            epoch = Data(info.epoch)
            setTime = info.clockTime
            timeZero = epochStartTime(epochTime: info.clockTime)
        }
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
}
