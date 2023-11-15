//
//  BluetoothManager.swift
//  TesKey Watch App
//
//  Created by aiden on November 14, 2023.
//

import SwiftUI
import CoreBluetooth
import os

class BluetoothManager: NSObject, ObservableObject {
    
    var cbCM: CBCentralManager!
    var logger = Logger(subsystem: "BLE", category: "BluetoothManager")
    var userDefaults = UserDefaults.standard
    
    @Published var teslaPeripheral: String? = ""
    @Published var poweredOn: Bool = false;
    @Published var showPairingDialog: Bool = false;
    
    override init() {
        super.init()
        
        logger.info("init called")
        cbCM = CBCentralManager(delegate: self, queue: nil)
        cbCM.delegate = self
    }
}
