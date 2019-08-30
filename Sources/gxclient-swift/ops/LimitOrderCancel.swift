import Foundation

public struct LimitOrderCancel: OperationType, Equatable {
	public var fee: AssetAmount
	public var feePayingAccount: GrapheneId
	public var order: GrapheneId
	public var extensions: [String] = []
    
    public init(
	    fee: AssetAmount,
		feePayingAccount: GrapheneId,
		order: GrapheneId
        ) {
		self.fee = fee
		self.feePayingAccount = feePayingAccount
        self.order = order
        self.extensions = []
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.fee)
		try encoder.encode(self.feePayingAccount)
        try encoder.encode(self.order)
        encoder.data.append(0)
    }
    
}