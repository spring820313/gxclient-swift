import Foundation

public struct DataTransactionCreate: OperationType, Equatable {
    public var requestId: String
	public var productId: GrapheneId
    public var version: String
	public var params: String
	public var fee: AssetAmount
	public var requester: GrapheneId
    public var createDateTime: Date
	public var leagueId: GrapheneId?
	public var extensions: [String] = []
    
    public init(
		requestId: String,
		productId: GrapheneId,
		version: String,
		params: String,
        fee: AssetAmount,
		requester: GrapheneId,
        createDateTime: Date,
		leagueId: GrapheneId? = nil
        ) {
		self.requestId = requestId
		self.productId = productId
        self.version = version
		self.params = params
        self.fee = fee
		self.requester = requester
        self.createDateTime = createDateTime
		self.leagueId = leagueId
        self.extensions = []
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.requestId)
		try encoder.encode(self.productId)
        try encoder.encode(self.version)
		try encoder.encode(self.params)
		try encoder.encode(self.fee)
		try encoder.encode(self.requester)
        try encoder.encode(self.createDateTime)
		try encoder.encode(self.leagueId)
        encoder.data.append(0)
    }
    
}