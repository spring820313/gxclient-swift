/// Steem-flavoured JSON-RPC 2.0 client.
/// - Author: Johan Nordberg <johan@steemit.com>

import AnyCodable
import Foundation
import AwaitKit
import PromiseKit
import Alamofire

/// JSON-RPC 2.0 request type.
///
/// Implementers should provide `Decodable` response types, example:
///
///     struct MyResponse: Decodable {
///         let hello: String
///         let foo: Int
///     }
///     struct MyRequest: Steem.Request {
///         typealias Response = MyResponse
///         let method = "my_method"
///         let params: RequestParams<String>
///         init(name: String) {
///             self.params = RequestParams(["hello": name])
///         }
///     }
///
public protocol Request {
    /// Response type.
    associatedtype Response: Decodable
    /// Request parameter type.
    associatedtype Params: Encodable
    /// JSON-RPC 2.0 method to call.
    var method: String { get }
    /// JSON-RPC 2.0 parameters
    var params: Params? { get }
}

// Default implementation sends a request without params.
extension Request {
    public var params: RequestParams<AnyEncodable>? {
        return nil
    }
}

/// Request parameter helper type. Can wrap any `Encodable` as set of params, either keyed by name or indexed.
public struct RequestParams<T: Encodable> {
    private var named: [String: T]?
    private var indexed: [T]?
    private var mixed: T?

    /// Create a new set of named params.
    public init(_ params: [String: T]) {
        self.named = params
    }

    /// Create a new set of ordered params.
    public init(_ params: [T]) {
        self.indexed = params
    }
    
    public init(_ params: T) {
        self.mixed = params
    }
    
}

extension RequestParams: Encodable {
    private struct Key: CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }

        var intValue: Int?
        init?(intValue: Int) {
            self.intValue = intValue
            self.stringValue = "\(intValue)"
        }
    }

    public func encode(to encoder: Encoder) throws {
        if let params = indexed {
            var container = encoder.unkeyedContainer()
            try container.encode(contentsOf: params)
        } else if let params = self.named {
            var container = encoder.container(keyedBy: Key.self)
            for (key, value) in params {
                try container.encode(value, forKey: Key(stringValue: key)!)
            }
        } else if let params = self.mixed {
            //var container = encoder.unkeyedContainer()
            //try container.encode(params)
            try params.encode(to: encoder)
        }
    }
}

/// JSON-RPC 2.0 request payload wrapper.
internal struct RequestPayload<RequestV: Request> {
    let request: RequestV
    let id: Int
}

extension RequestPayload: Encodable {
    fileprivate enum Keys: CodingKey {
        case id
        case jsonrpc
        case method
        case params
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode("2.0", forKey: .jsonrpc)
        try container.encode(self.request.method, forKey: .method)
        try container.encodeIfPresent(self.request.params, forKey: .params)
    }
}

/// JSON-RPC 2.0 response error type.
internal struct ResponseError: Decodable {
    let code: Int
    let message: String
    let data: [String: AnyDecodable]?
    var resolvedData: [String: Any]? {
        return self.data?.mapValues { $0.value as Any }
    }
}

/// JSON-RPC 2.0 response payload wrapper.
internal struct ResponsePayload<T: Request>: Decodable {
    let id: Int?
    let result: T.Response?
    let error: ResponseError?
}

/// URLSession adapter, for testability.
internal protocol SessionAdapter {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> SessionDataTask
}

internal protocol SessionDataTask {
    func resume()
}

extension URLSessionDataTask: SessionDataTask {}
extension URLSession: SessionAdapter {
    internal func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> SessionDataTask {
        let task: URLSessionDataTask = self.dataTask(with: request, completionHandler: completionHandler)
        return task as SessionDataTask
    }
}

/// JSON-RPC 2.0 ID number generator
internal protocol IdGenerator {
    mutating func next() -> Int
}

/// JSON-RPC 2.0 Sequential ID number generator
internal struct SeqIdGenerator: IdGenerator {
    private var seq: Int = 1
    public init() {}
    public mutating func next() -> Int {
        defer {
            seq += 1
        }
        return self.seq
    }
}

/// Steem-flavoured JSON-RPC 2.0 client.
public class Client {
    /// All errors `Client` can throw.
    public enum Error: LocalizedError {
        /// Unable to send request or invalid response from server.
        case networkError(message: String, error: Swift.Error?)
        /// Server responded with a JSON-RPC 2.0 error.
        case responseError(code: Int, message: String, data: [String: Any]?)
        /// Unable to decode the result or encode the request params.
        case codingError(message: String, error: Swift.Error?)

