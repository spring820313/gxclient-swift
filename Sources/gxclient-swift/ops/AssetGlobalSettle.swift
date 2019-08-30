import Foundation

public struct AssetGlobalSettle: OperationType, Equatable {
    public var fee: AssetAmount
    public var issuer: GrapheneId
    public var assetToSettle: GrapheneId
	public var settlePrice: Price
    public var extensions: [String] = []
    
    public init(
        fee: AssetAmount,
        issuer: GrapheneId,
        assetToSettle: GrapheneId,
		settlePrice: Price
        ) {
        self.fee = fee
        self.issuer = issuer
        self.assetToSettle = assetToSettle
		self.settlePrice = settlePrice
        self.extensions = []
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.fee)
        try encoder.encode(self.issuer)
        try encoder.encode(self.assetToSettle)
		try encoder.encode(self.settlePrice)
        encoder.data.append(0)
    }
    
}