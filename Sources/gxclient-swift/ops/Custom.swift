import Foundation

//no

public struct Custom: OperationType, Equatable {
    public var fee: AssetAmount
	public var payer: GrapheneId
	public var requiredAuths: [GrapheneId]
    public var id: UInt16
	public var data: Data?
    
    public init(
        fee: AssetAmount,
		payer: GrapheneId,
		requiredAuths: [GrapheneId],
        id: UInt16,
		data: Data? = nil
        ) {
        self.fee = fee
		self.payer = payer
		self.requiredAuths = requiredAuths
        self.id = id
		self.data = data
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.fee)
		try encoder.encode(self.payer)
		try encoder.encode(self.requiredAuths)
        try encoder.encode(self.id)
		try encoder.encode(self.data)
    }
    
}