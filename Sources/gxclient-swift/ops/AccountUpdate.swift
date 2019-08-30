//
//  AccountUpdate.swift
//  gxclient-swift
//
//  Created by xgc on 2019/8/2.
//

import Foundation

public struct AccountUpdate: OperationType, Equatable {
    public var fee: AssetAmount
    public var account: GrapheneId
    public var owner: Authority?
    public var active: Authority?
    public var newOptions: API.AccountOptions?
    public var extensions: [String] = []
    
    public init(
        fee: AssetAmount,
        account: GrapheneId,
        owner: Authority?,
        active: Authority?,
        newOptions: API.AccountOptions?
        ) {
        self.fee = fee
        self.account = account
        self.owner = owner
        self.active = active
        self.newOptions = newOptions
        self.extensions = []
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.fee)
        try encoder.encode(self.account)
        try encoder.encode(self.owner)
        try encoder.encode(self.active)
        try encoder.encode(self.newOptions)
        encoder.data.append(0)
    }
    
}
