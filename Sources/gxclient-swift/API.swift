/// Steem RPC requests and responses.
/// - Author: Johan Nordberg <johan@steemit.com>

import Foundation
import AnyCodable

/// Steem RPC API request- and response-types.
public struct API {
    /// Wrapper for pre-appbase steemd calls.
    public struct CallParams<T: Encodable>: Encodable {
        let api: Int
        let method: String
        let params: [T]
        init(_ api: Int, _ method: String, _ params: [T]) {
            self.api = api
            self.method = method
            self.params = params
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.unkeyedContainer()
            try container.encode(api)
            try container.encode(method)
            try container.encode(params)
        }
    }
    
    public struct GetChainID: Request {
        public typealias Response = String
        public let method = "get_chain_id"
        public init() {}
    }

    public struct DynamicGlobalProperties: Decodable {
        public let headBlockNumber: UInt32
        public let headBlockId: BlockId
        public let time: Date
        public let currentWitness: GrapheneId
        public let nextMaintenanceTime: Date
        public let lastBudgetTime: Date
        public let accountsRegisteredThisInterval: Int32
        public let dynamicFlags: Int32
        public let recentSlotsFilled: String
        public let lastIrreversibleBlockNum: UInt32
        public let currentAslot: Int64
        public let witnessBudget: Int64
        public let recentlyMissedCount: Int64
    }

    public struct GetDynamicGlobalProperties: Request {
        public typealias Response = DynamicGlobalProperties
        public let method = "get_dynamic_global_properties"
        public init() {}
    }
    
    public struct LookupAssetSymbols: Request {
        public typealias Response = [Asset]
        public let method = "lookup_asset_symbols"
        public let params: RequestParams<[String]>?
        public init(names: [String]) {
            self.params = RequestParams([names])
        }
    }
    
    public struct RequiredFeeParams:Encodable {
        public let ops:[AnyOperation]
        public let assetID: String
        
        init(_ ops: [AnyOperation], _ assetID: String) {
            self.ops = ops
            self.assetID = assetID
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.unkeyedContainer()
            try container.encode(ops)
            try container.encode(assetID)
        }
        
    }
    
    public struct GetRequiredFee: Request {
        public typealias Response = [AssetAmount]
        public let method = "get_required_fees"
        public let params: RequestParams<RequiredFeeParams>?
        public init(ops: [AnyOperation], assetID: String) {
            let p = RequiredFeeParams(ops, assetID)
            self.params = RequestParams(p)
        }
    }
    
    public struct TransactionConfirmation: Decodable {
        public let id: Data
        public let blockNum: Int32
        public let trxNum: Int32
        public let expired: Bool
    }

    public struct BroadcastTransaction: Request {
        public typealias Response = String
        public let method = "call"
        public let params: CallParams<SignedTransaction>?
        public init(transaction: SignedTransaction) {
            self.params = CallParams(2, "broadcast_transaction", [transaction])
        }
    }

    public struct GetBlock: Request {
        public typealias Response = SignedBlock
        public let method = "get_block"
        public let params: RequestParams<Int>?
        public init(blockNum: Int) {
            self.params = RequestParams([blockNum])
        }
    }
    
    public struct GetAccountByName: Request {
        public typealias Response = Account?
        public let method = "get_account_by_name"
        public let params: RequestParams<String>?
        public init(name: String) {
            self.params = RequestParams([name])
        }
    }
    
    public struct GetContractAccountByName: Request {
        public typealias Response = ContractAccountProperties
        public let method = "get_account_by_name"
        public let params: RequestParams<String>?
        public init(name: String) {
            self.params = RequestParams([name])
        }
    }
    
    public struct AccountOptions: GxcCodable,Equatable {
        public var memoKey:PublicKey
        public var votingAccount:GrapheneId
        public var numWitness:UInt16
        public var numCommittee:UInt16
        public var votes:[VoteId]
        public let extensions:[String] = []
        
