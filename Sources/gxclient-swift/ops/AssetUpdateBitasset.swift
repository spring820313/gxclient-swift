import Foundation

public struct AssetUpdateBitasset: OperationType, Equatable {
    public var fee: AssetAmount
	public var issuer: GrapheneId
    public var assetToUpdate: GrapheneId
	public var newOptions: BitassetOptions
    public var extensions: [String] = []
    
    public init(
        fee: AssetAmount,
		issuer: GrapheneId,
        assetToUpdate: GrapheneId,
        newOptions: BitassetOptions
        ) {
        self.fee = fee
		self.issuer = issuer
        self.assetToUpdate = assetToUpdate
		self.newOptions = newOptions
        self.extensions = []
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.fee)
		try encoder.encode(self.issuer)
        try encoder.encode(self.assetToUpdate)
		try encoder.encode(self.newOptions)
        encoder.data.append(0)
    }
    
}