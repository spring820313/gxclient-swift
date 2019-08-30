import Foundation


public struct AccountOptions: GxcCodable, Equatable {
    public var memoKey: PublicKey
	public var votingAccount: GrapheneId
	public var numWitness: UInt16
	public var numCommittee: UInt16
    public var votes: [VoteId]
	public var extensions: [String] = []
    
    public init(memoKey: PublicKey, 
				votingAccount: GrapheneId,
				numWitness: UInt16,
				numCommittee: UInt16,
				votes: [VoteId]
				) {
        self.memoKey = memoKey
        self.votingAccount = votingAccount
		self.numWitness = numWitness
        self.numCommittee = numCommittee
		self.votes = votes
		self.extensions = []
    }
    
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.memoKey)
        try encoder.encode(self.votingAccount)
		try encoder.encode(self.numWitness)
        try encoder.encode(self.numCommittee)
		try encoder.encode(self.votes)
		encoder.data.append(0)
    }
    
}