import Foundation


public struct WorkerCreate: OperationType {
	public var fee: AssetAmount
	public var owner: GrapheneId
	public var workBeginDate: Date
	public var workEndDate: Date
	public var dailyPay: UInt64
	public var name: String
	public var url: String
	public var initializer: WorkerInitializer
    
    public init(
	    fee: AssetAmount,
		owner: GrapheneId,
		workBeginDate: Date,
		workEndDate: Date,
		dailyPay: UInt64,
		name: String,
		url: String,
		initializer: WorkerInitializer
        ) {
		self.fee = fee
		self.owner = owner
        self.workBeginDate = workBeginDate
		self.workEndDate = workEndDate
		self.dailyPay = dailyPay
		self.name = name
		self.url = url
		self.initializer = initializer
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.fee)
		try encoder.encode(self.owner)
        try encoder.encode(self.workBeginDate)
		try encoder.encode(self.workEndDate)
		try encoder.encode(self.dailyPay)
		try encoder.encode(self.name)
		try encoder.encode(self.url)
		try encoder.encode(self.initializer)
    }
    
}
