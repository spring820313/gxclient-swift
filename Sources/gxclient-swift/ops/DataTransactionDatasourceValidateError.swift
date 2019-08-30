import Foundation

public struct DataTransactionDatasourceValidateError: OperationType, Equatable {
    public var requestId: String
	public var datasource: GrapheneId
	public var fee: AssetAmount
	public var extensions: [String] = []
    
    public init(
		requestId: String,
		datasource: GrapheneId,
        fee: AssetAmount
        ) {
		self.requestId = requestId
        self.datasource = datasource
        self.fee = fee
        self.extensions = []
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.requestId)
        try encoder.encode(self.datasource)
		try encoder.encode(self.fee)
        encoder.data.append(0)
    }
    
}