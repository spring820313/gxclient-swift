//
//  CreateContract.swift
//  gxclient-swift
//
//  Created by xgc on 2019/8/5.
//

import Foundation

public struct CreateContract: OperationType, Equatable {
    public var fee: AssetAmount
    public var name: String
    public var account: GrapheneId
    public var vmType: String
    public var vmVersion: String
    public var code: String
    public var abi: Abi
    public var extensions: [String] = []
    
    public init(
        fee: AssetAmount,
        name: String,
        account: GrapheneId,
        vmType: String,
        vmVersion: String,
        code: String,
        abi: Abi
        ) {
        self.fee = fee
        self.account = account
        self.name = name
        self.vmType = vmType
        self.vmVersion = vmVersion
        self.code = code
        self.abi = abi
        self.extensions = []
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.fee)
        try encoder.encode(self.name)
        try encoder.encode(self.account)
        try encoder.encode(self.vmType)
        try encoder.encode(self.vmVersion)
        let codeBytes = Data(hexEncoded: self.code)
        try encoder.encode(codeBytes.count)
        try encoder.encode(codeBytes)
        try encoder.encode(self.abi)
        encoder.data.append(0)
    }
    
}
