import Foundation


public struct PriceFeed: GxcCodable, Equatable {
    public var maintenanceCollateralRatio: UInt16
    public var maximumShortSqueezeRatio: UInt16
    public var settlementPrice: Price
    public var coreExchangeRate: Price
    
    public init(maintenanceCollateralRatio: UInt16, 
				maximumShortSqueezeRatio: UInt16,
				settlementPrice: Price,
				coreExchangeRate: Price
				) {
        self.maintenanceCollateralRatio = maintenanceCollateralRatio
        self.maximumShortSqueezeRatio = maximumShortSqueezeRatio
		self.settlementPrice = settlementPrice
        self.coreExchangeRate = coreExchangeRate
    }
    
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.maintenanceCollateralRatio)
        try encoder.encode(self.maximumShortSqueezeRatio)
		try encoder.encode(self.settlementPrice)
        try encoder.encode(self.coreExchangeRate)
    }
    
}
