import Foundation

public struct AssetIssue: OperationType, Equatable {
    public var fee: AssetAmount
    public var issuer: GrapheneId
    public var assetToIssue: AssetAmount
	public var issueToAccount: GrapheneId
	public var memo: Memo?
    public var extensions: [String] = []
    
    public init(
        fee: AssetAmount,
        issuer: GrapheneId,
		assetToIssue: AssetAmount,
        issueToAccount: GrapheneId,
		memo: Memo? = nil
        ) {
        self.fee = fee
        self.issuer = issuer
        self.assetToIssue = assetToIssue
		self.issueToAccount = issueToAccount
		self.memo = memo
        self.extensions = []
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.fee)
        try encoder.encode(self.issuer)
        try encoder.encode(self.assetToIssue)
		try encoder.encode(self.issueToAccount)
		try encoder.encode(self.memo)
        encoder.data.append(0)
    }
    
}