        /*
        public func binaryEncode(to encoder: GxcEncoder) throws {
            try encoder.encode(self.memoKey)
            try encoder.encode(self.votingAccount)
            try encoder.encode(self.numWitness)
            try encoder.encode(self.numCommittee)
            try encoder.encode(self.votes)
            encoder.data.append(0)
        }
        */
    }


    /// The "extended" account object returned by get_accounts.
    public struct Account: Decodable {
        public let id:GrapheneId
        public let name:String
        public let statistics:GrapheneId
        public let membershipExpirationDate:Date
        public let networkFeePercentage:UInt64
        public let lifetimeReferrerFeePercentage:UInt64
        public let referrerRewardsPercentage:UInt64
        public let topNControlFlags:UInt64
        public let whitelistingAccounts:[GrapheneId]
        public let blacklistingAccounts:[GrapheneId]
        public let whitelistedAccounts:[GrapheneId]
        public let blacklistedAccounts:[GrapheneId]
        public var options:AccountOptions
        public let registrar:GrapheneId
        public let referrer:GrapheneId
        public let lifetimeReferrer:GrapheneId
        public let owner:Authority
        public let active:Authority
        public let ownerSpecialAuthority:OwnerSpecialAuthority
        public let activeSpecialAuthority:ActiveSpecialAuthority
    }

    /// Fetch accounts.
    public struct GetAccounts: Request {
        public typealias Response = [Account]
        public let method = "get_accounts"
        public let params: RequestParams<[String]>?
        public init(ids: [String]) {
            self.params = RequestParams([ids])
        }
    }
    
    public struct GetObjects: Request {
        public typealias Response = [ObjectParameters]
        public let method = "get_objects"
        public let params: RequestParams<[String]>?
        public init(ids: [String]) {
            self.params = RequestParams([ids])
        }
    }
    
    public struct GetWitnessByAccount: Request {
        public typealias Response = Witness?
        public let method = "get_witness_by_account"
        public let params: RequestParams<String>?
        public init(id: String) {
            self.params = RequestParams([id])
        }
    }
    
    public struct GetCommitteeMemberByAccount: Request {
        public typealias Response = Committee?
        public let method = "get_committee_member_by_account"
        public let params: RequestParams<String>?
        public init(id: String) {
            self.params = RequestParams([id])
        }
    }
    
    public struct TableRows:Encodable {
        public let contractName:String
        public let tableName: String
        public let lowerBound: Int32
        public let upperBound: Int32
        
        init(_ contractName: String, _ tableName: String, _ lowerBound: Int32, _ upperBound: Int32) {
            self.contractName = contractName
            self.tableName = tableName
            self.lowerBound = lowerBound
            self.upperBound = upperBound
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.unkeyedContainer()
            try container.encode(self.contractName)
            try container.encode(self.tableName)
            try container.encode(self.lowerBound)
            try container.encode(self.upperBound)
        }
        
    }
    
    public struct TableRowsParams:Encodable {
        public let lowerBound: Int32
        public let upperBound: Int32
        public let indexPosition: Int32
        public let limit: Int32
        public let reverse: Bool
        
        fileprivate enum Key: CodingKey {
            case lowerBound
            case upperBound
            case indexPosition
            case limit
            case reverse
        }
        
