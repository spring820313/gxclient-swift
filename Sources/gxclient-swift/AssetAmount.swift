//
//  AssetAmount.swift
//  gxclient-swift
//
//  Created by xgc on 2019/7/26.
//

import Foundation

public struct AssetAmount: Equatable {
    internal var amount: UInt64
    internal var assetId: GrapheneId
    
    
    public init(_ id: GrapheneId, _ amount: UInt64) {
        self.assetId = id
        self.amount = amount
    }
}


extension AssetAmount: GxcEncodable, Decodable {
    fileprivate enum Key: CodingKey {
        case amount
        case assetId
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        self.assetId = try container.decode(GrapheneId.self, forKey: .assetId)
        self.amount = try container.decode(UInt64.self, forKey: .amount)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        try container.encode(self.amount, forKey: .amount)
        try container.encode(self.assetId, forKey: .assetId)
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.amount)
        try encoder.encode(self.assetId)
    }
}
