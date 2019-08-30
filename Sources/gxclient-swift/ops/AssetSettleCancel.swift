import Foundation

public struct AssetSettleCancel: OperationType, Equatable {
    public var fee: AssetAmount
	public var settlement: GrapheneId
    public var account: GrapheneId
	public var amount: AssetAmount
    public var extensions: [String] = []
    
    public init(
        fee: AssetAmount,
		settlement: GrapheneId,
        account: GrapheneId,
        amount: AssetAmount
        ) {
        self.fee = fee
		self.settlement = settlement
        self.account = account
        self.amount = amount
        self.extensions = []
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.fee)
		try encoder.encode(self.settlement)
        try encoder.encode(self.account)
        try encoder.encode(self.amount)
        encoder.data.append(0)
    }
    
}