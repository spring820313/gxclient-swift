import Foundation


public struct AssetOptions: GxcCodable, Equatable {
    public var maxSupply: UInt64
	public var maxMarketFee: UInt64
	public var marketFeePercent: UInt16
	public var flags: UInt16
	public var description: String
	public var coreExchangeRate: Price
	public var issuerPermissions: UInt16
    public var blacklistAuthorities: [GrapheneId]
	public var whitelistAuthorities: [GrapheneId]
	public var blacklistMarkets: [GrapheneId]
	public var whitelistMarkets: [GrapheneId]
	public var extensions: [String] = []
    
    public init(maxSupply: UInt64, 
				maxMarketFee: UInt64,
				marketFeePercent: UInt16,
				flags: UInt16,
				description: String,
				coreExchangeRate: Price,
				issuerPermissions: UInt16,
				blacklistAuthorities: [GrapheneId],
				whitelistAuthorities: [GrapheneId],
				blacklistMarkets: [GrapheneId],
				whitelistMarkets: [GrapheneId]
				) {
        self.maxSupply = maxSupply
        self.maxMarketFee = maxMarketFee
		self.marketFeePercent = marketFeePercent
        self.flags = flags
		self.description = description
		self.coreExchangeRate = coreExchangeRate
		self.issuerPermissions = issuerPermissions
		self.blacklistAuthorities = blacklistAuthorities
        self.whitelistAuthorities = whitelistAuthorities
		self.blacklistMarkets = blacklistMarkets
		self.whitelistMarkets = whitelistMarkets
		self.extensions = []
    }
    
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.maxSupply)
        try encoder.encode(self.maxMarketFee)
		try encoder.encode(self.marketFeePercent)
        try encoder.encode(self.flags)
		try encoder.encode(self.description)
		try encoder.encode(self.coreExchangeRate)
		try encoder.encode(self.issuerPermissions)
		try encoder.encode(self.blacklistAuthorities)
        try encoder.encode(self.whitelistAuthorities)
		try encoder.encode(self.blacklistMarkets)
		try encoder.encode(self.whitelistMarkets)
		encoder.data.append(0)
    }
    
}