import Foundation

public struct AssetClaimFees: OperationType, Equatable {
    public var fee: AssetAmount
    public var issuer: GrapheneId
    public var amountToClaim: AssetAmount
    public var extensions: [String] = []
    
    public init(
        fee: AssetAmount,
        issuer: GrapheneId,
        amountToClaim: AssetAmount
        ) {
        self.fee = fee
        self.issuer = issuer
        self.amountToClaim = amountToClaim
        self.extensions = []
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.fee)
        try encoder.encode(self.issuer)
        try encoder.encode(self.amountToClaim)
        encoder.data.append(0)
    }
    
}