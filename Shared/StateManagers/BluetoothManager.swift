//
//  BluetoothManager.swift
//  TesKey Watch App
//
//  Created by aiden on November 14, 2023.
//

import SwiftUI
import CoreBluetooth
import os

enum BluetoothManagerState {
    //CentralManager initialization states
    case powered_off
    case bt_unauthorized
    case bt_unavailable
    
    //App cases
    case not_setup
    case discovering
    case disconnected
    case connecting
    case connect_failed
    case connected
}

class BluetoothManager: NSObject, ObservableObject {
    
    var cbCM: CBCentralManager!
    var logger = Logger(subsystem: "BLE", category: "BluetoothManager")
    var userDefaults = UserDefaults.standard
    
    let serviceUUID = CBUUID(string: "1122")
    
    @Published var discoveredPeripherals: [CBPeripheral] = [];
    @Published var state: BluetoothManagerState = .powered_off;
    var connectedPeripheral: CBPeripheral? = nil;
    @Published var teslaPeripheral: Vehicle? = nil;
    
    override init() {
        super.init()
        
        logger.info("init called")
        cbCM = CBCentralManager(delegate: self, queue: nil)
        cbCM.delegate = self
        
    }
    
    func startDiscovery() {
        cbCM.scanForPeripherals(withServices: [serviceUUID])
        state = .discovering
    }
    
    func stopDiscovery(_ peripheral: CBPeripheral) {
        cbCM.stopScan()
        cbCM.connect(peripheral)
        state = .connecting
    }
    
    func attemptConnection() {
        //Check if we have a saved device.
        let savedPeripherals = userDefaults.value(forKey: "savedPeripherals") as? [UUID];
        if(savedPeripherals?.isEmpty ?? true) {
            logger.warning("savedPeripherals empty!")
            state = .not_setup
        } else {
            let thisPeripheral = cbCM.retrievePeripherals(withIdentifiers: savedPeripherals!)
            guard let peripheral = thisPeripheral.first else {
                state = .not_setup
                logger.warning("could not retrieve savedperipheral!")
                userDefaults.setValue([], forKey: "savedPeripherals")
                return
            }
            cbCM.connect(peripheral)
            state = .connecting
        }
    }
    
    func unpair() {
        userDefaults.setValue([], forKey: "savedPeripherals")
        state = .not_setup
    }
}
