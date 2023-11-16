// TeslaPeripheral.swift
//  TesKey Watch App
//
//  Created by aiden on 11/15/23.
//  
//

import Foundation
import CoreBluetooth
import SwiftProtobuf
import CryptoKit

protocol TeslaPeripheralDelegate: AnyObject {
    func vehicleRequiresAuthentication()
    func vehicleConnected()
}

class TeslaPeripheral: NSObject, CBPeripheralDelegate {
    private var underlyingPeripheral: CBPeripheral
    private var teslaService: CBService? = nil
    private var txCharacteristic: CBCharacteristic? = nil
    private var rxCharacteristic: CBCharacteristic? = nil
    weak var delegate: TeslaPeripheralDelegate?
    
    let serviceUUID = CBUUID(string: "00000211-b2d1-43f0-9b88-960cebf8b91e")
    let txUUID = CBUUID(string: "00000212-b2d1-43f0-9b88-960cebf8b91e")
    let rxUUID = CBUUID(string: "00000213-b2d1-43f0-9b88-960cebf8b91e")
    
    
    //MARK: Bluetooth
    init(_ cbp: CBPeripheral) {
        self.underlyingPeripheral = cbp
        
        self.initCharacteristics()
    }
    
    func initCharacteristics() {
        underlyingPeripheral.delegate = self
        
        underlyingPeripheral.discoverServices([serviceUUID])
    }
    
    //MARK: Cryptographic Functions
    private func getPrivateKey() -> SecKey {
        let tag = "me.vigue.teskey.\(underlyingPeripheral.identifier.uuidString)".data(using: .utf8)!
        let getquery: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: tag,
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecReturnRef as String: true
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(getquery as CFDictionary, &item)
        guard status == errSecSuccess else {
            let attributes: [String: Any] = [
                kSecAttrKeyType as String: kSecAttrKeyTypeEC,
                kSecAttrKeySizeInBits as String: 256,
                kSecPrivateKeyAttrs as String: [
                    kSecAttrIsPermanent as String: true,
                    kSecAttrApplicationTag as String: tag
                ]
            ]
            var error: Unmanaged<CFError>?
            guard let privateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error) else {
                abort()
            }
            item = privateKey as CFTypeRef
        }
        return item as! SecKey
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
        
        guard let rx = rxCharacteristic else { return }
        underlyingPeripheral.setNotifyValue(true, for: rx)
        
        //delegate?.changeBackgroundColor(tapGesture.view?.backgroundColor)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        <#code#>
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        <#code#>
    }
}
