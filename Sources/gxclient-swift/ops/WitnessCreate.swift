import Foundation


public struct WitnessCreate: OperationType, Equatable {
	public var fee: AssetAmount
	public var witnessAccount: GrapheneId
	public var url: String
	public var blockSigningKey: PublicKey
    
    public init(
	    fee: AssetAmount,
		witnessAccount: GrapheneId,
		url: String,
		blockSigningKey: PublicKey
        ) {
		self.fee = fee
		self.witnessAccount = witnessAccount
        self.url = url
		self.blockSigningKey = blockSigningKey
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.fee)
		try encoder.encode(self.witnessAccount)
        try encoder.encode(self.url)
		try encoder.encode(self.blockSigningKey)
    }
    
}