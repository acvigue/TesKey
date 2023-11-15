//
//  BluetoothManager-CMDelegate.swift
//  TesKey Watch App
//
//  Created by aiden on November 14, 2023.
//

import CoreBluetooth

//MARK: ViewModelSetup
extension BluetoothManager: CBCentralManagerDelegate {
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, timestamp: CFAbsoluteTime, isReconnecting: Bool, error: Error?) {
        guard (peripheral.name != nil) else {
            logger.error("didDisconnectPeripheral called w/ invalid peripheral!");
            return
        }
        
        logger.info("Peripheral \(peripheral.name!) disconnected");
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        poweredOn = (central.state == .poweredOn)
        
        if(poweredOn) {
            logger.info("CoreBluetooth power on!");
            
            //Check if we have a saved device.
            let savedPeripherals = userDefaults.value(forKey: "savedPeripherals") as? [CBUUID];
            if(savedPeripherals?.isEmpty ?? false) {
                showPairingDialog = true;
            } else {
                let savedPeripheral =
            }
        } else {
            logger.info("CoreBluetooth power off!");
        }
    }
}
