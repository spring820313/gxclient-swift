//
//  AccountUpgrade.swift
//  gxclient-swift
//
//  Created by xgc on 2019/8/6.
//

import Foundation

public struct AccountUpgrade: OperationType, Equatable {
    public var fee: AssetAmount
    public var accountToUpgrade: GrapheneId
    public var upgradeToLifetimeMember: Bool
    public var extensions: [String] = []
    
    
    public init(
        fee: AssetAmount,
        accountToUpgrade: GrapheneId,
        upgradeToLifetimeMember: Bool
        ) {
        self.fee = fee
        self.accountToUpgrade = accountToUpgrade
        self.upgradeToLifetimeMember = upgradeToLifetimeMember
        
    }
    
    fileprivate enum Key: CodingKey {
        case fee
        case accountToUpgrade
        case upgradeToLifetimeMember
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        self.fee = try container.decode(AssetAmount.self, forKey: .fee)
        self.accountToUpgrade = try container.decode(GrapheneId.self, forKey: .accountToUpgrade)
        self.upgradeToLifetimeMember = try container.decode(Bool.self, forKey: .upgradeToLifetimeMember)
        self.extensions = []
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.fee)
        try encoder.encode(self.accountToUpgrade)
        try encoder.encode(self.upgradeToLifetimeMember)
        encoder.data.append(0)
    }
    
}
