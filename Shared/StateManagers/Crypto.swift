// Crypto.swift
//  TesKey Watch App
//
//  Created by aiden on 11/16/23.
//  
//

import Foundation

class Crypto: NSObject {
    // Given the current time of some epoch, return the local time at which that
    // epoch started.
    func epochStartTime(epochTime: UInt32) -> NSDate {
        var date = NSDate.now
        let calendar = NSCalendar.autoupdatingCurrent
        
        date = calendar.date(byAdding: .second, value: -1 * Int(epochTime), to: date)!
        return date as NSDate
    }
}
