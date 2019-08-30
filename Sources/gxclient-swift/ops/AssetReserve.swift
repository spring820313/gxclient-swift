import Foundation

public struct AssetReserve: OperationType, Equatable {
    public var fee: AssetAmount
    public var payer: GrapheneId
	public var amountToReserve: AssetAmount
    public var extensions: [String] = []
    
    public init(
        fee: AssetAmount,
        payer: GrapheneId,
        amountToReserve: AssetAmount
        ) {
        self.fee = fee
        self.payer = payer
        self.amountToReserve = amountToReserve
        self.extensions = []
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.fee)
        try encoder.encode(self.payer)
        try encoder.encode(self.amountToReserve)
        encoder.data.append(0)
    }
    
}