import Foundation

public struct BalanceClaim: OperationType, Equatable {
    public var fee: AssetAmount
	public var depositToAccount: GrapheneId
    public var balanceToClaim: GrapheneId
	public var balanceOwnerKey: PublicKey
    public var totalClaimed: AssetAmount
	public var extensions: [String] = []
    
    public init(
        fee: AssetAmount,
		depositToAccount: GrapheneId,
        balanceToClaim: GrapheneId,
        balanceOwnerKey: PublicKey,
		totalClaimed: AssetAmount
        ) {
        self.fee = fee
		self.depositToAccount = depositToAccount
        self.balanceToClaim = balanceToClaim
		self.balanceOwnerKey = balanceOwnerKey
		self.totalClaimed = totalClaimed
        self.extensions = []
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.fee)
		try encoder.encode(self.depositToAccount)
        try encoder.encode(self.balanceToClaim)
		try encoder.encode(self.balanceOwnerKey)
		try encoder.encode(self.totalClaimed)
        encoder.data.append(0)
    }
    
}