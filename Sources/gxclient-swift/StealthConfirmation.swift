import Foundation

//no

public struct StealthConfirmation: GxcCodable, Equatable {
    public var oneTimeKey: PublicKey
	public var to: PublicKey?
	public var encryptedMemo: String
    
    public init(oneTimeKey: PublicKey, 
				to: PublicKey?,
				encryptedMemo: String
				) {
        self.oneTimeKey = oneTimeKey
        self.to = to
		self.encryptedMemo = encryptedMemo
    }
    
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.oneTimeKey)
        try encoder.encode(self.to)
		try encoder.encode(self.encryptedMemo)
    }
    
}