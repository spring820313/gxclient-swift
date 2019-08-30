import Foundation


public struct WithdrawPermissionUpdate: OperationType, Equatable {
	public var fee: AssetAmount
	public var withdrawFromAccount: GrapheneId
	public var authorizedAccount: GrapheneId
	public var permissionToUpdate: GrapheneId
	public var withdrawalLimit: AssetAmount
	public var withdrawalPeriodSec: UInt32
	public var periodStartTime: Date
	public var periodsUntilExpiration: UInt32
    
    public init(
	    fee: AssetAmount,
		withdrawFromAccount: GrapheneId,
		authorizedAccount: GrapheneId,
		permissionToUpdate: GrapheneId,
		withdrawalLimit: AssetAmount,
		withdrawalPeriodSec: UInt32,
		periodStartTime: Date,
		periodsUntilExpiration: UInt32
        ) {
		self.fee = fee
		self.withdrawFromAccount = withdrawFromAccount
        self.authorizedAccount = authorizedAccount
		self.permissionToUpdate = permissionToUpdate
		self.withdrawalLimit = withdrawalLimit
		self.withdrawalPeriodSec = withdrawalPeriodSec
		self.periodStartTime = periodStartTime
		self.periodsUntilExpiration = periodsUntilExpiration
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.fee)
		try encoder.encode(self.withdrawFromAccount)
        try encoder.encode(self.authorizedAccount)
		try encoder.encode(self.permissionToUpdate)
		try encoder.encode(self.withdrawalLimit)
		try encoder.encode(self.withdrawalPeriodSec)
		try encoder.encode(self.periodStartTime)
		try encoder.encode(self.periodsUntilExpiration)
    }
    
}