import Foundation


public struct VestingBalanceCreate: OperationType {
	public var fee: AssetAmount
	public var creator: GrapheneId
	public var owner: GrapheneId
	public var amount: AssetAmount
	public var policy: VestingPolicy
    
    public init(
	    fee: AssetAmount,
		creator: GrapheneId,
		owner: GrapheneId,
		amount: AssetAmount,
		policy: VestingPolicy
        ) {
		self.fee = fee
		self.creator = creator
        self.owner = owner
		self.amount = amount
		self.policy = policy
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.fee)
		try encoder.encode(self.creator)
        try encoder.encode(self.owner)
		try encoder.encode(self.amount)
		try encoder.encode(self.policy)
    }
    
}
