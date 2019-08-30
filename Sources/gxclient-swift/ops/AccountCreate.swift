//
//  AccountCreate.swift
//  gxclient-swift
//
//  Created by xgc on 2019/8/6.
//

import Foundation

public struct AccountCreate: OperationType, Equatable {
    public var fee: AssetAmount
    public var registrar: GrapheneId
    public var referrer: GrapheneId
    public var referrerPercent: UInt16
    public var owner: Authority
    public var active: Authority
    public var name: String
    public var options: API.AccountOptions
    public var extensions: [String] = []
    
    
    public init(
        fee: AssetAmount,
        registrar: GrapheneId,
        referrer: GrapheneId,
        referrerPercent: UInt16,
        owner: Authority,
        active: Authority,
        name: String,
        options: API.AccountOptions
        ) {
        self.fee = fee
        self.registrar = registrar
        self.referrer = referrer
        self.owner = owner
        self.active = active
        self.referrerPercent = referrerPercent
        self.name = name
        self.options = options
    }
    
    fileprivate enum Key: CodingKey {
        case fee
        case registrar
        case referrer
        case owner
        case active
        case referrerPercent
        case name
        case options
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        self.fee = try container.decode(AssetAmount.self, forKey: .fee)
        self.registrar = try container.decode(GrapheneId.self, forKey: .registrar)
        self.referrer = try container.decode(GrapheneId.self, forKey: .referrer)
        self.owner = try container.decode(Authority.self, forKey: .owner)
        self.active = try container.decode(Authority.self, forKey: .active)
        self.referrerPercent = try container.decode(UInt16.self, forKey: .referrerPercent)
        self.name = try container.decode(String.self, forKey: .name)
        self.options = try container.decode(API.AccountOptions.self, forKey: .options)
        self.extensions = []
    }
    
}
