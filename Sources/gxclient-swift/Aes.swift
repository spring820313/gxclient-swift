//
//  AES.swift
//  gxclient-swift
//
//  Created by xgc on 2019/7/19.
//

import Foundation
import CryptoSwift

class Aes {
    class func cbcEncrypt(_ srcData: Array<UInt8>, _ key: Array<UInt8>, _ iv: Array<UInt8>) -> Array<UInt8>?{
        let encrypted = try? AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs7).encrypt(srcData)
        return encrypted
    }
    
    class func cbcDecrypt(_ encryptedData: Array<UInt8>, _ key: Array<UInt8>, _ iv: Array<UInt8>) -> Array<UInt8>?{
        let decrypted = try? AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs7).decrypt(encryptedData)
        return decrypted
    }
    
    class func encryptWithChecksum(_ privateKey: String, _ pubkey: String, _ nonce: String, _ message: String) -> Array<UInt8>? {
        guard let priKey = PrivateKey(privateKey) else {
            return nil
        }

        guard let pubKey = PublicKey(pubkey) else {
            return nil
        }
        
        let sharedSecret = priKey.sharedSecret(pubkey: pubKey)
        let hexShared = sharedSecret!.toHexString()
        
        var result = Data()
        result.append(nonce.data(using: String.Encoding.utf8)!)
        result.append(hexShared.data(using: String.Encoding.utf8)!)
        
        let out = result.sha512()
        let key = out.subdata(in: 0..<32)
        let iv = out.subdata(in: 32..<48)
        
        let hd = message.data(using: String.Encoding.utf8)!.sha256()
        var checksum = hd.subdata(in: 0..<4)
        checksum.append(message.data(using: String.Encoding.utf8)!)
        /*
        let len = checksum.bytes.count
        if len % 16 != 0 {
            let pad = 16 - len % 16
            let nPad = Data.init(repeating: UInt8(pad), count: pad)
            checksum.append(nPad)
        }*/
        
        let ret = cbcEncrypt([UInt8](checksum), [UInt8](key), [UInt8](iv))
        
        return ret
    }
    
    class func decryptWithChecksum(_ privateKey: String, _ pubkey: String, _ nonce: String, _ encryptedMessage: String) -> String? {
        guard let priKey = PrivateKey(privateKey) else {
            return nil
        }
        
        guard let pubKey = PublicKey(pubkey) else {
            return nil
        }
        
        let sharedSecret = priKey.sharedSecret(pubkey: pubKey)
        let hexShared = sharedSecret!.toHexString()
        
        var result = Data()
        result.append(nonce.data(using: String.Encoding.utf8)!)
        result.append(hexShared.data(using: String.Encoding.utf8)!)
        
        let out = result.sha512()
        let key = out.subdata(in: 0..<32)
        let iv = out.subdata(in: 32..<48)
        
        let encryptedData = Data(hex: encryptedMessage)
        
        let ret = cbcDecrypt([UInt8](encryptedData), [UInt8](key), [UInt8](iv))
        if ret == nil {
            return nil
        }
        let len = ret!.count
        let msgData = Data(ret!).subdata(in: 4..<len)
        return String(data: msgData, encoding: String.Encoding.utf8)
    }
}
