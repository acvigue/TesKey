//
//  BluetoothManager-CMDelegate.swift
//  TesKey Watch App
//
//  Created by aiden on November 14, 2023.
//

import CoreBluetooth

extension BluetoothManager: CBCentralManagerDelegate, TeslaPeripheralDelegate {
    //MARK: Tesla Peripheral Delegate
    func vehicleRequiresAuthentication() {
        state = .authenticate
    }
    
    func vehicleConnected() {
        state = .connected
    }
    
    //MARK: CentralManagerDelegate
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if(central.state == .poweredOn) {
            logger.info("cb power on!");
            attemptConnection()
        } else if(central.state == .unauthorized) {
            logger.info("cb unauthorized!");
            state = .bt_unauthorized
        } else {
            logger.info("cb unavailable!");
            state = .bt_unavailable
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        discoveredPeripherals = []
        connectedPeripheral = peripheral
        teslaPeripheral = TeslaPeripheral(connectedPeripheral!)
        
        teslaPeripheral!.delegate = self
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        discoveredPeripherals.append(peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        state = .connect_failed
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, timestamp: CFAbsoluteTime, isReconnecting: Bool, error: Error?) {
        guard (peripheral.name != nil) else {
            logger.error("didDisconnectPeripheral called w/ invalid peripheral!");
            return
        }
        
        logger.info("periph \(peripheral.name!) disconnected");
        state = .disconnected
    }
}
