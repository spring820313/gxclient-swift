import Foundation


public struct AssetFeed: GxcCodable, Equatable {
    public var providerId: GrapheneId
	public var dateTime: Date
	public var feedInfo: PriceFeed
    
    public init(providerId: GrapheneId, 
				dateTime: Date,
				feedInfo: PriceFeed
				) {
        self.providerId = providerId
        self.dateTime = dateTime
		self.feedInfo = feedInfo
    }
    
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.providerId)
        try encoder.encode(self.dateTime)
		try encoder.encode(self.feedInfo)
    }
    
}