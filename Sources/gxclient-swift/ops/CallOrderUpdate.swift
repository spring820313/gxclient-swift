import Foundation

public struct CallOrderUpdate: OperationType, Equatable {
    public var fee: AssetAmount
	public var fundingAccount: GrapheneId
    public var deltaCollateral: AssetAmount
	public var deltaDebt: AssetAmount
	public var extensions: [String] = []
    
    public init(
        fee: AssetAmount,
		fundingAccount: GrapheneId,
        deltaCollateral: AssetAmount,
		deltaDebt: AssetAmount
        ) {
        self.fee = fee
		self.fundingAccount = fundingAccount
        self.deltaCollateral = deltaCollateral
		self.deltaDebt = deltaDebt
        self.extensions = []
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.fee)
		try encoder.encode(self.fundingAccount)
        try encoder.encode(self.deltaCollateral)
		try encoder.encode(self.deltaDebt)
        encoder.data.append(0)
    }
    
}