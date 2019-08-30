import Foundation

public struct LimitOrderCreate: OperationType, Equatable {
	public var fee: AssetAmount
	public var seller: GrapheneId
	public var amountToSell: AssetAmount
	public var minToReceive: AssetAmount
	public var expiration: Date
	public var fillOrKill: Bool
	public var extensions: [String] = []
    
    public init(
	    fee: AssetAmount,
		seller: GrapheneId,
		amountToSell: AssetAmount,
		minToReceive: AssetAmount,
		expiration: Date,
		fillOrKill: Bool
        ) {
		self.fee = fee
		self.seller = seller
        self.amountToSell = amountToSell
		self.minToReceive = minToReceive
		self.expiration = expiration
        self.fillOrKill = fillOrKill
        self.extensions = []
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.fee)
		try encoder.encode(self.seller)
        try encoder.encode(self.amountToSell)
		try encoder.encode(self.minToReceive)
		try encoder.encode(self.expiration)
        try encoder.encode(self.fillOrKill)
        encoder.data.append(0)
    }
    
}