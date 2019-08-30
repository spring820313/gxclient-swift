import Foundation

public struct BalanceLock: OperationType, Equatable {
    public var fee: AssetAmount
	public var account: GrapheneId
    public var createDateTime: Date
	public var programId: String
    public var amount: AssetAmount
	public var lockDays: UInt32
	public var interestRate: UInt32
	public var memo: Memo
	public var extensions: [String] = []
    
    public init(
        fee: AssetAmount,
		account: GrapheneId,
        createDateTime: Date,
        programId: String,
		amount: AssetAmount,
		lockDays: UInt32,
		interestRate: UInt32,
		memo: Memo
        ) {
        self.fee = fee
		self.account = account
        self.createDateTime = createDateTime
		self.programId = programId
		self.amount = amount
		self.lockDays = lockDays
		self.interestRate = interestRate
		self.memo = memo
        self.extensions = []
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.fee)
		try encoder.encode(self.account)
        try encoder.encode(self.createDateTime)
		try encoder.encode(self.programId)
		try encoder.encode(self.amount)
		try encoder.encode(self.lockDays)
		try encoder.encode(self.interestRate)
		try encoder.encode(self.memo)
        encoder.data.append(0)
    }
    
}