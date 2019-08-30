import Foundation

//no

public struct BlindInput: GxcCodable, Equatable {
    public var commitment: String
    public var owner: Authority
    
    public init(commitment: String, 
				owner: Authority
				) {
        self.commitment = commitment
        self.owner = owner
    }
    
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.commitment)
        try encoder.encode(self.owner)
    }
    
}
