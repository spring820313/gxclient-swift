import Foundation


public struct TrustNodePledgeWithdraw: OperationType, Equatable {
	public var fee: AssetAmount
	public var witnessAccount: GrapheneId
    
    public init(
	    fee: AssetAmount,
		witnessAccount: GrapheneId
        ) {
		self.fee = fee
		self.witnessAccount = witnessAccount
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.fee)
		try encoder.encode(self.witnessAccount)
    }
    
}
