import Foundation

public protocol BasePredicate:GxcCodable{
    
}

public struct AccountNameEqLitPredicate: BasePredicate {
    public var accountId: GrapheneId
	public var name: String
    
    public init(accountId: GrapheneId, 
				name: String
				) {
        self.accountId = accountId
        self.name = name
    }
    
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.accountId)
        try encoder.encode(self.name)
    }
    
}

public struct AssetSymbolEqLitPredicate: BasePredicate {
    public var assetId: GrapheneId
	public var symbol: String
    
    public init(assetId: GrapheneId, 
				symbol: String
				) {
        self.assetId = assetId
        self.symbol = symbol
    }
    
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.assetId)
        try encoder.encode(self.symbol)
    }
    
}

public struct BlockIdPredicate: BasePredicate {
    public var id: [UInt8]
    
    public init(id: [UInt8]
				) {
        self.id = id
    }
    
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(UInt(id.count))
        try encoder.encode(self.id)
    }
    
}



public struct Predicate: GxcCodable {
    public var typ: PredicateType
	public var pre: BasePredicate
    
    public init<O>(type: PredicateType,
				pre: O
				) where O: BasePredicate {
        self.typ = type
		self.pre = pre
    }
	
	 public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
  
        let typ = try PredicateType(rawValue: container.decode(UInt8.self))!
        let tmp: BasePredicate
        switch typ {
        case .AccountNameEqLit: tmp = try container.decode(AccountNameEqLitPredicate.self)
        case .AssetSymbolEqLit: tmp = try container.decode(AssetSymbolEqLitPredicate.self)
		case .BlockId: tmp = try container.decode(BlockIdPredicate.self)
        }
        self.typ = typ
		self.pre = tmp
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(typ.rawValue)
        switch pre {
        case let op as AccountNameEqLitPredicate:
            try container.encode(op)
        case let op as AssetSymbolEqLitPredicate:
            try container.encode(op)
		case let op as BlockIdPredicate:
            try container.encode(op)
        default:
            throw EncodingError.invalidValue(pre, EncodingError.Context(
                codingPath: container.codingPath, debugDescription: "Encountered unknown type"))
        }
    }
    
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(typ.rawValue)
        switch pre {
        case let op as AccountNameEqLitPredicate:
            try encoder.encode(op)
        case let op as AssetSymbolEqLitPredicate:
            try encoder.encode(op)
		case let op as BlockIdPredicate:
            try encoder.encode(op)
        default:
            throw GxcEncoder.Error.typeNotConformingToSteemEncodable(type(of: self.pre))
        }
    }
    
}
