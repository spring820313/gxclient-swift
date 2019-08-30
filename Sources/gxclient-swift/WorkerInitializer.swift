import Foundation

public protocol BaseWorkerInitializer:GxcCodable{
    
}

public struct RefundWorkerInitializer: BaseWorkerInitializer, Equatable {
    
}

public struct VestingBalanceWorkerInitializer: BaseWorkerInitializer, Equatable {
    public var payVestingPeriodDays: UInt16
    
    public init(payVestingPeriodDays: UInt16
				) {
        self.payVestingPeriodDays = payVestingPeriodDays
    }
    
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.payVestingPeriodDays)
    }
    
}

public struct BurnWorkerInitializer: BaseWorkerInitializer, Equatable {
    
}



public struct WorkerInitializer: GxcCodable {
    public var typ: WorkerInitializerType
	public var initializer: BaseWorkerInitializer
    
    public init(type: WorkerInitializerType,
				initializer: BaseWorkerInitializer
				) {
        self.typ = type
		self.initializer = initializer
    }
	
	 public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
  
        let typ = try WorkerInitializerType(rawValue: container.decode(UInt8.self))!
        let tmp: BaseWorkerInitializer
        switch typ {
        case .Refund: tmp = try container.decode(RefundWorkerInitializer.self)
        case .VestingBalance: tmp = try container.decode(VestingBalanceWorkerInitializer.self)
		case .Burn: tmp = try container.decode(BurnWorkerInitializer.self)
        }
        self.typ = typ
		self.initializer = tmp
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(typ.rawValue)
        switch initializer {
        case let op as RefundWorkerInitializer:
            try container.encode(op)
        case let op as VestingBalanceWorkerInitializer:
            try container.encode(op)
		case let op as BurnWorkerInitializer:
            try container.encode(op)
        default:
            throw EncodingError.invalidValue(initializer, EncodingError.Context(
                codingPath: container.codingPath, debugDescription: "Encountered unknown type"))
        }
    }
    
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(typ.rawValue)
        switch initializer {
        case let op as AccountNameEqLitPredicate:
            try encoder.encode(op)
        case let op as AssetSymbolEqLitPredicate:
            try encoder.encode(op)
		case let op as BlockIdPredicate:
            try encoder.encode(op)
        default:
            throw GxcEncoder.Error.typeNotConformingToSteemEncodable(type(of: initializer))
        }
    }
    
}
