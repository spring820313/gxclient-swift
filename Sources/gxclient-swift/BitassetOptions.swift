import Foundation


public struct BitassetOptions: GxcCodable, Equatable {
    public var feedLifetimeSec: UInt32
	public var minimumFeeds: UInt8
	public var forceSettlementDelaySec: UInt32
	public var forceSettlementOffsetPercent: UInt16
	public var maximumForceSettlementVolume: UInt16
    public var shortBackingAsset: GrapheneId
	public var extensions: [String] = []
    
    public init(feedLifetimeSec: UInt32, 
				minimumFeeds: UInt8,
				forceSettlementDelaySec: UInt32,
				forceSettlementOffsetPercent: UInt16,
				maximumForceSettlementVolume: UInt16,
				shortBackingAsset: GrapheneId
				) {
        self.feedLifetimeSec = feedLifetimeSec
        self.minimumFeeds = minimumFeeds
		self.forceSettlementDelaySec = forceSettlementDelaySec
        self.forceSettlementOffsetPercent = forceSettlementOffsetPercent
		self.maximumForceSettlementVolume = maximumForceSettlementVolume
		self.shortBackingAsset = shortBackingAsset
		self.extensions = []
    }
    
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.feedLifetimeSec)
        try encoder.encode(self.minimumFeeds)
		try encoder.encode(self.forceSettlementDelaySec)
        try encoder.encode(self.forceSettlementOffsetPercent)
		try encoder.encode(self.maximumForceSettlementVolume)
		try encoder.encode(self.shortBackingAsset)
		encoder.data.append(0)
    }
    
}