//
//  UpdateContract.swift
//  gxclient-swift
//
//  Created by xgc on 2019/8/5.
//

import Foundation


public struct UpdateContract: OperationType, Equatable {
    public var fee: AssetAmount
    public var owner: GrapheneId
    public var newOwner: GrapheneId?
    public var contract: GrapheneId
    public var code: String
    public var abi: Abi
    public var extensions: [String] = []
    
    public init(
        fee: AssetAmount,
        owner: GrapheneId,
        newOwner: GrapheneId?,
        contract: GrapheneId,
        code: String,
        abi: Abi
        ) {
        self.fee = fee
        self.owner = owner
        self.newOwner = newOwner
        self.contract = contract
        self.code = code
        self.abi = abi
        self.extensions = []
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.fee)
        try encoder.encode(self.owner)
        try encoder.encode(self.newOwner)
        try encoder.encode(self.contract)
        let codeBytes = Data(hexEncoded: self.code)
        try encoder.encode(codeBytes.count)
        try encoder.encode(codeBytes)
        try encoder.encode(self.abi)
        encoder.data.append(0)
    }
    
}