        public var errorDescription: String? {
            switch self {
            case let .networkError(message, error):
                var rv = "Unable to send request: \(message)"
                if let error = error {
                    rv += " (caused by \(String(describing: error))"
                }
                return rv
            case let .codingError(message, error):
                return "Unable to serialize data: \(message) (caused by \(String(describing: error))"
            case let .responseError(code, message, _):
                return "RPCError: \(message) (code=\(code))"
            }
        }
    }
    
    static let sharedSessionManager: Alamofire.SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        return Alamofire.SessionManager(configuration: configuration)
    }()

    /// The RPC Server address.
    public let address: URL

    internal var idgen: IdGenerator = SeqIdGenerator()
    internal var session: SessionAdapter

    /// Create a new client instance.
    /// - Parameter address: The rpc server to connect to.
    /// - Parameter session: The session to use when sending requests to the server.
    public init(address: URL, session: URLSession = URLSession.shared) {
        self.address = address
        self.session = session as SessionAdapter
    }

    /// Return a URLRequest for a JSON-RPC 2.0 request payload.
    internal func urlRequest<T: Request>(for payload: RequestPayload<T>) throws -> URLRequest {
        let encoder = Client.JSONEncoder()
        var urlRequest = URLRequest(url: self.address)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = try encoder.encode(payload)
        print(String(data: urlRequest.httpBody!, encoding: .utf8)!)
        return urlRequest
    }

    /// Resolve a URLSession dataTask to a `Response`.
    internal func resolveResponse<T: Request>(for payload: RequestPayload<T>, data: Data?, response: URLResponse?) throws -> T.Response? {
        print(String(data: data!, encoding: .utf8)!)
        guard let response = response else {
            throw Error.networkError(message: "No response from server", error: nil)
        }
        guard let httpResponse = response as? HTTPURLResponse else {
            throw Error.networkError(message: "Not a HTTP response", error: nil)
        }
        if httpResponse.statusCode != 200 {
            throw Error.networkError(message: "Server responded with HTTP \(httpResponse.statusCode)", error: nil)
        }
        guard let data = data else {
            throw Error.networkError(message: "Response body empty", error: nil)
        }
        let decoder = Client.JSONDecoder()
        let responsePayload: ResponsePayload<T>
        do {
            responsePayload = try decoder.decode(ResponsePayload<T>.self, from: data)
        } catch {
            throw Error.codingError(message: "Unable to decode response", error: error)
        }
        if let error = responsePayload.error {
            throw Error.responseError(code: error.code, message: error.message, data: error.resolvedData)
        }
        if responsePayload.id != payload.id {
            throw Error.networkError(message: "Request id mismatch", error: nil)
        }
        return responsePayload.result
    }

    /// Send a JSON-RPC 2.0 request.
    /// - Parameter request: The request to be sent.
    /// - Parameter completionHandler: Callback function, called with either a response or an error.
    public func send<T: Request>(_ request: T, completionHandler: @escaping (T.Response?, Swift.Error?) -> Void) -> Void {
        let payload = RequestPayload(request: request, id: self.idgen.next())
        let urlRequest: URLRequest
        do {
            urlRequest = try self.urlRequest(for: payload)
        } catch {
            return completionHandler(nil, Error.codingError(message: "Unable to encode payload", error: error))
        }
        self.session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                return completionHandler(nil, Error.networkError(message: "Unable to send request", error: error))
            }
            let rv: T.Response?
            do {
                rv = try self.resolveResponse(for: payload, data: data, response: response)
            } catch {
                return completionHandler(nil, error)
            }
            completionHandler(rv, nil)
        }.resume()
    }

    /// Blocking `.send(..)`.
    /// - Warning: This should never be called from the main thread.
    public func sendSynchronous<T: Request>(_ request: T) throws -> T.Response! {
        let semaphore = DispatchSemaphore(value: 0)
        var result: T.Response?
        var error: Swift.Error?
        self.send(request) {
            result = $0
            error = $1
            semaphore.signal()
        }
        semaphore.wait()
        if let error = error {
            throw error
        }
        return result
    }
    
    func getChainID() -> Promise<String> {
        let promise: Promise<String> = Promise { seal in
            self.send(API.GetChainID()) { res, error in
                if(error != nil) {
                    seal.reject(error!)
                    return
                }
                
                if let res = res {
                    seal.fulfill(res)
                } else {
                    let err = Error.networkError(message: "Not a HTTP response", error: nil)
                    seal.reject(/*error!*/err)
                }
                
            }
        }
        return promise
    }
    
    //GetDynamicGlobalProperties
    func getDynamicGlobalProperties() -> Promise<API.DynamicGlobalProperties> {
        let promise: Promise<API.DynamicGlobalProperties> = Promise { seal in
            self.send(API.GetDynamicGlobalProperties()) { res, error in
                if(error != nil) {
                    seal.reject(error!)
                    return
                }
                
                if let res = res {
                    seal.fulfill(res)
                } else {
                    seal.reject(error!)
                }
                
            }
        }
        return promise
    }
    
    func lookupAssetSymbols(_ names: [String]) -> Promise<[Asset]> {
        let promise: Promise<[Asset]> = Promise { seal in
            self.send(API.LookupAssetSymbols(names: names)) { res, error in
                if(error != nil) {
                    seal.reject(error!)
                    return
                }
                
                if let res = res {
                    seal.fulfill(res)
                } else {
                    seal.reject(error!)
                }
                
            }
        }
        return promise
    }
    
    func getBlock(_ blockNum: Int) -> Promise<SignedBlock> {
        let promise: Promise<SignedBlock> = Promise { seal in
            self.send(API.GetBlock(blockNum: blockNum)) { res, error in
                if(error != nil) {
                    seal.reject(error!)
                    return
                }
                
                if let res = res {
                    seal.fulfill(res)
                } else {
                    seal.reject(error!)
                }
                
            }
        }
        return promise
    }
    
    func getRequiredFee(_ ops: [AnyOperation], _ assetID: String) -> Promise<[AssetAmount]> {
        let promise: Promise<[AssetAmount]> = Promise { seal in
            self.send(API.GetRequiredFee(ops: ops, assetID: assetID)) { res, error in
                if(error != nil) {
                    seal.reject(error!)
                    return
                }
                
                if let res = res {
                    seal.fulfill(res)
                } else {
                    seal.reject(error!)
                }
                
            }
        }
        return promise
    }
    
    func getAccountByName(_ name: String) -> Promise<API.Account?> {
        let promise: Promise<API.Account?> = Promise { seal in
            self.send(API.GetAccountByName(name: name)) { res, error in
                if(error != nil) {
                    seal.reject(error!)
                    return
                }
                
                if let res = res {
                    seal.fulfill(res)
                } else {
                    seal.fulfill(nil)
                }
            }
        }
        return promise
    }
    
    func getContractAccountByName(_ name: String) -> Promise<ContractAccountProperties> {
        let promise: Promise<ContractAccountProperties> = Promise { seal in
            self.send(API.GetContractAccountByName(name: name)) { res, error in
                if(error != nil) {
                    seal.reject(error!)
                    return
                }
                
                if let res = res {
                    seal.fulfill(res)
                } else {
                    seal.reject(error!)
                }
                
            }
        }
        return promise
    }
    
    func getContractABI(_ name: String) -> Abi? {
        let account = try? await(getContractAccountByName(name))
        return account?.abi
    }
    
    func getContractTable(_ name: String) -> [Table]? {
        let abi = getContractABI(name)
        return abi?.tables
    }
    
    func broadcastTransaction(_ tx: SignedTransaction) -> Promise<String> {
        let promise: Promise<String> = Promise { seal in
            self.send(API.BroadcastTransaction(transaction: tx)) { res, error in
                if(error != nil) {
                    seal.reject(error!)
                    return
                }
                
                if let res = res {
                    seal.fulfill(res)
                } else {
                    seal.reject(error!)
                }
                
            }
        }
        return promise
    }
    
    func getObjects(_ ids: [String]) -> Promise<[ObjectParameters]> {
        let promise: Promise<[ObjectParameters]> = Promise { seal in
            self.send(API.GetObjects(ids: ids)) { res, error in
                if(error != nil) {
                    seal.reject(error!)
                    return
                }
                
                if let res = res {
                    seal.fulfill(res)
                } else {
                    seal.reject(error!)
                }
                
            }
        }
        return promise
    }
    
    func getAccounts(_ ids: [String]) -> Promise<[API.Account]> {
        let promise: Promise<[API.Account]> = Promise { seal in
            self.send(API.GetAccounts(ids: ids)) { res, error in
                if(error != nil) {
                    seal.reject(error!)
                    return
                }
                
                if let res = res {
                    seal.fulfill(res)
                } else {
                    seal.reject(error!)
                }
                
            }
        }
        return promise
    }
    
    func getAccountsByNames(_ names: [String]) -> [API.Account?] {
        var accounts:[API.Account?] = []
        for name in names {
            let account = try? await(getAccountByName(name))
            accounts.append(account!)
        }
        return accounts
    }
    
    func getWitnessByAccount(_ id: String) -> Promise<Witness?> {
        let promise: Promise<Witness?> = Promise { seal in
            self.send(API.GetWitnessByAccount(id: id)) { res, error in
                if(error != nil) {
                    seal.reject(error!)
                    return
                }
                
                if let res = res {
                    seal.fulfill(res)
                } else {
                    seal.fulfill(nil)
                }
                
            }
        }
        return promise
    }
    
    func getCommitteeMemberByAccount(_ id: String) -> Promise<Committee?> {
        let promise: Promise<Committee?> = Promise { seal in
            self.send(API.GetCommitteeMemberByAccount(id: id)) { res, error in
                if(error != nil) {
                    seal.reject(error!)
                    return
                }
                if let res = res {
                    seal.fulfill(res)
                } else {
                    seal.fulfill(nil)
                }
                
            }
        }
        return promise
    }
    
    func getVoteIdsByAccounts(_ names: [String]) -> [String] {
        var ids:[String] = []
        
        let accounts = getAccountsByNames(names)
        for account in accounts {
            guard let acc = account else {
                continue
            }
            let wii = try? await(getWitnessByAccount(acc.id.id))
            if let wi = wii, let w = wi {
                ids.append(w.voteId)
            }
            
            let coo = try? await(getCommitteeMemberByAccount(acc.id.id))
            guard let co = coo else {
                continue
            }
            guard let c = co else {
                continue
            }
            ids.append(c.voteId)
        }
        return ids
    }
    
    func getTableRows(_ contractName: String, _ tableName: String, _ lowerBound: Int32, _ upperBound: Int32) -> Promise<AnyDecodable> {
        let promise: Promise<AnyDecodable> = Promise { seal in
            self.send(API.GetTableRows(contractName: contractName, tableName: tableName, lowerBound: lowerBound, upperBound: upperBound)) { res, error in
                if(error != nil) {
                    seal.reject(error!)
                    return
                }
                
                if let res = res {
                    seal.fulfill(res)
                } else {
                    seal.reject(error!)
                }
                
            }
        }
        return promise
    }
    
    func getTableObjects(_ contractName: String, _ tableName: String, _ params: API.TableRowsParams) -> Promise<AnyDecodable> {
        let promise: Promise<AnyDecodable> = Promise { seal in
            self.send(API.GetTableRowsEx(contractName: contractName, tableName: tableName, params: params)) { res, error in
                if(error != nil) {
                    seal.reject(error!)
                    return
                }
                
                if let res = res {
                    seal.fulfill(res)
                } else {
                    seal.reject(error!)
                }
                
            }
        }
        return promise
    }
    
    func getAccountBalances(_ accountId: String, _ assetIDs: [String]) -> Promise<[AssetAmount]> {
        let promise: Promise<[AssetAmount]> = Promise { seal in
            self.send(API.GetAccountBalances(accountId: accountId, assetIDs: assetIDs)) { res, error in
                if(error != nil) {
                    seal.reject(error!)
                    return
                }
                
                if let res = res {
                    seal.fulfill(res)
                } else {
                    seal.reject(error!)
                }
                
            }
        }
        return promise
    }
    
    func getNamedAccountBalances(_ accountName: String, _ assetIDs: [String]) -> Promise<[AssetAmount]> {
        let promise: Promise<[AssetAmount]> = Promise { seal in
            self.send(API.GetNamedAccountBalances(name: accountName, assetIDs: assetIDs)) { res, error in
                if(error != nil) {
                    seal.reject(error!)
                    return
                }
                
                if let res = res {
                    seal.fulfill(res)
                } else {
                    seal.reject(error!)
                }
                
            }
        }
        return promise
    }
    
    func getAccountsByPublicKeys(_ publicKeys: [String]) -> Promise<[[String]]> {
        let promise: Promise<[[String]]> = Promise { seal in
            self.send(API.GetAccountsByPublicKeys(publicKeys: publicKeys)) { res, error in
                if(error != nil) {
                    seal.reject(error!)
                    return
                }
                
                if let res = res {
                    seal.fulfill(res)
                } else {
                    seal.reject(error!)
                }
                
            }
        }
        return promise
    }
    
    func serializeContractCallArgs(_ contractName: String, _ method: String, _ parameters: String?) -> Promise<String> {
        let promise: Promise<String> = Promise { seal in
            self.send(API.SerializeContractCallArgs(contractName: contractName, method: method, parameters: parameters)) { res, error in
                if(error != nil) {
                    seal.reject(error!)
                    return
                }
                
                if let res = res {
                    seal.fulfill(res)
                } else {
                    seal.reject(error!)
                }
                
            }
        }
        return promise
    }
    
    func sign(wif: String, operations:[OperationType], chainId: String) throws -> SignedTransaction {
        guard let key = PrivateKey(wif) else {
            throw Error.codingError(message: "decoded private key error", error: nil)
        }
        guard let props = try? await(self.getDynamicGlobalProperties()) else {
            throw Error.networkError(message: "failed to get dynamic global properties", error: nil)
        }
        
        guard let block = try? await(self.getBlock(Int(props.lastIrreversibleBlockNum))) else {
            throw Error.networkError(message: "failed to get block", error: nil)
        }
        let refBlockPrefix = TransactionUtils.refBlockPrefix(block.previous.hex)
        let expiration = props.time.addingTimeInterval(600)
        let refBlockNum = TransactionUtils.refBlockNum(props.lastIrreversibleBlockNum - 1 & 0xffff)
        let tx = Transaction(refBlockNum: refBlockNum, refBlockPrefix: refBlockPrefix, expiration: expiration, operations: operations)
        let customChain = Data(hex: chainId)
        let signedTransaction = try tx.sign(usingKey: key, forChain: .custom(customChain))
        
        return signedTransaction
    }
    
    func transfer(key: String,
                  chainId: String,
                  from: GrapheneId,
                  to: GrapheneId,
                  amount:AssetAmount,
                  fee:AssetAmount,
                  memo:Memo? = nil) throws -> String {
        var op = Transfer(from: from, to: to, amount: amount, fee: fee, memo: memo)
        let assetID = fee.assetId.id
        guard let assets = try? await(self.getRequiredFee([AnyOperation(op)], assetID)) else {
            throw Error.networkError(message: "failed to get fees", error: nil)
        }

        op.fee.amount = assets[0].amount
        let operations: [OperationType] = [op]
        guard let signedTransaction = try? self.sign(wif: key, operations: operations, chainId: chainId) else {
            throw Error.networkError(message: "failed to sign tx", error: nil)
        }
        
        guard let ret = try? await(self.broadcastTransaction(signedTransaction)) else {
            throw Error.networkError(message: "failed to broadcast tx", error: nil)
        }
        return ret
    }
    
    class func register(faucet: String,
                        account: String,
                        activeKey: String,
                        ownerKey: String? = nil,
                        memoKey: String? = nil) ->  Promise<Transaction> {
        let accountInfo = API.RegisterAccountInfo(name: account, activeKey: activeKey, ownerKey: ownerKey, memoKey: memoKey)
        let promise: Promise<Transaction> = Promise { seal in
            Register(faucet: faucet, accountInfo: accountInfo){ res, error in
                if(error != nil) {
                    seal.reject(error!)
                    return
                }
                
                if let res = res {
                    seal.fulfill(res)
                } else {
                    seal.reject(error!)
                }
                
            }
        }
        return promise
    }
    
    class func Register(faucet: String,
                        accountInfo: API.RegisterAccountInfo,
                        completionHandler: @escaping(Transaction?, Swift.Error?) -> Void) -> Void {
        
        let parameters = [
            "account": [
                "name" : accountInfo.name,
                "active_key" : accountInfo.activeKey,
                "owner_key" : accountInfo.ownerKey,
                "memo_key" : accountInfo.memoKey,
            ]
        ]
        
        let utilityQueue = DispatchQueue.global(qos: .utility)
        let headers = [ "Content-Type": "application/json" ]
        
        Alamofire.request("https://testnet.faucet.gxchain.org/account/register", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON(queue: utilityQueue) { (response) in
            
            switch response.result{
            case .success:
                
                if let _ = response.result.value{
                    let decoder = Client.JSONDecoder()
                    let responsePayload: Transaction
                    do {
                        responsePayload = try decoder.decode(Transaction.self, from: response.data!)
                    } catch {
                        let err = Error.codingError(message: "Unable to decode response", error: error)
                        completionHandler(nil, err)
                        return
                    }
                    completionHandler(responsePayload, nil)
                }
                break
                
            case .failure(let err):
                completionHandler(nil, err)
                break
            }
 
            //let s = String(data: response.data!, encoding: .utf8)
            //print(s!)
        }
        
    }
    
    func vote(key: String,
              chainId: String,
              from: String,
              accounts: [String],
              proxyAccount:String? = nil,
              feeAsset:String = "GXC") throws -> String {
        guard let myAccount = try? await(self.getAccountByName(from)) else {
            throw Error.networkError(message: "Bad Parameter", error: nil)
        }
        let myAccountId = myAccount!.id
        
        var votingAccountId: GrapheneId? = nil
        if proxyAccount == nil {
            votingAccountId = GrapheneId("1.2.5")
        } else {
            guard let votingAccount = try? await(self.getAccountByName(proxyAccount!)) else {
                throw Error.networkError(message: "Bad Parameter", error: nil)
            }
            votingAccountId = votingAccount!.id
        }
        
        let voteIds = self.getVoteIdsByAccounts(accounts)
        
        guard let assets = try? await(self.lookupAssetSymbols([feeAsset])) else {
            throw Error.networkError(message: "Bad Parameter", error: nil)
        }
        let feeAssetId = assets[0].id
        
        guard let objs = try? await(self.getObjects(["2.0.0"])) else {
            throw Error.networkError(message: "Exception occurred", error: nil)
        }
        let maximumCommitteeCount = objs[0].parameters.maximumCommitteeCount
        let maximumWitnessCount = objs[0].parameters.maximumWitnessCount
        
        var newOptions = myAccount!.options
        for voteId in voteIds {
            let vote = VoteId(voteId)
            newOptions.votes.append(vote!)
        }
        newOptions.votes = newOptions.votes.sorted{ $1.instance > $0.instance }.unique
        
        var numCommitee: UInt16 = 0
        var numWitness: UInt16 = 0
        for voteId in newOptions.votes {
            let typ = voteId.type
            if(typ == 0) {
                numCommitee += 1
            }
            if(typ == 1) {
                numWitness += 1
            }
        }
        
        newOptions.numWitness = numWitness < maximumWitnessCount ? numWitness : maximumWitnessCount
        newOptions.numCommittee = numCommitee < maximumCommitteeCount ? numCommitee : maximumCommitteeCount
        newOptions.votingAccount = votingAccountId!
        
        let fee = AssetAmount(feeAssetId, 0)
        var op = AccountUpdate(fee: fee, account: myAccountId, owner: nil, active: nil, newOptions: newOptions)
        let assetID = fee.assetId.id
        guard let fees = try? await(self.getRequiredFee([AnyOperation(op)], assetID)) else {
            throw Error.networkError(message: "failed to get fees", error: nil)
        }
        
        op.fee.amount = fees[0].amount
        let operations: [OperationType] = [op]
        guard let signedTransaction = try? self.sign(wif: key, operations: operations, chainId: chainId) else {
            throw Error.networkError(message: "failed to sign tx", error: nil)
        }
        
        guard let ret = try? await(self.broadcastTransaction(signedTransaction)) else {
            throw Error.networkError(message: "failed to broadcast tx", error: nil)
        }
        return ret
    }
    
    func getSignedProxyTransferParams(key: String,
                       from: String,
                       to: String,
                       proxy: String,
                       amount: AssetAmount,
                       percentage: UInt16,
                       memo: String) throws -> SignedProxyTransferParams {
        guard let fromAccount = try? await(self.getAccountByName(from)) else {
            throw Error.networkError(message: "Bad Parameter", error: nil)
        }
        let fromAccountId = fromAccount!.id
        
        guard let toAccount = try? await(self.getAccountByName(to)) else {
            throw Error.networkError(message: "Bad Parameter", error: nil)
        }
        let toAccountId = toAccount!.id
        
        guard let proxyAccount = try? await(self.getAccountByName(proxy)) else {
            throw Error.networkError(message: "Bad Parameter", error: nil)
        }
        let proxyAccountId = proxyAccount!.id
        
        guard let props = try? await(self.getDynamicGlobalProperties()) else {
            throw Error.networkError(message: "failed to get dynamic global properties", error: nil)
        }
        
        let expiration = props.time.addingTimeInterval(600)
        var signedProxyTransferParams = SignedProxyTransferParams(from: fromAccountId,
                                         to: toAccountId,
                                         proxyAccount:proxyAccountId,
                                         amount: amount,
                                         percentage: percentage,
                                         memo: memo,
                                         expiration: expiration)
        try signedProxyTransferParams.sign(key)
        return signedProxyTransferParams
    }
    
    
    func proxyTransfer(key: String,
              chainId: String,
              proxyMemo: String,
              requestParams: SignedProxyTransferParams,
              feeAsset:String = "GXC") throws -> String {
        guard let assets = try? await(self.lookupAssetSymbols([feeAsset])) else {
            throw Error.networkError(message: "Bad Parameter", error: nil)
        }
        let feeAssetId = assets[0].id
        
        let fee = AssetAmount(feeAssetId, 0)
        var op = ProxyTransfer(fee: fee, proxyMemo: proxyMemo, requestParams: requestParams)
        let assetID = fee.assetId.id
        guard let fees = try? await(self.getRequiredFee([AnyOperation(op)], assetID)) else {
            throw Error.networkError(message: "failed to get fees", error: nil)
        }
        
        op.fee.amount = fees[0].amount
        let operations: [OperationType] = [op]
        guard let signedTransaction = try? self.sign(wif: key, operations: operations, chainId: chainId) else {
            throw Error.networkError(message: "failed to sign tx", error: nil)
        }
        
        guard let ret = try? await(self.broadcastTransaction(signedTransaction)) else {
            throw Error.networkError(message: "failed to broadcast tx", error: nil)
        }
        return ret
    }
    
    func callContract(key: String,
                       chainId: String,
                       from: String,
                       contractName: String,
                       method: String,
                       parameters: String?,
                       amount: AssetAmount? = nil,
                       feeAsset:String = "GXC") throws -> String {
        guard let myAccount = try? await(self.getAccountByName(from)) else {
            throw Error.networkError(message: "Bad Parameter", error: nil)
        }
        let myAccountId = myAccount!.id
        
        guard let contract = try? await(self.getContractAccountByName(contractName)) else {
            throw Error.networkError(message: "Bad Parameter", error: nil)
        }
        let contractId = contract.id
        
        var jsonData = "{}"
        if parameters != nil {
            jsonData = parameters!
        }

        
        guard let data = try? await(self.serializeContractCallArgs(contractName, method, jsonData)) else {
            throw Error.networkError(message: "Bad Parameter", error: nil)
        }
        
        guard let assets = try? await(self.lookupAssetSymbols([feeAsset])) else {
            throw Error.networkError(message: "Bad Parameter", error: nil)
        }
        let feeAssetId = assets[0].id
        
        let fee = AssetAmount(feeAssetId, 0)
        var op = CallContract(fee: fee, account: myAccountId, contractId: contractId, amount: amount, methodName: Name(name: method), data: data)
        let assetID = fee.assetId.id
        guard let fees = try? await(self.getRequiredFee([AnyOperation(op)], assetID)) else {
            throw Error.networkError(message: "failed to get fees", error: nil)
        }
        
        op.fee.amount = fees[0].amount
        let operations: [OperationType] = [op]
        guard let signedTransaction = try? self.sign(wif: key, operations: operations, chainId: chainId) else {
            throw Error.networkError(message: "failed to sign tx", error: nil)
        }
        
        guard let ret = try? await(self.broadcastTransaction(signedTransaction)) else {
            throw Error.networkError(message: "failed to broadcast tx", error: nil)
        }
        return ret
    }
    
    func createContract(key: String,
                      chainId: String,
                      from: String,
                      contractName: String,
                      code: String,
                      abi: Abi,
                      vmType: String,
                      vmVersion: String,
                      feeAsset:String = "GXC") throws -> String {
        guard let myAccount = try? await(self.getAccountByName(from)) else {
            throw Error.networkError(message: "Bad Parameter", error: nil)
        }
        let myAccountId = myAccount!.id
        
        if code.count <= 0 {
            throw Error.networkError(message: "Bad Parameter", error: nil)
        }
        
        guard let assets = try? await(self.lookupAssetSymbols([feeAsset])) else {
            throw Error.networkError(message: "Bad Parameter", error: nil)
        }
        let feeAssetId = assets[0].id
        
        let fee = AssetAmount(feeAssetId, 0)
        var op = CreateContract(fee: fee, name: contractName, account: myAccountId, vmType: vmType, vmVersion: vmVersion, code: code, abi: abi)
        let assetID = fee.assetId.id
        guard let fees = try? await(self.getRequiredFee([AnyOperation(op)], assetID)) else {
            throw Error.networkError(message: "failed to get fees", error: nil)
        }
        
        op.fee.amount = fees[0].amount
        let operations: [OperationType] = [op]
        guard let signedTransaction = try? self.sign(wif: key, operations: operations, chainId: chainId) else {
            throw Error.networkError(message: "failed to sign tx", error: nil)
        }
        
        guard let ret = try? await(self.broadcastTransaction(signedTransaction)) else {
            throw Error.networkError(message: "failed to broadcast tx", error: nil)
        }
        return ret
    }
    
    func updateContract(key: String,
                        chainId: String,
                        from: String,
                        contractName: String,
                        code: String,
                        abi: Abi,
                        newOwner: String? = nil,
                        feeAsset:String = "GXC") throws -> String {
        guard let myAccount = try? await(self.getAccountByName(from)) else {
            throw Error.networkError(message: "Bad Parameter", error: nil)
        }
        let myAccountId = myAccount!.id
        
        if code.count <= 0 {
            throw Error.networkError(message: "Bad Parameter", error: nil)
        }
        
        guard let contract = try? await(self.getContractAccountByName(contractName)) else {
            throw Error.networkError(message: "Bad Parameter", error: nil)
        }
        let contractId = contract.id
        
        var newOwnerId: GrapheneId? = nil
        if newOwner != nil {
            guard let newAccount = try? await(self.getAccountByName(newOwner!)) else {
                throw Error.networkError(message: "Bad Parameter", error: nil)
            }
            newOwnerId = newAccount!.id
        }
        
        guard let assets = try? await(self.lookupAssetSymbols([feeAsset])) else {
            throw Error.networkError(message: "Bad Parameter", error: nil)
        }
        let feeAssetId = assets[0].id
        
        let fee = AssetAmount(feeAssetId, 0)
        var op = UpdateContract(fee: fee, owner: myAccountId, newOwner: newOwnerId, contract: contractId, code: code, abi: abi)
        let assetID = fee.assetId.id
        guard let fees = try? await(self.getRequiredFee([AnyOperation(op)], assetID)) else {
            throw Error.networkError(message: "failed to get fees", error: nil)
        }
        
        op.fee.amount = fees[0].amount
        let operations: [OperationType] = [op]
        guard let signedTransaction = try? self.sign(wif: key, operations: operations, chainId: chainId) else {
            throw Error.networkError(message: "failed to sign tx", error: nil)
        }
        
        guard let ret = try? await(self.broadcastTransaction(signedTransaction)) else {
            throw Error.networkError(message: "failed to broadcast tx", error: nil)
        }
        return ret
    }
    
}

