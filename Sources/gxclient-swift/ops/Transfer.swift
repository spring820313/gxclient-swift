//
//  Transfer.swift
//  gxclient-swift
//
//  Created by xgc on 2019/8/6.
//

import Foundation

public struct Transfer: OperationType, Equatable {
    public var fee: AssetAmount
    /// Account name of the sender.
    public var from: GrapheneId
    /// Account name of the reciever.
    public var to: GrapheneId
    /// Amount to transfer.
    public var amount: AssetAmount
    
    /// Note attached to transaction.
    public var memo: Memo?
    
    public var extensions:[String]
    
    public init(from: GrapheneId, to: GrapheneId, amount: AssetAmount, fee: AssetAmount, memo: Memo?) {
        self.from = from
        self.to = to
        self.amount = amount
        self.fee = fee
        self.memo = memo
        self.extensions = []
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.fee)
        try encoder.encode(self.from)
        try encoder.encode(self.to)
        try encoder.encode(self.amount)
        try encoder.encode(self.memo)
        encoder.data.append(0)
    }
}
