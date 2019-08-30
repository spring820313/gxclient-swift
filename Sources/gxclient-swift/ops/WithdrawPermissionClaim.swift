import Foundation


public struct WithdrawPermissionClaim: OperationType, Equatable {
	public var fee: AssetAmount
	public var withdrawPermission: GrapheneId
	public var withdrawFromAccount: GrapheneId
	public var withdrawToAccount: GrapheneId
	public var amountToWithdraw: AssetAmount
	public var memo: Memo?
    
    public init(
	    fee: AssetAmount,
		withdrawPermission: GrapheneId,
		withdrawFromAccount: GrapheneId,
		withdrawToAccount: GrapheneId,
		amountToWithdraw: AssetAmount,
		memo: Memo? = nil
        ) {
		self.fee = fee
		self.withdrawPermission = withdrawPermission
        self.withdrawFromAccount = withdrawFromAccount
		self.withdrawToAccount = withdrawToAccount
		self.amountToWithdraw = amountToWithdraw
		self.memo = memo
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.fee)
		try encoder.encode(self.withdrawPermission)
        try encoder.encode(self.withdrawFromAccount)
		try encoder.encode(self.withdrawToAccount)
		try encoder.encode(self.amountToWithdraw)
		try encoder.encode(self.memo)
    }
    
}