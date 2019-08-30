import Foundation


public struct Price: GxcCodable, Equatable {
    public var base: AssetAmount
    public var quote: AssetAmount
    
    
    public init(base: AssetAmount, quote: AssetAmount) {
        self.base = base
        self.quote = quote
    }
    
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.base)
        try encoder.encode(self.quote)
    }
    
}
