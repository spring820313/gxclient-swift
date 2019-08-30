import Foundation

public struct FbaDistribute: OperationType, Equatable {
	public var fee: AssetAmount
	public var extensions: [String] = []
    
    public init(
		fee: AssetAmount
        ) {
        self.fee = fee
        self.extensions = []
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.fee)
        encoder.data.append(0)
    }
    
}