import Foundation

public struct AssetUpdateFeedProducers: OperationType, Equatable {
    public var fee: AssetAmount
	public var issuer: GrapheneId
    public var assetToUpdate: GrapheneId
	public var newFeedProducers: [GrapheneId]
    public var extensions: [String] = []
    
    public init(
        fee: AssetAmount,
		issuer: GrapheneId,
        assetToUpdate: GrapheneId,
        newFeedProducers: [GrapheneId]
        ) {
        self.fee = fee
		self.issuer = issuer
        self.assetToUpdate = assetToUpdate
		self.newFeedProducers = newFeedProducers
        self.extensions = []
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.fee)
		try encoder.encode(self.issuer)
        try encoder.encode(self.assetToUpdate)
		try encoder.encode(self.newFeedProducers)
        encoder.data.append(0)
    }
    
}