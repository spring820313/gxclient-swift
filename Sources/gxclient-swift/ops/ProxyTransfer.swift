//
//  ProxyTransfer.swift
//  gxclient-swift
//
//  Created by xgc on 2019/8/4.
//

import Foundation

public struct SignedProxyTransferParams: GxcCodable, Equatable {
    public var from: GrapheneId
    public var to: GrapheneId
    public var proxyAccount: GrapheneId
    public var amount: AssetAmount
    public var percentage: UInt16
    public var memo: String
    public var expiration: Date
    public var signatures: [String] = []
    
    public init(
        from: GrapheneId,
        to: GrapheneId,
        proxyAccount: GrapheneId,
        amount: AssetAmount,
        percentage: UInt16,
        memo: String,
        expiration: Date
        ) {
        self.from = from
        self.to = to
        self.proxyAccount = proxyAccount
        self.amount = amount
        self.percentage = percentage
        self.memo = memo
        self.expiration = expiration
        self.signatures = []
    }
    
    public func toUnsignBytes(_ signed: Bool) throws -> Data {
        let encoder = GxcEncoder()
        try from.binaryEncode(to: encoder)
        try to.binaryEncode(to: encoder)
        try proxyAccount.binaryEncode(to: encoder)
        try amount.binaryEncode(to: encoder)
        percentage.binaryEncode(to: encoder)
        memo.binaryEncode(to: encoder)
        try expiration.binaryEncode(to: encoder)
        if signed == false {
            encoder.data.append(0)
        }
        return encoder.data
    }
    
    public mutating func sign(_ wif: String) throws {
        let msgBytes = try toUnsignBytes(false)
        let d = msgBytes.sha256Digest()
        
        guard let key = PrivateKey(wif) else {
            return
        }
        let signature = try key.sign(message: d)
        self.signatures.append("\(signature)")
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        let unsigned = try toUnsignBytes(true)
        try encoder.encode(unsigned)
        
        let sigSize = self.signatures.count
        try encoder.encode(sigSize)
        
        for s in self.signatures {
            let sig = Data(hexEncoded: s)
            try encoder.encode(sig)
        }
        
    }
    
}


public struct ProxyTransfer: OperationType, Equatable {
    public var fee: AssetAmount
    public var proxyMemo: String
    public var requestParams: SignedProxyTransferParams
    public var extensions: [String] = []
    
    public init(
        fee: AssetAmount,
        proxyMemo: String,
        requestParams: SignedProxyTransferParams
        ) {
        self.fee = fee
        self.proxyMemo = proxyMemo
        self.requestParams = requestParams
        self.extensions = []
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.proxyMemo)
        try encoder.encode(self.fee)
        try encoder.encode(self.requestParams)
        encoder.data.append(0)
    }
    
}
