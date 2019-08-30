import Foundation


public struct VestingBalanceWithdraw: OperationType, Equatable {
	public var fee: AssetAmount
	public var vestingBalance: GrapheneId
	public var owner: GrapheneId
	public var amount: AssetAmount
    
    public init(
	    fee: AssetAmount,
		vestingBalance: GrapheneId,
		owner: GrapheneId,
		amount: AssetAmount
        ) {
		self.fee = fee
		self.vestingBalance = vestingBalance
        self.owner = owner
		self.amount = amount
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.fee)
		try encoder.encode(self.vestingBalance)
        try encoder.encode(self.owner)
		try encoder.encode(self.amount)
    }
    
}