import Foundation

public struct ProposalDelete: OperationType, Equatable {
	public var fee: AssetAmount
	public var feePayingAccount: GrapheneId
	public var usingOwnerAuthority: Bool
	public var proposal: GrapheneId
	public var extensions: [String] = []
    
    public init(
	    fee: AssetAmount,
		feePayingAccount: GrapheneId,
		usingOwnerAuthority: Bool,
		proposal: GrapheneId
        ) {
		self.fee = fee
		self.feePayingAccount = feePayingAccount
        self.usingOwnerAuthority = usingOwnerAuthority
		self.proposal = proposal
        self.extensions = []
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.fee)
		try encoder.encode(self.feePayingAccount)
        try encoder.encode(self.usingOwnerAuthority)
		try encoder.encode(self.proposal)
        encoder.data.append(0)
    }
    
}