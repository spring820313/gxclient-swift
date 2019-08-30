//
//  CallContract.swift
//  gxclient-swift
//
//  Created by xgc on 2019/8/5.
//

import Foundation


public struct CallContract: OperationType, Equatable {
    public var fee: AssetAmount
    public var account: GrapheneId
    public var contractId: GrapheneId
    public var amount: AssetAmount?
    public var methodName: Name
    public var data: String
    public var extensions: [String] = []
    
    public init(
        fee: AssetAmount,
        account: GrapheneId,
        contractId: GrapheneId,
        amount: AssetAmount?,
        methodName: Name,
        data: String
        ) {
        self.fee = fee
        self.account = account
        self.contractId = contractId
        self.amount = amount
        self.methodName = methodName
        self.data = data
        self.extensions = []
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.fee)
        try encoder.encode(self.account)
        try encoder.encode(self.contractId)
        try encoder.encode(self.amount)
        try encoder.encode(self.methodName)
        try encoder.encode(self.data)
        encoder.data.append(0)
    }
    
}
