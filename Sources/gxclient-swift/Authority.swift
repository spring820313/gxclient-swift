/// Steem authority types.
/// - Author: Johan Nordberg <johan@steemit.com>

import Foundation

/// Type representing a Steem authority.
///
/// Authorities are a collection of accounts and keys that need to sign
/// a message for it to be considered valid.
public struct Authority: GxcCodable, Equatable {
    /// A type representing a key or account auth and its weight.
    public struct Auth<T: GxcCodable & Equatable>: Equatable {
        public let value: T
        public let weight: UInt16
    }

    /// Minimum signing threshold.
    public var weightThreshold: UInt32
    /// Account auths.
    public var accountAuths: [Auth<String>]
    /// Key auths.
    public var keyAuths: [Auth<PublicKey>]
}

extension Authority.Auth {
    public init(_ value: T, weight: UInt16 = 1) {
        self.value = value
        self.weight = weight
    }
}

extension Authority.Auth: GxcCodable {
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        self.value = try container.decode(T.self)
        self.weight = try container.decode(UInt16.self)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(self.value)
        try container.encode(self.weight)
    }
}

extension Authority.Auth: ExpressibleByDictionaryLiteral {
    public typealias Key = T
    public typealias Value = UInt16
    public init(dictionaryLiteral elements: (T, UInt16)...) {
        precondition(elements.count == 1, "Account auth dictionary literal can only have one entry")
        self.value = elements[0].0
        self.weight = elements[0].1
    }
}

public protocol SpecialAuthority:GxcCodable{
    
}

public struct NoSpecialAuthority: SpecialAuthority {

}

public struct TopHoldersSpecialAuthority: SpecialAuthority {
    public var asset:GrapheneId
    public var numTopHolders: UInt8
}

extension TopHoldersSpecialAuthority{
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.asset)
        try encoder.encode(self.numTopHolders)
    }
}

public struct SpecialAuth {
    public let typ: SpecialAuthorityType
    public let auth: SpecialAuthority
}


public struct OwnerSpecialAuthority:GxcCodable{
    public let sa: SpecialAuth
    
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
  
        let typ = try SpecialAuthorityType(rawValue: container.decode(UInt8.self))!
        let tmp: SpecialAuthority
        switch typ {
        case .NoSpecial: tmp = try container.decode(NoSpecialAuthority.self)
        case .TopHolders: tmp = try container.decode(TopHoldersSpecialAuthority.self)
        }
        self.sa = SpecialAuth(typ: typ, auth: tmp)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(sa.typ.rawValue)
        switch sa.auth {
        case let op as NoSpecialAuthority:
            try container.encode(op)
        case let op as TopHoldersSpecialAuthority:
            try container.encode(op)
        default:
            throw EncodingError.invalidValue(sa.auth, EncodingError.Context(
                codingPath: container.codingPath, debugDescription: "Encountered unknown type"))
        }
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(AccountCreateExtensionsType.OwnerSpecial.rawValue)
        try encoder.encode(sa.typ.rawValue)
        switch sa.auth {
        case let op as NoSpecialAuthority:
            try encoder.encode(op)
        case let op as TopHoldersSpecialAuthority:
            try encoder.encode(op)
        default:
            throw GxcEncoder.Error.typeNotConformingToSteemEncodable(type(of: sa.auth))
        }
    }
}

public struct ActiveSpecialAuthority:GxcCodable{
    public let sa: SpecialAuth
    
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        
        let typ = try SpecialAuthorityType(rawValue: container.decode(UInt8.self))!
        let tmp: SpecialAuthority
        switch typ {
        case .NoSpecial: tmp = try container.decode(NoSpecialAuthority.self)
        case .TopHolders: tmp = try container.decode(TopHoldersSpecialAuthority.self)
        }
        self.sa = SpecialAuth(typ: typ, auth: tmp)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(sa.typ.rawValue)
        switch sa.auth {
        case let op as NoSpecialAuthority:
            try container.encode(op)
        case let op as TopHoldersSpecialAuthority:
            try container.encode(op)
        default:
            throw EncodingError.invalidValue(sa.auth, EncodingError.Context(
                codingPath: container.codingPath, debugDescription: "Encountered unknown type"))
        }
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(AccountCreateExtensionsType.ActiveSpecial.rawValue)
        try encoder.encode(sa.typ.rawValue)
        switch sa.auth {
        case let op as NoSpecialAuthority:
            try encoder.encode(op)
        case let op as TopHoldersSpecialAuthority:
            try encoder.encode(op)
        default:
            throw GxcEncoder.Error.typeNotConformingToSteemEncodable(type(of: sa.auth))
        }
    }
}
