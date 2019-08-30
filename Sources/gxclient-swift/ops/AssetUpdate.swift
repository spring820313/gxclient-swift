import Foundation

public struct AssetUpdate: OperationType, Equatable {
    public var fee: AssetAmount
	public var issuer: GrapheneId
    public var assetToUpdate: GrapheneId
	public var newIssuer: GrapheneId?
	public var newOptions: AssetOptions
    public var extensions: [String] = []
    
    public init(
        fee: AssetAmount,
		issuer: GrapheneId,
        assetToUpdate: GrapheneId,
		newIssuer: GrapheneId?,
        newOptions: AssetOptions
        ) {
        self.fee = fee
		self.issuer = issuer
        self.assetToUpdate = assetToUpdate
        self.newIssuer = newIssuer
		self.newOptions = newOptions
        self.extensions = []
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.fee)
		try encoder.encode(self.issuer)
        try encoder.encode(self.assetToUpdate)
        try encoder.encode(self.newIssuer)
		try encoder.encode(self.newOptions)
        encoder.data.append(0)
    }
    
}