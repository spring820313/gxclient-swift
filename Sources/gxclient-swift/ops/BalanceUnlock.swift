import Foundation

public struct BalanceUnlock: OperationType, Equatable {
    public var fee: AssetAmount
	public var account: GrapheneId
    public var lockId: GrapheneId
	public var extensions: [String] = []
    
    public init(
        fee: AssetAmount,
		account: GrapheneId,
        lockId: GrapheneId
        ) {
        self.fee = fee
		self.account = account
        self.lockId = lockId
        self.extensions = []
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.fee)
		try encoder.encode(self.account)
        try encoder.encode(self.lockId)
        encoder.data.append(0)
    }
    
}