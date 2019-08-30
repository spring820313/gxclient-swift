import Foundation

public struct DataTransactionDatasourceUpload: OperationType, Equatable {
    public var requestId: String
	public var requester: GrapheneId
	public var datasource: GrapheneId
	public var fee: AssetAmount
	public var extensions: [String] = []
    
    public init(
		requestId: String,
		requester: GrapheneId,
		datasource: GrapheneId,
        fee: AssetAmount
        ) {
		self.requestId = requestId
		self.requester = requester
        self.datasource = datasource
        self.fee = fee
        self.extensions = []
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.requestId)
		try encoder.encode(self.requester)
        try encoder.encode(self.datasource)
		try encoder.encode(self.fee)
        encoder.data.append(0)
    }
    
}