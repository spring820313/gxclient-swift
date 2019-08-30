//
//  Memo.swift
//  gxclient-swift
//
//  Created by xgc on 2019/7/18.
//

import Foundation


public struct Memo: GxcCodable, Equatable {
    public var from: PublicKey
    public var to: PublicKey
    public var nonce: UInt64
    public var message: String = ""
    
    
    public init(from: PublicKey, to: PublicKey, nonce: UInt64, message: String) {
        self.from = from
        self.to = to
        self.nonce = nonce
        self.message = message
    }
    
    /// Create a new transaction.
    public init?(fromPrivKey: String, to: String, utf8Msg: String?) {
        guard let priKey = PrivateKey(fromPrivKey) else {
            return nil
        }
        let fromPub  = priKey.createPublic()
        guard let toPub = PublicKey(to) else {
            return nil
        }
        let nonce:UInt64  = UInt64.random()
        var message = ""
        if utf8Msg != nil {
            message = Aes.encryptWithChecksum(fromPrivKey, to, String(nonce), utf8Msg!)!.toHexString()
        }
        
        self.init(from: fromPub, to: toPub, nonce: nonce, message: message)
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.from)
        try encoder.encode(self.to)
        try encoder.encode(self.nonce)
        if self.message.isEmpty {
            try encoder.encode(UInt(0))
        } else {
            let data = Data(hex: self.message)
            try encoder.encode(UInt(data.count))
            try encoder.encode(data)
        }
    }
    

}

extension Memo {
    fileprivate enum Key: CodingKey {
        case from
        case to
        case nonce
        case message
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        self.from = try container.decode(PublicKey.self, forKey: .from)
        self.to = try container.decode(PublicKey.self, forKey: .to)
        self.nonce = try container.decode(UInt64.self, forKey: .nonce)
        self.message = try container.decode(String.self, forKey: .message)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        try container.encode(self.from, forKey: .from)
        try container.encode(self.to, forKey: .to)
        try container.encode(self.nonce, forKey: .nonce)
        try container.encode(self.message, forKey: .message)
    }
}
