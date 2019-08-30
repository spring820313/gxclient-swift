import Foundation


public struct WitnessUpdate: OperationType, Equatable {
	public var fee: AssetAmount
	public var witness: GrapheneId
	public var witnessAccount: GrapheneId
	public var newURL: String?
	public var newSigningKey: PublicKey?
    
    public init(
	    fee: AssetAmount,
		witness: GrapheneId,
		witnessAccount: GrapheneId,
		newURL: String?,
		newSigningKey: PublicKey?
        ) {
		self.fee = fee
		self.witness = witness
        self.witnessAccount = witnessAccount
		self.newURL = newURL
		self.newSigningKey = newSigningKey
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.fee)
		try encoder.encode(self.witness)
        try encoder.encode(self.witnessAccount)
		try encoder.encode(self.newURL)
		try encoder.encode(self.newSigningKey)
    }
    
}