//
//  Assert.swift
//  gxclient-swift
//
//  Created by xgc on 2019/8/6.
//

import Foundation

public struct Assert: OperationType, Equatable {
    public var fee: AssetAmount
    public var feePayingAccount: GrapheneId
    public var predicates: [String]
    public var requiredAuths: [GrapheneId]
    public var extensions: [String] = []
    
    
    public init(
        fee: AssetAmount,
        feePayingAccount: GrapheneId,
        predicates: [String],
        requiredAuths: [GrapheneId]
        ) {
        self.fee = fee
        self.feePayingAccount = feePayingAccount
        self.predicates = predicates
        self.requiredAuths = requiredAuths
        
    }
    
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.fee)
        try encoder.encode(self.feePayingAccount)
        try encoder.encode(self.predicates)
        try encoder.encode(self.requiredAuths)
        encoder.data.append(0)
    }
    
}
