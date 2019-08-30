//
//  AccountWhitelist.swift
//  gxclient-swift
//
//  Created by xgc on 2019/8/6.
//

import Foundation

public struct AccountWhitelist: OperationType, Equatable {
    public var fee: AssetAmount
    public var accountToList: GrapheneId
    public var authorizingAccount: GrapheneId
    public var newListing: UInt8
    public var extensions: [String] = []
    
    
    public init(
        fee: AssetAmount,
        accountToList: GrapheneId,
        authorizingAccount: GrapheneId,
        newListing: UInt8
        ) {
        self.fee = fee
        self.accountToList = accountToList
        self.authorizingAccount = authorizingAccount
        self.newListing = newListing
        
    }
    
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.fee)
        try encoder.encode(self.accountToList)
        try encoder.encode(self.authorizingAccount)
        try encoder.encode(self.newListing)
        encoder.data.append(0)
    }
    
}
