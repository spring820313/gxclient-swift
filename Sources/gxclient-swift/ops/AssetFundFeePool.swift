import Foundation

public struct AssetFundFeePool: OperationType, Equatable {
    public var fee: AssetAmount
    public var fromAccount: GrapheneId
    public var assetId: GrapheneId
	public var amount: UInt64
    public var extensions: [String] = []
    
    public init(
        fee: AssetAmount,
        fromAccount: GrapheneId,
        assetId: GrapheneId,
		amount: UInt64
        ) {
        self.fee = fee
        self.fromAccount = fromAccount
        self.assetId = assetId
		self.amount = amount
        self.extensions = []
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.fee)
        try encoder.encode(self.fromAccount)
        try encoder.encode(self.assetId)
		try encoder.encode(self.amount)
        encoder.data.append(0)
    }
    
}