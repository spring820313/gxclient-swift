import Foundation

public struct AssetCreate: OperationType, Equatable {
    public var fee: AssetAmount
    public var issuer: GrapheneId
    public var symbol: String
	public var precision: UInt8
	public var commonOptions: AssetOptions
	public var bitassetOptions: BitassetOptions?
	public var isPredictionMarket: Bool
    public var extensions: [String] = []
    
    public init(
        fee: AssetAmount,
        issuer: GrapheneId,
        symbol: String,
		precision: UInt8,
		commonOptions: AssetOptions,
		bitassetOptions: BitassetOptions?,
		isPredictionMarket: Bool
        ) {
        self.fee = fee
        self.issuer = issuer
        self.symbol = symbol
		self.precision = precision
		self.commonOptions = commonOptions
		self.bitassetOptions = bitassetOptions
		self.isPredictionMarket = isPredictionMarket
        self.extensions = []
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.fee)
        try encoder.encode(self.issuer)
        try encoder.encode(self.symbol)
		try encoder.encode(self.precision)
		try encoder.encode(self.commonOptions)
		try encoder.encode(self.bitassetOptions)
		try encoder.encode(self.isPredictionMarket)
        encoder.data.append(0)
    }
    
}