import Foundation

public struct OverrideTransfer: OperationType, Equatable {
	public var fee: AssetAmount
	public var issuer: GrapheneId
	public var from: GrapheneId
	public var to: GrapheneId
	public var amount: AssetAmount
	public var memo: Memo?
	public var extensions: [String] = []
    
    public init(
	    fee: AssetAmount,
		issuer: GrapheneId,
		from: GrapheneId,
		to: GrapheneId,
		amount: AssetAmount,
		memo: Memo? = nil
        ) {
		self.fee = fee
		self.issuer = issuer
        self.from = from
		self.to = to
		self.amount = amount
        self.memo = memo
        self.extensions = []
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.fee)
		try encoder.encode(self.issuer)
        try encoder.encode(self.from)
		try encoder.encode(self.to)
		try encoder.encode(self.amount)
        try encoder.encode(self.memo)
        encoder.data.append(0)
    }
    
}