        init(_ lowerBound: Int32, _ upperBound: Int32, _ indexPosition: Int32, _ limit: Int32, _ reverse: Bool) {
            self.lowerBound = lowerBound
            self.upperBound = upperBound
            self.indexPosition = indexPosition
            self.limit = limit
            self.reverse = reverse
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: Key.self)
            try container.encode(self.lowerBound, forKey: .lowerBound)
            try container.encode(self.upperBound, forKey: .upperBound)
            try container.encode(self.indexPosition, forKey: .indexPosition)
            try container.encode(self.limit, forKey: .limit)
            try container.encode(self.reverse, forKey: .reverse)
        }
        
    }
    
    public struct TableRowsEx:Encodable {
        public let contractName:String
        public let tableName: String
        public let params: TableRowsParams
        
        init(_ contractName: String, _ tableName: String, _ params: TableRowsParams) {
            self.params = params
            self.contractName = contractName
            self.tableName = tableName
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.unkeyedContainer()
            try container.encode(self.contractName)
            try container.encode(self.tableName)
            try container.encode(self.params)
        }
        
    }
    
    public struct GetTableRows: Request {
        public typealias Response = AnyDecodable
        public let method = "get_table_rows"
        public let params: RequestParams<TableRows>?
        public init(contractName: String, tableName: String, lowerBound: Int32, upperBound: Int32) {
            let p = TableRows(contractName, tableName, lowerBound, upperBound)
            self.params = RequestParams(p)
        }
    }
    
    public struct GetTableRowsEx: Request {
        public typealias Response = AnyDecodable
        public let method = "get_table_rows_ex"
        public let params: RequestParams<TableRowsEx>?
        public init(contractName: String, tableName: String, params: TableRowsParams) {
            let p = TableRowsEx(contractName, tableName, params)
            self.params = RequestParams(p)
        }
    }
    
    public struct AccountBalances:Encodable {
        public let account: String
        public let assetIDs: [String]
        
        init(_ account: String, _ assetIDs: [String]) {
            self.account = account
            self.assetIDs = assetIDs
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.unkeyedContainer()
            try container.encode(self.account)
            try container.encode(self.assetIDs)
        }
        
    }
    
    public struct GetAccountBalances: Request {
        public typealias Response = [AssetAmount]
        public let method = "get_account_balances"
        public let params: RequestParams<AccountBalances>?
        public init(accountId: String, assetIDs: [String]) {
            let p = AccountBalances(accountId, assetIDs)
            self.params = RequestParams(p)
        }
    }
    
    public struct GetNamedAccountBalances: Request {
        public typealias Response = [AssetAmount]
        public let method = "get_named_account_balances"
        public let params: RequestParams<AccountBalances>?
        public init(name: String, assetIDs: [String]) {
            let p = AccountBalances(name, assetIDs)
            self.params = RequestParams(p)
        }
    }
    
    public struct GetAccountsByPublicKeys: Request {
        public typealias Response = [[String]]
        public let method = "get_key_references"
        public let params: RequestParams<[String]>?
        public init(publicKeys: [String]) {
            self.params = RequestParams([publicKeys])
        }
    }
    
    public struct ContractCallArgs:Encodable {
        public let contractName:String
        public let method: String
        public let parameters: String?
        
        init(_ contractName: String, _ method: String, _ parameters: String?) {
            self.contractName = contractName
            self.method = method
            self.parameters = parameters
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.unkeyedContainer()
            try container.encode(self.contractName)
            try container.encode(self.method)

            var json = "{}"
            if let parameters = self.parameters {
                json = parameters
            }
            try container.encode(json)

        }
        
    }
    
    public struct SerializeContractCallArgs: Request {
        public typealias Response = String
        public let method = "serialize_contract_call_args"
        public let params: RequestParams<ContractCallArgs>?
        public init(contractName: String, method: String, parameters: String?) {
            let p = ContractCallArgs(contractName, method, parameters)
            self.params = RequestParams(p)
        }
    }
    
    public struct RegisterAccountInfo:Encodable {
        public let name:String
        public let activeKey: String
        public let ownerKey: String
        public let memoKey: String
        
        public init(name: String, activeKey: String, ownerKey: String? = nil, memoKey: String? = nil) {
            self.name = name
            self.activeKey = activeKey
            self.ownerKey = ownerKey ?? activeKey
            self.memoKey = memoKey ?? activeKey
        }
    }
    
    public struct RegisterAccount:Encodable {
        public let account:RegisterAccountInfo
        
        public init(account: RegisterAccountInfo) {
            self.account = account
        }
    }
    
}
