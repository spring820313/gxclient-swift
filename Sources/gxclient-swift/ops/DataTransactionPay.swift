import Foundation

public struct DataTransactionPay: OperationType, Equatable {
	public var fee: AssetAmount
	public var from: GrapheneId
	public var to: GrapheneId
	public var amount: AssetAmount
	public var requestId: String
	public var extensions: [String] = []
    
    public init(
		fee: AssetAmount,
		from: GrapheneId,
		to: GrapheneId,
		amount: AssetAmount,
		requestId: String
        ) {
		self.from = from
        self.to = to
        self.fee = fee
		self.requestId = requestId
		self.amount = amount
        self.extensions = []
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.fee)
		try encoder.encode(self.from)
        try encoder.encode(self.to)
		try encoder.encode(self.amount)
		try encoder.encode(self.requestId)
        encoder.data.append(0)
    }
    
}
