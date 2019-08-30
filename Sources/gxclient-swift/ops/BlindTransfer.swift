import Foundation

public struct BlindTransfer: OperationType, Equatable {
    public var fee: AssetAmount
	public var inputs: [BlindInput]
    public var outputs: [BlindOutput]
    
    public init(
        fee: AssetAmount,
		inputs: [BlindInput],
        outputs: [BlindOutput]
        ) {
        self.fee = fee
		self.inputs = inputs
        self.outputs = outputs
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.fee)
		try encoder.encode(self.inputs)
        try encoder.encode(self.outputs)
    }
    
}