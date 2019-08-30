import Foundation

public struct CommitteeMemberUpdate: OperationType, Equatable {
    public var fee: AssetAmount
	public var committeeMember: GrapheneId
	public var committeeMemberAccount: GrapheneId
    public var newURL: String?
    
    public init(
        fee: AssetAmount,
		committeeMember: GrapheneId,
		committeeMemberAccount: GrapheneId,
        newURL: String?
        ) {
        self.fee = fee
		self.committeeMember = committeeMember
		self.committeeMemberAccount = committeeMemberAccount
        self.newURL = newURL
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.fee)
		try encoder.encode(self.committeeMember)
		try encoder.encode(self.committeeMemberAccount)
        try encoder.encode(self.newURL)
    }
    
}