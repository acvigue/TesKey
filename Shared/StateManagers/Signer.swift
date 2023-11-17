// Signer.swift
//  TesKey Watch App
//
//  Created by aiden on 11/15/23.
//  
//

import Foundation
import CryptoKit
import os

enum AuthMethod {
    case None
    case Encrypt
}

class Signer: NSObject {
    private var vin: String
    private var privKey: SecKey? = nil;
    private var agreedSymmetricKey: SymmetricKey? = nil;
    private var pubKeyBytes: Data? = nil;
    private var verifierPubKeyBytes: Data? = nil;
    private var defaults = UserDefaults();
    private var sessionManager: SessionManager;
    
    private var logger = Logger(subsystem: "Tesla", category: "Signer")
    
    init(vin: String, sessionManager: SessionManager) {
        self.vin = vin
        self.sessionManager = sessionManager
        super.init()
        
        loadKeys()
    }
    
    func getPublicKey() -> Data {
        logger.debug("public key (signer) bytes: \(self.pubKeyBytes!.hexEncodedString())")
        return pubKeyBytes ?? Data()
    }
    
    private func loadKeys() {
        // Clients can check if publicKey has been enrolled and synchronized
        //with the infotainment system by attempting to call v.SessionInfo
        //with the domain argument set to [universal.Domain_DOMAIN_INFOTAINMENT].
        
        let tag = "me.vigue.teskey.\(vin)".data(using: .utf8)!
        let getquery: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: tag,
            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
            kSecReturnRef as String: true
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(getquery as CFDictionary, &item)
        if(status != errSecSuccess) {
            let attributes: [String: Any] = [
                kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
                kSecAttrKeySizeInBits as String: 256,
                kSecAttrTokenID as String: kSecAttrTokenIDSecureEnclave,
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
            logger.info("generated new SE private key for vehicle \(self.vin)")
        } else {
            logger.debug("retrieved saved SE private key for vehicle \(self.vin)")
        }
        
        privKey = (item as! SecKey)
        
        //Get uncompressed x9.62 pubkey
        guard let pubKey = SecKeyCopyPublicKey(privKey!) else { return }
        var error: Unmanaged<CFError>?
        pubKeyBytes = SecKeyCopyExternalRepresentation(pubKey, &error)! as Data
    }
    
    func genRandomData(_ len: Int) -> Data {
        var bytes = Data(count: len)
        _ = bytes.withUnsafeMutableBytes {
            SecRandomCopyBytes(kSecRandomDefault, len, $0.baseAddress!)
        }
        
        return bytes
    }
    
    func encode(_ message: RoutableMessage, _ authType: AuthMethod) -> (signedMessage: Data, messageUUID: String) {
        logger.debug("encoding message: \(message.textFormatString())")
        
        var editableMessage = message

        editableMessage.uuid = genRandomData(16)
        editableMessage.fromDestination.routingAddress = genRandomData(16)
        
        logger.debug(" -> uuid: \(editableMessage.uuid.hexEncodedString())")
        logger.debug(" -> fromRoutingAddress: \(editableMessage.fromDestination.routingAddress.hexEncodedString())")
        
        if(authType == .Encrypt) {
            var gcmData = AES_GCM_Personalized_Signature_Data()
            let counter = 1;
            
            logger.debug(" -> encrypting: \(editableMessage.uuid)")
            
            gcmData.counter = 0
            gcmData.epoch = Data()
            
            //uint32(time.Now().Add(expiresIn).Sub(s.timeZero) / time.Second)
            var expiresAt = NSDate.now
            let calendar = NSCalendar.autoupdatingCurrent
            
            expiresAt = calendar.date(byAdding: .second, value: 5, to: expiresAt)!
            expiresAt = calendar.date(byAdding: .second, value: 5, to: expiresAt)!
            gcmData.expiresAt = UInt32(NSDate().timeIntervalSince1970 + 5)
            
            editableMessage.signatureData.aesGcmPersonalizedData = gcmData
            
            let m = extractMetadata(editableMessage, signatureType: SignatureType(rawValue: 5)!)
            
            let plaintext = editableMessage.protobufMessageAsBytes
            
            
            editableMessage.signatureData.signerIdentity.publicKey = pubKeyBytes!
            return (signedMessage: Data(), messageUUID: "")
        } else {
            logger.debug(" -> not encrypting.")
            do {
                let encodedMessage = try editableMessage.serializedData()
                logger.debug(" -> encoded: \(encodedMessage.hexEncodedString())")
                
                return (signedMessage: encodedMessage, messageUUID: editableMessage.uuid.hexEncodedString())
            } catch {
                return (signedMessage: Data(), messageUUID: editableMessage.uuid.hexEncodedString())
            }
        }
    }
                                         
    private func extractMetadata(_ message: RoutableMessage, signatureType: SignatureType) -> Metadata {
        let m = Metadata()
        m.Add(tag: .SIGNATURE_TYPE, Data([UInt8(signatureType.rawValue)]))
        m.Add(tag: .DOMAIN, Data([UInt8(message.toDestination.domain.rawValue)]))
        m.Add(tag: .PERSONALIZATION, vin.data(using: .utf8)!)
        m.Add(tag: .EPOCH, Data())
        m.AddUint32(tag: .EXPIRES_AT, message.signatureData.aesGcmPersonalizedData.expiresAt)
        m.AddUint32(tag: .COUNTER, UInt32(0))
        if(message.flags > 0) {
            m.AddUint32(tag: .FLAGS, message.flags)
        }
        return m
    }
}
