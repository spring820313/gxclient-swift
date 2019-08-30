import Foundation

public struct ProposalUpdate: OperationType, Equatable {
	public var fee: AssetAmount
	public var feePayingAccount: GrapheneId
	public var proposal: GrapheneId
	
	public var activeApprovalsToAdd: [GrapheneId]
	public var activeApprovalsToRemove: [GrapheneId]
	public var ownerApprovalsToAdd: [GrapheneId]
	public var ownerApprovalsToRemove: [GrapheneId]
	public var keyApprovalsToAdd: [GrapheneId]
	public var keyApprovalsToRemove: [GrapheneId]
	
	public var extensions: [String] = []
    
    public init(
	    fee: AssetAmount,
		feePayingAccount: GrapheneId,
		proposal: GrapheneId,
		activeApprovalsToAdd: [GrapheneId],
		activeApprovalsToRemove: [GrapheneId],
		ownerApprovalsToAdd: [GrapheneId],
		ownerApprovalsToRemove: [GrapheneId],
		keyApprovalsToAdd: [GrapheneId],
		keyApprovalsToRemove: [GrapheneId]
        ) {
		self.fee = fee
		self.feePayingAccount = feePayingAccount
		self.proposal = proposal
		self.activeApprovalsToAdd = activeApprovalsToAdd
		self.activeApprovalsToRemove = activeApprovalsToRemove
		self.ownerApprovalsToAdd = ownerApprovalsToAdd
		self.ownerApprovalsToRemove = ownerApprovalsToRemove
		self.keyApprovalsToAdd = keyApprovalsToAdd
		self.keyApprovalsToRemove = keyApprovalsToRemove
        self.extensions = []
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.fee)
		try encoder.encode(self.feePayingAccount)
		try encoder.encode(self.proposal)
		try encoder.encode(self.activeApprovalsToAdd)
		try encoder.encode(self.activeApprovalsToRemove)
		try encoder.encode(self.ownerApprovalsToAdd)
		try encoder.encode(self.ownerApprovalsToRemove)
		try encoder.encode(self.keyApprovalsToAdd)
		try encoder.encode(self.keyApprovalsToRemove)
        encoder.data.append(0)
    }
    
}