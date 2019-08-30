import Foundation

public struct DataTransactionUpdate: OperationType, Equatable {
	public var requestId: String
	public var newStatus: UInt8
	public var fee: AssetAmount
	public var newRequester: GrapheneId
	public var memo: String
	public var extensions: [String] = []
    
    public init(
	    requestId: String,
		newStatus: UInt8,
		fee: AssetAmount,
		newRequester: GrapheneId,
		memo: String
        ) {
		self.requestId = requestId
		self.newStatus = newStatus
        self.fee = fee
		self.newRequester = newRequester
		self.memo = memo
        self.extensions = []
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.requestId)
		try encoder.encode(self.newStatus)
        try encoder.encode(self.fee)
		try encoder.encode(self.newRequester)
		try encoder.encode(self.memo)
        encoder.data.append(0)
    }
    
}