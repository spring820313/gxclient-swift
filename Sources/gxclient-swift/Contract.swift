//
//  Contract.swift
//  gxclient-swift
//
//  Created by xgc on 2019/7/31.
//

import Foundation
import AnyCodable

public struct TypeDef: GxcCodable, Equatable {
    public var newTypeName: String
    public var type: String
    
    
    public init(newTypeName: String, type: String) {
        self.newTypeName = newTypeName
        self.type = type
    }
}

public struct ErrorMessage: GxcCodable, Equatable {
    public var errorCode: UInt64
    public var errorMsg: String
    
    
    public init(errorCode: UInt64, errorMsg: String) {
        self.errorCode = errorCode
        self.errorMsg = errorMsg
    }
}

public struct Field: GxcCodable, Equatable {
    public var name: String
    public var type: String
    
    
    public init(name: String, type: String) {
        self.name = name
        self.type = type
    }
}

public struct Struct: GxcCodable, Equatable {
    public var name: String
    public var base: String
    public var fields: [Field]
    
    
    public init(name: String, base: String, fields: [Field]) {
        self.name = name
        self.base = base
        self.fields = fields
    }
}

public struct Table: GxcCodable, Equatable {
    public var name: Name
    public var indexType: String
    public var keyNames: [String]
    public var keyTypes: [String]
    public var type: String
    
    public init(name: Name, indexType: String, keyNames: [String], keyTypes: [String], type: String) {
        self.name = name
        self.indexType = indexType
        self.keyNames = keyNames
        self.keyTypes = keyTypes
        self.type = type
    }
}

public struct Action: GxcCodable, Equatable {
    public var name: Name
    public var type: String
    public var payable: Bool
    
    
    public init(name: Name, type: String, payable: Bool) {
        self.name = name
        self.type = type
        self.payable = payable
    }
}

public struct Abi: GxcCodable, Equatable {
    public var version: String
    public var types: [TypeDef]
    public var structs: [Struct]
    public var actions: [Action]
    public var tables: [Table]
    public var errorMessages: [ErrorMessage]
    public var abiExtensions: [AnyCodable]
    
    
    public init(version: String, types: [TypeDef], structs: [Struct],
                actions: [Action], tables: [Table], errorMessages: [ErrorMessage],
                abiExtensions: [AnyCodable]) {
        self.version = version
        self.types = types
        self.structs = structs
        self.actions = actions
        self.tables = tables
        self.errorMessages = errorMessages
        self.abiExtensions = abiExtensions
    }
}

public struct ContractAccountProperties: Decodable {
    public let id:GrapheneId
    public let name:String
    public let statistics:GrapheneId
    public let membershipExpirationDate:Date
    public let networkFeePercentage:UInt64
    public let lifetimeReferrerFeePercentage:UInt64
    public let referrerRewardsPercentage:UInt64
    public let whitelistingAccounts:[String]
    public let blacklistingAccounts:[String]
    public let whitelistedAccounts:[String]
    public let blacklistedAccounts:[String]
    public let registrar:String
    public let referrer:String
    public let lifetimeReferrer:String
    public let abi: Abi
    public let vmType:String
    public let vmVersion:String
    public let code:String
    public let codeVersion:String
}

