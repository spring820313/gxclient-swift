//
//  AccountTransfer.swift
//  gxclient-swift
//
//  Created by xgc on 2019/8/6.
//

import Foundation

public struct AccountTransfer: OperationType, Equatable {
    public var fee: AssetAmount
    public var accountId: GrapheneId
    public var newOwner: GrapheneId
    public var extensions: [String] = []
    
    
    public init(
        fee: AssetAmount,
        accountId: GrapheneId,
        newOwner: GrapheneId
        ) {
        self.fee = fee
        self.accountId = accountId
        self.newOwner = newOwner

    }
    
    fileprivate enum Key: CodingKey {
        case fee
        case accountId
        case newOwner
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        self.fee = try container.decode(AssetAmount.self, forKey: .fee)
        self.accountId = try container.decode(GrapheneId.self, forKey: .accountId)
        self.newOwner = try container.decode(GrapheneId.self, forKey: .newOwner)
        self.extensions = []
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.fee)
        try encoder.encode(self.accountId)
        try encoder.encode(self.newOwner)
        encoder.data.append(0)
    }
    
}
