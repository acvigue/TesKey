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
    private var privKey: P256.KeyAgreement.PrivateKey? = nil;
    var agreedSymmetricKey: Data? = nil;
    private var pubKeyBytes: Data? = nil;
    private var verifierPubKey: P256.KeyAgreement.PublicKey? = nil;
    private var defaults = UserDefaults();
    private var sessionManager: SessionManager;
    private var uuid: UUID;
    
    private var logger = Logger(subsystem: "Tesla", category: "Signer")
    
    init(uuid: UUID, sessionManager: SessionManager) {
        self.sessionManager = sessionManager
        self.uuid = uuid
        super.init()
        
        loadKeys()
    }
    
    func getPublicKey() -> Data {
        logger.debug("public key (signer) bytes: \(self.pubKeyBytes!.hexEncodedString())")
        return pubKeyBytes ?? Data()
    }
    
    func getKeyId() -> Data {
        var sha1Hash = Data()
        var ourSHA1 = Insecure.SHA1.init()
        ourSHA1.update(data: getPublicKey())
        ourSHA1.finalize().withUnsafeBytes { bytes in
            sha1Hash.append(contentsOf: bytes)
        }
        sha1Hash = sha1Hash.dropLast(sha1Hash.count - 4)
        return sha1Hash
    }
    
    func setVerifierPubKey(_ key: Data) {
        verifierPubKey = try! P256.KeyAgreement.PublicKey(x963Representation: key)

        logger.debug("public key (verifier) bytes: \((key).hexEncodedString())")
        doKeyExchange()
    }
    
    func doKeyExchange() {
        var ssData = Data()

        try! privKey!.sharedSecretFromKeyAgreement(with: verifierPubKey!).withUnsafeBytes { byte in
            ssData.append(contentsOf: byte)
        }

        print("ECDH secret: \(ssData.hexEncodedString())")

        var hashData = Data()
        Insecure.SHA1.hash(data: ssData).withUnsafeBytes { byte in
            hashData.append(contentsOf: byte)
        }

        hashData = hashData[0...15]
        
        agreedSymmetricKey = hashData
        logger.debug("Agreed symmetric key: \((self.agreedSymmetricKey! as Data).hexEncodedString())")
    }
    
    private func loadKeys() {
        // Clients can check if publicKey has been enrolled and synchronized
        //with the infotainment system by attempting to call v.SessionInfo
        //with the domain argument set to [universal.Domain_DOMAIN_INFOTAINMENT].

        //function will attempt to load key from the secure enclave, else
        //it will generate one and store it
        let tag = "me.vigue.teskey_se.\(uuid.uuidString)"
        do {
            privKey = try SecKeyStore().readKey(label: tag)
            if(privKey == nil) {
                createKeys(tag: tag)
                return;
            }
            pubKeyBytes = privKey!.publicKey.x963Representation
            logger.info("Loaded signer private key from SE (\(tag)): \(self.privKey!.pemRepresentation)")
        } catch {
            createKeys(tag: tag)
        }
    }
    
    private func createKeys(tag: String) {
        privKey = P256.KeyAgreement.PrivateKey()
        logger.info("Created signer private key in SE (\(tag)): \(self.privKey!.pemRepresentation)")
        try! SecKeyStore().storeKey(privKey!, label: tag)
        pubKeyBytes = privKey!.publicKey.x963Representation
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
            let _ = 1;
            
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
            
            let _ = editableMessage.protobufMessageAsBytes
            
            
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
}
