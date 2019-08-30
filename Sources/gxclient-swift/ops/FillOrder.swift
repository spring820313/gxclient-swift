import Foundation

public struct FillOrder: OperationType, Equatable {
	public var fee: AssetAmount
	public var orderId: GrapheneId
	public var accountId: GrapheneId
	public var pays: AssetAmount
	public var receives: AssetAmount
    
    public init(
	    fee: AssetAmount,
		orderId: GrapheneId,
		accountId: GrapheneId,
		pays: AssetAmount,
		receives: AssetAmount
        ) {
		self.fee = fee
		self.orderId = orderId
        self.accountId = accountId
		self.pays = pays
		self.receives = receives
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.fee)
		try encoder.encode(self.orderId)
        try encoder.encode(self.accountId)
		try encoder.encode(self.pays)
		try encoder.encode(self.receives)
    }
    
}