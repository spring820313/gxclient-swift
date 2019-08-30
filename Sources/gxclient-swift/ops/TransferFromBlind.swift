import Foundation

//no

public struct TransferFromBlind: OperationType, Equatable {
	public var fee: AssetAmount
	public var amount: AssetAmount
	public var to: GrapheneId
	public var blindingFactor: String
	public var inputs: [BlindInput]
    
    public init(
	    fee: AssetAmount,
		amount: AssetAmount,
		to: GrapheneId,
		blindingFactor: String,
		inputs: [BlindInput]
        ) {
		self.fee = fee
		self.amount = amount
        self.to = to
		self.blindingFactor = blindingFactor
		self.inputs = inputs
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.fee)
		try encoder.encode(self.amount)
        try encoder.encode(self.to)
		try encoder.encode(self.blindingFactor)
		try encoder.encode(self.inputs)
    }
    
}