//
//  KeyPair.swift
//  gxclient-swift
//
//  Created by xgc on 2019/8/1.
//

import Foundation

public struct KeyPair {
    public var publicKey: String
    public var privateKey: String
    public var brainKey: String
    
    
    public init(brainKey: String, privateKey: String, publicKey: String) {
        self.brainKey = brainKey
        self.privateKey = privateKey
        self.publicKey = publicKey
    }
    
    static public func fromSeed(_ seed: String? = nil) -> KeyPair? {
        var mnemonic:String?
        
        if seed == nil {
            let language: CKMnemonicLanguageType = .english
            mnemonic = try? CKMnemonic.generateMnemonic(strength: 128, language: language)
        } else {
            mnemonic = seed!
        }
        
        guard let mne = mnemonic else {
            return nil
        }

        let priKey: PrivateKey = PrivateKey(seed: mne)!
        let fromPub  = priKey.createPublic()
        
        return KeyPair(brainKey: mne, privateKey: priKey.wif, publicKey: fromPub.address)
        
    }
}