/// JSON Coding helpers.
extension Client {
    /// Steem-style date formatter (ISO 8601 minus Z at the end).
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter
    }()

    static let dateEncoder = Foundation.JSONEncoder.DateEncodingStrategy.custom { (date, encoder) throws in
        var container = encoder.singleValueContainer()
        try container.encode(dateFormatter.string(from: date))
    }

    static let dataEncoder = Foundation.JSONEncoder.DataEncodingStrategy.custom { (data, encoder) throws in
        var container = encoder.singleValueContainer()
        try container.encode(data.hexEncodedString())
    }

    static let dateDecoder = Foundation.JSONDecoder.DateDecodingStrategy.custom { (decoder) -> Date in
        let container = try decoder.singleValueContainer()
        guard let date = dateFormatter.date(from: try container.decode(String.self)) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date")
        }
        return date
    }

    static let dataDecoder = Foundation.JSONDecoder.DataDecodingStrategy.custom { (decoder) -> Data in
        let container = try decoder.singleValueContainer()
        return Data(hexEncoded: try container.decode(String.self))
    }

    /// Returns a JSONDecoder instance configured for the Steem JSON format.
    public static func JSONDecoder() -> Foundation.JSONDecoder {
        let decoder = Foundation.JSONDecoder()
        decoder.dataDecodingStrategy = dataDecoder
        decoder.dateDecodingStrategy = dateDecoder
        #if !os(Linux)
            decoder.keyDecodingStrategy = .convertFromSnakeCase
        #endif
        return decoder
    }
    
    /// Returns a JSONEncoder instance configured for the Steem JSON format.
    public static func JSONEncoder() -> Foundation.JSONEncoder {
        let encoder = Foundation.JSONEncoder()
        encoder.dataEncodingStrategy = dataEncoder
        encoder.dateEncodingStrategy = dateEncoder
        #if !os(Linux)
            encoder.keyEncodingStrategy = .convertToSnakeCase
        #endif
        return encoder
    }
}

#if os(Linux)
    fileprivate let WARNING = print(
        """
            WARNING: Swift 4.1 on Linux is missing the snake case decoding JSON strategies.
                     Some API request may fail until this is fixed or a workaround can be found.

                     More info:
                     https://bugs.swift.org/browse/SR-7180

        """
    )
#endif
