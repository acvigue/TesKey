//
//  CoreBluetoothViewModel.swift
//  SwiftUI-BLE-Project
//
//  Created by kazuya ito on 2021/02/02.
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
