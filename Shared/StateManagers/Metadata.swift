// Metadata.swift
//  TesKey Watch App
//
//  Created by aiden on 11/15/23.
//  
//

import Foundation
import CryptoKit

enum MetadataTag: Int {
    case SIGNATURE_TYPE
    case DOMAIN
    case PERSONALIZATION
    case EPOCH
    case EXPIRES_AT
    case COUNTER
    case CHALLENGE
    case FLAGS
    case END = 255
}

class Metadata: NSObject {
    private var byteArr: Data = Data()
    
    func Add(tag: MetadataTag, _ value: Data) {
        var thisTLV = Data()
        thisTLV.append(contentsOf: [UInt8(tag.rawValue) as UInt8])
        thisTLV.append(contentsOf: [UInt8(value.count) as UInt8])
        thisTLV.append(contentsOf: value)
        byteArr.append(thisTLV)
    }
    
    func AddUint32(tag: MetadataTag, _ value: UInt32) {
        var u32BE = value.bigEndian
        let dataBE = Data(bytes: &u32BE, count: 4)
        self.Add(tag: tag, dataBE)
    }
    
    func Checksum256(message: Data) -> Data {
        byteArr.append(contentsOf: [UInt8(MetadataTag.END.rawValue)])
        byteArr.append(message)
        var d = Data()
        withUnsafeBytes(of: SHA256.hash(data: byteArr)) {
            d.append(contentsOf: $0)
        }
        return d
    }
    
    func Checksum512(message: Data) -> Data {
        byteArr.append(contentsOf: [UInt8(MetadataTag.END.rawValue)])
        byteArr.append(message)
        var d = Data()
        withUnsafeBytes(of: SHA512.hash(data: byteArr)) {
            d.append(contentsOf: $0)
        }
        return d
    }
}
