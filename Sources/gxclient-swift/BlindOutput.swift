import Foundation

//no

public struct BlindOutput: GxcCodable, Equatable {
    public var commitment: String
	public var rangeProof: String
    public var owner: Authority
	public var stealthMemo: StealthConfirmation?
    
    public init(commitment: String, 
				rangeProof: String,
				owner: Authority,
				stealthMemo: StealthConfirmation? = nil
				) {
        self.commitment = commitment
        self.owner = owner
		self.rangeProof = rangeProof
        self.stealthMemo = stealthMemo
    }
    
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.commitment)
        try encoder.encode(self.rangeProof)
		try encoder.encode(self.owner)
        try encoder.encode(self.stealthMemo)
    }
    
}
