import Foundation

public struct ProposalCreate: OperationType {
	public var fee: AssetAmount
	public var feePayingAccount: GrapheneId
	public var expirationTime: Date
	public var proposedOps: [OperationEnvelopeHolder]
	public var reviewPeriodSeconds: UInt32?
	public var extensions: [String] = []
    
    public init(
	    fee: AssetAmount,
		feePayingAccount: GrapheneId,
		expirationTime: Date,
		proposedOps: [OperationEnvelopeHolder],
		reviewPeriodSeconds: UInt32? = nil
        ) {
		self.fee = fee
		self.feePayingAccount = feePayingAccount
        self.expirationTime = expirationTime
		self.proposedOps = proposedOps
		self.reviewPeriodSeconds = reviewPeriodSeconds
        self.extensions = []
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.fee)
		try encoder.encode(self.feePayingAccount)
        try encoder.encode(self.expirationTime)
		try encoder.encode(self.proposedOps)
		try encoder.encode(self.reviewPeriodSeconds)
        encoder.data.append(0)
    }
    
}
