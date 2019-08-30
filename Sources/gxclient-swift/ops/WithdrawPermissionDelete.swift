import Foundation


public struct WithdrawPermissionDelete: OperationType, Equatable {
	public var fee: AssetAmount
	public var withdrawFromAccount: GrapheneId
	public var authorizedAccount: GrapheneId
	public var withdrawPermission: GrapheneId
    
    public init(
	    fee: AssetAmount,
		withdrawFromAccount: GrapheneId,
		authorizedAccount: GrapheneId,
		withdrawPermission: GrapheneId
        ) {
		self.fee = fee
		self.withdrawFromAccount = withdrawFromAccount
        self.authorizedAccount = authorizedAccount
		self.withdrawPermission = withdrawPermission
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.fee)
		try encoder.encode(self.withdrawFromAccount)
        try encoder.encode(self.authorizedAccount)
		try encoder.encode(self.withdrawPermission)
    }
    
}