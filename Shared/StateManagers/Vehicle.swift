// Vehicle.swift
//  TesKey Watch App
//
//  Created by aiden on 11/15/23.
//  
//

import Foundation
import CoreBluetooth
import SwiftProtobuf
import CryptoKit
import os

//Class functions as a simplified "Vehicle" object, also creates instance of Dispatcher
//Dispatcher calls Vehicle (DispatcherDelegate) to write, Vehicle calls Dispatcher when reading

extension Data {
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }

    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return self.map { String(format: format, $0) }.joined(separator: "")
    }
}

enum VehicleAppState {
    case enumerating
    case not_authenticated
    case controllable
}

class Vehicle: NSObject, CBPeripheralDelegate, DispatcherDelegate, ObservableObject {
    private var underlyingPeripheral: CBPeripheral
    private var teslaService: CBService? = nil
    private var txCharacteristic: CBCharacteristic? = nil
    private var rxCharacteristic: CBCharacteristic? = nil
    private var writeDone = true;
    private var rxBuffer = Data();
    private var rxLength = 0;
    
    let serviceUUID = CBUUID(string: "00000211-b2d1-43f0-9b88-960cebf8b91e")
    let txUUID = CBUUID(string: "00000212-b2d1-43f0-9b88-960cebf8b91e")
    let rxUUID = CBUUID(string: "00000213-b2d1-43f0-9b88-960cebf8b91e")
    
    private var logger = Logger(subsystem: "Tesla", category: "Vehicle")
    private var commandDispatcher: Dispatcher
    @Published var vehicleAppState: VehicleAppState = .enumerating
    
    //MARK: Bluetooth
    init(_ cbp: CBPeripheral) {
        self.underlyingPeripheral = cbp
        self.commandDispatcher = Dispatcher(vin: "5YJ3E1EA6NF250034")
        
        super.init()
        self.initCharacteristics()
    }
    
    func initCharacteristics() {
        underlyingPeripheral.delegate = self
        underlyingPeripheral.discoverServices([serviceUUID])
    }
    
    //MARK: CBPeripheralDelegate
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        teslaService = peripheral.services?.first(where: { service in
            return service.uuid == serviceUUID
        })
        
        guard let service = teslaService else { 
            abort()
        }
        
        underlyingPeripheral.discoverCharacteristics([rxUUID, txUUID], for: service)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        teslaService = peripheral.services?.first(where: { service in
            return service.uuid == serviceUUID
        })
        
        txCharacteristic = teslaService?.characteristics?.first(where: { characteristic in
            return characteristic.uuid == txUUID
        })
        
        rxCharacteristic = teslaService?.characteristics?.first(where: { characteristic in
            return characteristic.uuid == rxUUID
        })
        
        underlyingPeripheral.setNotifyValue(true, for: rxCharacteristic!)
        commandDispatcher.delegate = self

        //This is where we tell the Dispatcher that we are ready to initialize sessions with
        //Infotainment and VCSEC
        commandDispatcher.initializeSessions()
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        logger.debug("TX: \(error == nil ? "OK" : "error: \(String(describing: error))")")
        writeDone = true;
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if(characteristic.uuid == rxUUID) {
            if(rxBuffer.isEmpty) {
                logger.debug("Starting RX of new message")
                rxLength = 256*Int(characteristic.value![0]) + Int(characteristic.value![1])
                rxBuffer.append(characteristic.value!.dropFirst(2))
            } else {
                rxBuffer.append(characteristic.value!)
            }
            
            if(rxBuffer.count >= rxLength) {
                logger.debug("Message recieval complete")
                rxLength = 0;
                commandDispatcher.receivedData(rxBuffer)
                rxBuffer = Data()
            }
        }
    }
    
    //MARK: DispatcherDelegate
    func write(_ data: Data) {
        let checksumByte1 = UInt8(data.count>>8)
        let checksumByte2 = UInt8(data.count)
        
        var txBuffer = Data()
        txBuffer.append(contentsOf: [checksumByte1, checksumByte2])
        txBuffer.append(data)
        
        txBuffer.withUnsafeBytes { (u8Ptr: UnsafePointer<UInt8>) in
            let mutRawPointer = UnsafeMutableRawPointer(mutating: u8Ptr)
            let uploadChunkSize = 20
            let totalSize = txBuffer.count
            var offset = 0

            while offset < totalSize {

                let chunkSize = offset + uploadChunkSize > totalSize ? totalSize - offset : uploadChunkSize
                let chunk = Data(bytesNoCopy: mutRawPointer+offset, count: chunkSize, deallocator: Data.Deallocator.none)
                underlyingPeripheral.writeValue(chunk, for: txCharacteristic!, type: .withResponse)
                offset += chunkSize
                writeDone = false;
                
                while(!writeDone) {
                    
                }
            }
        }
    }
    
    func requestAuthorization() {
        vehicleAppState = .not_authenticated
        self.objectWillChange.send()
        logger.error("Not authorized to control vehicle!")
    }
    
    func requestAddKey() {
        commandDispatcher.addKeyToWhitelist()
    }
}
