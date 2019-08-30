import Foundation

public protocol BaseVestingPolicy:GxcCodable{
    
}

public struct CCDVestingPolicy: BaseVestingPolicy {
    public var startClaim: Date
	public var coinSecondsEarnedLastUpdate: Date
	public var vestingSeconds: UInt32
	public var coinSecondsEarned: UInt64
    
    public init(startClaim: Date, 
				coinSecondsEarnedLastUpdate: Date,
				vestingSeconds: UInt32,
				coinSecondsEarned: UInt64
				) {
        self.startClaim = startClaim
        self.coinSecondsEarnedLastUpdate = coinSecondsEarnedLastUpdate
		self.vestingSeconds = vestingSeconds
        self.coinSecondsEarned = coinSecondsEarned
    }
    
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.startClaim)
        try encoder.encode(self.coinSecondsEarnedLastUpdate)
		try encoder.encode(self.vestingSeconds)
        try encoder.encode(self.coinSecondsEarned)
    }
    
}

public struct LinearVestingPolicy: BaseVestingPolicy {
    public var beginTimestamp: Date
	public var vestingCliffSeconds: UInt32
	public var vestingDurationSeconds: UInt32
    
    public init(beginTimestamp: Date, 
				vestingCliffSeconds: UInt32,
				vestingDurationSeconds: UInt32
				) {
        self.beginTimestamp = beginTimestamp
        self.vestingCliffSeconds = vestingCliffSeconds
		self.vestingDurationSeconds = vestingDurationSeconds
    }
    
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.beginTimestamp)
        try encoder.encode(self.vestingCliffSeconds)
		try encoder.encode(self.vestingDurationSeconds)
    }
    
}

public struct VestingPolicy: GxcCodable {
    public var typ: VestingPolicyType
	public var data: BaseVestingPolicy
    
    public init(type: VestingPolicyType,
				data: BaseVestingPolicy
				) {
        self.typ = type
		self.data = data
    }
	
	 public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
  
        let typ = try VestingPolicyType(rawValue: container.decode(UInt8.self))!
        let tmp: BaseVestingPolicy
        switch typ {
        case .CCD: tmp = try container.decode(CCDVestingPolicy.self)
        case .Linear: tmp = try container.decode(LinearVestingPolicy.self)
        }
        self.typ = typ
		self.data = tmp
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(typ.rawValue)
        switch data {
        case let op as CCDVestingPolicy:
            try container.encode(op)
        case let op as LinearVestingPolicy:
            try container.encode(op)
        default:
            throw EncodingError.invalidValue(data, EncodingError.Context(
                codingPath: container.codingPath, debugDescription: "Encountered unknown type"))
        }
    }
    
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(typ.rawValue)
        switch data {
        case let op as CCDVestingPolicy:
            try encoder.encode(op)
        case let op as LinearVestingPolicy:
            try encoder.encode(op)
        default:
            throw GxcEncoder.Error.typeNotConformingToSteemEncodable(type(of: data))
        }
    }
    
}
