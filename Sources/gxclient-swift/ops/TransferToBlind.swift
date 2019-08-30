import Foundation

//no

public struct TransferToBlind: OperationType, Equatable {
	public var fee: AssetAmount
	public var amount: AssetAmount
	public var from: GrapheneId
	public var blindingFactor: String
	public var outputs: [BlindOutput]
    
    public init(
	    fee: AssetAmount,
		amount: AssetAmount,
		from: GrapheneId,
		blindingFactor: String,
		outputs: [BlindOutput]
        ) {
		self.fee = fee
		self.amount = amount
        self.from = from
		self.blindingFactor = blindingFactor
		self.outputs = outputs
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.fee)
		try encoder.encode(self.amount)
        try encoder.encode(self.from)
		try encoder.encode(self.blindingFactor)
		try encoder.encode(self.outputs)
    }
    
}