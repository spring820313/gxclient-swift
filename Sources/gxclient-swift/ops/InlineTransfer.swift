import Foundation

public struct InlineTransfer: OperationType, Equatable {
	public var fee: AssetAmount
	public var from: GrapheneId
	public var to: GrapheneId
	public var amount: AssetAmount
	public var memo: String
	public var extensions: [String] = []
    
    public init(
	    fee: AssetAmount,
		from: GrapheneId,
		to: GrapheneId,
		amount: AssetAmount,
		memo: String
        ) {
		self.fee = fee
		self.from = from
        self.to = to
		self.amount = amount
		self.memo = memo
        self.extensions = []
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.fee)
		try encoder.encode(self.from)
        try encoder.encode(self.to)
		try encoder.encode(self.amount)
		try encoder.encode(self.memo)
        encoder.data.append(0)
    }
    
}