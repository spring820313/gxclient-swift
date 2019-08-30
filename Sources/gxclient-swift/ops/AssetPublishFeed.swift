import Foundation

public struct AssetPublishFeed: OperationType, Equatable {
    public var fee: AssetAmount
    public var publisher: GrapheneId
	public var assetId: GrapheneId
	public var feed: PriceFeed
    public var extensions: [String] = []
    
    public init(
        fee: AssetAmount,
        publisher: GrapheneId,
        assetId: GrapheneId,
		feed: PriceFeed
        ) {
        self.fee = fee
        self.publisher = publisher
        self.assetId = assetId
		self.feed = feed
        self.extensions = []
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.fee)
        try encoder.encode(self.publisher)
        try encoder.encode(self.assetId)
		try encoder.encode(self.feed)
        encoder.data.append(0)
    }
    
}