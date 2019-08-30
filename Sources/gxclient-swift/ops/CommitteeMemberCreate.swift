import Foundation

public struct CommitteeMemberCreate: OperationType, Equatable {
    public var fee: AssetAmount
	public var committeeMemberAccount: GrapheneId
    public var url: String
    
    public init(
        fee: AssetAmount,
		committeeMemberAccount: GrapheneId,
        url: String
        ) {
        self.fee = fee
		self.committeeMemberAccount = committeeMemberAccount
        self.url = url
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.fee)
		try encoder.encode(self.committeeMemberAccount)
        try encoder.encode(self.url)
    }
    
}