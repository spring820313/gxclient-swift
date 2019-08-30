import Foundation


public struct WithdrawPermissionCreate: OperationType, Equatable {
	public var fee: AssetAmount
	public var withdrawFromAccount: GrapheneId
	public var authorizedAccount: GrapheneId
	public var withdrawalLimit: AssetAmount
	public var withdrawalPeriodSec: UInt32
	public var periodsUntilExpiration: UInt32
	public var periodStartTime: Date
    
    public init(
	    fee: AssetAmount,
		withdrawFromAccount: GrapheneId,
		authorizedAccount: GrapheneId,
		withdrawalLimit: AssetAmount,
		withdrawalPeriodSec: UInt32,
		periodsUntilExpiration: UInt32,
		periodStartTime: Date
        ) {
		self.fee = fee
		self.withdrawFromAccount = withdrawFromAccount
        self.authorizedAccount = authorizedAccount
		self.withdrawalLimit = withdrawalLimit
		self.withdrawalPeriodSec = withdrawalPeriodSec
		self.periodsUntilExpiration = periodsUntilExpiration
		self.periodStartTime = periodStartTime
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.fee)
		try encoder.encode(self.withdrawFromAccount)
        try encoder.encode(self.authorizedAccount)
		try encoder.encode(self.withdrawalLimit)
		try encoder.encode(self.withdrawalPeriodSec)
		try encoder.encode(self.periodsUntilExpiration)
		try encoder.encode(self.periodStartTime)
    }
    
}