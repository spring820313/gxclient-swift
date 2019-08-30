import Foundation

public struct InterContractCall: OperationType, Equatable {
	public var fee: AssetAmount
	public var senderContract: GrapheneId
	public var contractId: GrapheneId
	public var amount: AssetAmount
	public var methodName: String
	public var data: String
	public var extensions: [String] = []
    
    public init(
	    fee: AssetAmount,
		senderContract: GrapheneId,
		contractId: GrapheneId,
		amount: AssetAmount,
		methodName: String,
		data: String
        ) {
		self.fee = fee
		self.senderContract = senderContract
        self.contractId = contractId
		self.amount = amount
		self.methodName = methodName
		self.data = data
        self.extensions = []
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.fee)
		try encoder.encode(self.senderContract)
        try encoder.encode(self.contractId)
		try encoder.encode(self.amount)
		try encoder.encode(self.methodName)
		try encoder.encode(self.data)
        encoder.data.append(0)
    }
    
}