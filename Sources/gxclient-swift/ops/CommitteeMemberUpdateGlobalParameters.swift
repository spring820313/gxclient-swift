import Foundation

public struct CommitteeMemberUpdateGlobalParameters: OperationType, Equatable {
    public var fee: AssetAmount
	public var newParameters: ChainParameters
    
    public init(
        fee: AssetAmount,
		newParameters: ChainParameters
        ) {
        self.fee = fee
		self.newParameters = newParameters
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.fee)
		try encoder.encode(self.newParameters)
    }
    
}