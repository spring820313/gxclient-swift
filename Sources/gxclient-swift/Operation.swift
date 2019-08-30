/// Steem operation types.
/// - Author: Johan Nordberg <johan@steemit.com>

import Foundation

/// A type that represents a operation on the Steem blockchain.
public protocol OperationType: GxcCodable {}


/// Unknown operation, seen if the decoder encounters operation which has no type defined.
/// - Note: Not encodable, the encoder will throw if encountering this operation.
public struct Unknown: OperationType, Equatable {}


// MARK: - Encoding

/// Operation ID, used for coding.
public enum OperationId: UInt8, GxcEncodable, Decodable {
    case transfer = 0
    case limit_order_create = 1
    case limit_order_cancel = 2
    case call_order_update
    case fill_order
    case account_create
    case account_update
    case account_whitelist
    case account_upgrade
    case account_transfer
    case asset_create
    case asset_update
    case asset_update_bitasset
    case asset_update_feed_producers
    case asset_issue
    case asset_reserve
    case asset_fund_fee_pool
    case asset_settle
    case asset_global_settle
    case asset_publish_feed
    case witness_create
    case witness_update
    case proposal_create
    case proposal_update
    case proposal_delete
    case withdraw_permission_create
    case withdraw_permission_update
    case withdraw_permission_claim
    case withdraw_permission_delete
    case committee_member_create
    case committee_member_update
    case committee_member_update_global_parameters
    case vesting_balance_create
    case vesting_balance_withdraw
    case worker_create
    case custom
    case assert
    case balance_claim
    case override_transfer
    case transfer_to_blind
    case blind_transfer
    case transfer_from_blind
    case asset_settle_cancel
    case asset_claim_fees
    case fba_distribute
    case account_upgrade_merchant
    case account_upgrade_datasource
    case stale_data_market_category_create
    case stale_data_market_category_update
    case stale_free_data_product_create
    case stale_free_data_product_update
    case stale_league_data_product_create
    case stale_league_data_product_update
    case stale_league_create
    case stale_league_update
    case data_transaction_create
    case data_transaction_update
    case data_transaction_pay
    case account_upgrade_data_transaction_member
    case data_transaction_datasource_upload
    case data_transaction_datasource_validate_error
    case data_market_category_create
    case data_market_category_update
    case free_data_product_create
    case free_data_product_update
    case league_data_product_create
    case league_data_product_update
    case league_create
    case league_update
    case datasource_copyright_clear
    case data_transaction_complain
    case balance_lock
    case balance_unlock
    case proxy_transfer
    case create_contract
    case call_contract
    case update_contract
    case trust_node_pledge_withdraw
    case inline_transfer
    case inter_contract_call

    case unknown = 255

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let t = try container.decode(UInt8.self)
        switch t {
        case 0: self = .transfer
        case 1: self = .limit_order_create
        case 2: self = .limit_order_cancel
        case 3: self = .call_order_update
        case 4: self = .fill_order
        case 5: self = .account_create
        case 6: self = .account_update
        case 7: self = .account_whitelist
        case 8: self = .account_upgrade
        case 9: self = .account_transfer
        case 10: self = .asset_create
        case 11: self = .asset_update
        case 12: self = .asset_update_bitasset
        case 13: self = .asset_update_feed_producers
        case 14: self = .asset_issue
        case 15: self = .asset_reserve
        case 16: self = .asset_fund_fee_pool
        case 17: self = .asset_settle
        case 18: self = .asset_global_settle
        case 19: self = .asset_publish_feed
        case 20: self = .witness_create
        case 21: self = .witness_update
        case 22: self = .proposal_create
        case 23: self = .proposal_update
        case 24: self = .proposal_delete
        case 25: self = .withdraw_permission_create
        case 26: self = .withdraw_permission_update
        case 27: self = .withdraw_permission_claim
        case 28: self = .withdraw_permission_delete
        case 29: self = .committee_member_create
        case 30: self = .committee_member_update
        case 31: self = .committee_member_update_global_parameters
        case 32: self = .vesting_balance_create
        case 33: self = .vesting_balance_withdraw
        case 34: self = .worker_create
        case 35: self = .custom
        case 36: self = .assert
        case 37: self = .balance_claim
        case 38: self = .override_transfer
        case 39: self = .transfer_to_blind
        case 40: self = .blind_transfer
        case 41: self = .transfer_from_blind
        case 42: self = .asset_settle_cancel
        case 43: self = .asset_claim_fees
        case 44: self = .fba_distribute
        case 45: self = .account_upgrade_merchant
        case 46: self = .account_upgrade_datasource
        case 47: self = .stale_data_market_category_create
        case 48: self = .stale_data_market_category_update
        case 49: self = .stale_free_data_product_create
        case 50: self = .stale_free_data_product_update
        case 51: self = .stale_league_data_product_create
        case 52: self = .stale_league_data_product_update
        case 53: self = .stale_league_create
        case 54: self = .stale_league_update
        case 55: self = .data_transaction_create
        case 56: self = .data_transaction_update
        case 57: self = .data_transaction_pay
        case 58: self = .account_upgrade_data_transaction_member
        case 59: self = .data_transaction_datasource_upload
        case 60: self = .data_transaction_datasource_validate_error
        case 61: self = .data_market_category_create
        case 62: self = .data_market_category_update
        case 63: self = .free_data_product_create
        case 64: self = .free_data_product_update
        case 65: self = .league_data_product_create
        case 66: self = .league_data_product_update
        case 67: self = .league_create
        case 68: self = .league_update
        case 69: self = .datasource_copyright_clear
        case 70: self = .data_transaction_complain
        case 71: self = .balance_lock
        case 72: self = .balance_unlock
        case 73: self = .proxy_transfer
        case 74: self = .create_contract
        case 75: self = .call_contract
        case 76: self = .update_contract
        case 77: self = .trust_node_pledge_withdraw
        case 78: self = .inline_transfer
        case 79: self = .inter_contract_call

        default: self = .unknown
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }

    public func binaryEncode(to encoder:GxcEncoder) throws {
        try encoder.encode(self.rawValue)
    }
}

/// A type-erased Steem operation.
public struct AnyOperation: GxcEncodable, Decodable {
    public let operation: OperationType

    /// Create a new operation wrapper.
    public init<O>(_ operation: O) where O: OperationType {
        self.operation = operation
    }

    public init(_ operation: OperationType) {
        self.operation = operation
    }

    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let id = try container.decode(OperationId.self)
        let op: OperationType
        /*
        switch id {
        case .transfer: op = try container.decode(Transfer.self)
        case .account_create: op = try container.decode(AccountCreate.self)
        case .account_update: op = try container.decode(AccountUpdate.self)
        case .proxy_transfer: op = try container.decode(ProxyTransfer.self)
        case .call_contract: op = try container.decode(CallContract.self)
        case .create_contract: op = try container.decode(CreateContract.self)
        case .update_contract: op = try container.decode(UpdateContract.self)
        default: op = Unknown()
        }
        self.operation = op
        */
        
        switch id {
        case .transfer: op = try container.decode(Transfer.self)
        case .limit_order_create: op = try container.decode(LimitOrderCreate.self)
        case .limit_order_cancel: op = try container.decode(LimitOrderCancel.self)
        case .call_order_update: op = try container.decode(CallOrderUpdate.self)
        case .fill_order: op = try container.decode(FillOrder.self)
        case .account_create: op = try container.decode(AccountCreate.self)
        case .account_update: op = try container.decode(AccountUpdate.self)
        case .account_whitelist: op = try container.decode(AccountWhitelist.self)
        case .account_upgrade: op = try container.decode(AccountUpgrade.self)
        case .account_transfer: op = try container.decode(AccountTransfer.self)
        case .asset_create: op = try container.decode(AssetCreate.self)
        case .asset_update: op = try container.decode(AssetUpdate.self)
        case .asset_update_bitasset: op = try container.decode(AssetUpdateBitasset.self)
        case .asset_update_feed_producers: op = try container.decode(AssetUpdateFeedProducers.self)
        case .asset_issue: op = try container.decode(AssetIssue.self)
        case .asset_reserve: op = try container.decode(AssetReserve.self)
        case .asset_fund_fee_pool: op = try container.decode(AssetFundFeePool.self)
        case .asset_settle: op = try container.decode(AssetSettle.self)
        case .asset_global_settle: op = try container.decode(AssetGlobalSettle.self)
        case .asset_publish_feed: op = try container.decode(AssetPublishFeed.self)
        case .witness_create: op = try container.decode(WitnessCreate.self)
        case .witness_update: op = try container.decode(WitnessUpdate.self)
        case .proposal_create: op = try container.decode(ProposalCreate.self)
        case .proposal_update: op = try container.decode(ProposalUpdate.self)
        case .proposal_delete: op = try container.decode(ProposalDelete.self)
        case .withdraw_permission_create: op = try container.decode(WithdrawPermissionCreate.self)
        case .withdraw_permission_update: op = try container.decode(WithdrawPermissionUpdate.self)
        case .withdraw_permission_claim: op = try container.decode(WithdrawPermissionClaim.self)
        case .withdraw_permission_delete: op = try container.decode(WithdrawPermissionDelete.self)
        case .committee_member_create: op = try container.decode(CommitteeMemberCreate.self)
        case .committee_member_update: op = try container.decode(CommitteeMemberUpdate.self)
        case .committee_member_update_global_parameters: op = try container.decode(CommitteeMemberUpdateGlobalParameters.self)
        case .vesting_balance_create: op = try container.decode(VestingBalanceCreate.self)
        case .vesting_balance_withdraw: op = try container.decode(VestingBalanceWithdraw.self)
        case .worker_create: op = try container.decode(WorkerCreate.self)
        case .custom: op = try container.decode(Custom.self)
        case .assert: op = try container.decode(Assert.self)
        case .balance_claim: op = try container.decode(BalanceClaim.self)
        case .override_transfer: op = try container.decode(OverrideTransfer.self)
        case .transfer_to_blind: op = try container.decode(TransferToBlind.self)
        case .blind_transfer: op = try container.decode(BlindTransfer.self)
        case .transfer_from_blind: op = try container.decode(TransferFromBlind.self)
        case .asset_settle_cancel: op = try container.decode(AssetSettleCancel.self)
        case .asset_claim_fees: op = try container.decode(AssetClaimFees.self)
        case .fba_distribute: op = try container.decode(FbaDistribute.self)
        case .account_upgrade_merchant: op = try container.decode(AccountUpgradeMerchant.self)
        case .account_upgrade_datasource: op = try container.decode(AccountUpgradeDatasource.self)
        case .stale_data_market_category_create: op = try container.decode(StaleDataMarketCategoryCreate.self)
        case .stale_data_market_category_update: op = try container.decode(StaleDataMarketCategoryUpdate.self)
        case .stale_free_data_product_create: op = try container.decode(StaleFreeDataProductCreate.self)
        case .stale_free_data_product_update: op = try container.decode(StaleFreeDataProductUpdate.self)
        case .stale_league_data_product_create: op = try container.decode(StaleLeagueDataProductCreate.self)
        case .stale_league_data_product_update: op = try container.decode(StaleLeagueDataProductUpdate.self)
        case .stale_league_create: op = try container.decode(StaleLeagueCreate.self)
        case .stale_league_update: op = try container.decode(StaleLeagueUpdate.self)
        case .data_transaction_create: op = try container.decode(DataTransactionCreate.self)
        case .data_transaction_update: op = try container.decode(DataTransactionUpdate.self)
        case .data_transaction_pay: op = try container.decode(DataTransactionPay.self)
        case .account_upgrade_data_transaction_member: op = try container.decode(AccountUpgradeDataTransactionMember.self)
        case .data_transaction_datasource_upload: op = try container.decode(DataTransactionDatasourceUpload.self)
        case .data_transaction_datasource_validate_error: op = try container.decode(DataTransactionDatasourceValidateError.self)
        case .data_market_category_create: op = try container.decode(DataMarketCategoryCreate.self)
        case .data_market_category_update: op = try container.decode(DataMarketCategoryUpdate.self)
        case .free_data_product_create: op = try container.decode(FreeDataProductCreate.self)
        case .free_data_product_update: op = try container.decode(FreeDataProductUpdate.self)
        case .league_data_product_create: op = try container.decode(LeagueDataProductCreate.self)
        case .league_data_product_update: op = try container.decode(LeagueDataProductUpdate.self)
        case .league_create: op = try container.decode(LeagueCreate.self)
        case .league_update: op = try container.decode(LeagueUpdate.self)
        case .datasource_copyright_clear: op = try container.decode(DatasourceCopyrightClear.self)
        case .data_transaction_complain: op = try container.decode(DataTransactionComplain.self)
        case .balance_lock: op = try container.decode(BalanceLock.self)
        case .balance_unlock: op = try container.decode(BalanceUnlock.self)
        case .proxy_transfer: op = try container.decode(ProxyTransfer.self)
        case .create_contract: op = try container.decode(CreateContract.self)
        case .call_contract: op = try container.decode(CallContract.self)
        case .update_contract: op = try container.decode(UpdateContract.self)
        case .trust_node_pledge_withdraw: op = try container.decode(TrustNodePledgeWithdraw.self)
        case .inline_transfer: op = try container.decode(InlineTransfer.self)
        case .inter_contract_call: op = try container.decode(InterContractCall.self)
        default: op = Unknown()
        }
        self.operation = op
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        /*
        switch self.operation {
        case let op as Transfer:
            try container.encode(OperationId.transfer)
            try container.encode(op)
        case let op as AccountCreate:
            try container.encode(OperationId.account_create)
            try container.encode(op)
        case let op as AccountUpdate:
            try container.encode(OperationId.account_update)
            try container.encode(op)
        case let op as ProxyTransfer:
            try container.encode(OperationId.proxy_transfer)
            try container.encode(op)
        case let op as CallContract:
            try container.encode(OperationId.call_contract)
            try container.encode(op)
        case let op as CreateContract:
            try container.encode(OperationId.create_contract)
            try container.encode(op)
        case let op as UpdateContract:
            try container.encode(OperationId.update_contract)
            try container.encode(op)
        default:
            throw EncodingError.invalidValue(self.operation, EncodingError.Context(
                codingPath: container.codingPath, debugDescription: "Encountered unknown operation type"))
        }
        */
        
        switch self.operation {
        case let op as Transfer:
            try container.encode(OperationId.transfer)
            try container.encode(op)
        case let op as LimitOrderCreate:
            try container.encode(OperationId.limit_order_create)
            try container.encode(op)
        case let op as LimitOrderCancel:
            try container.encode(OperationId.limit_order_cancel)
            try container.encode(op)
            
        case let op as CallOrderUpdate:
            try container.encode(OperationId.call_order_update)
            try container.encode(op)
        case let op as FillOrder:
            try container.encode(OperationId.fill_order)
            try container.encode(op)
            
        case let op as AccountCreate:
            try container.encode(OperationId.account_create)
            try container.encode(op)
        case let op as AccountUpdate:
            try container.encode(OperationId.account_update)
            try container.encode(op)
            
            
        case let op as AccountWhitelist:
            try container.encode(OperationId.account_whitelist)
            try container.encode(op)
        case let op as AccountUpgrade:
            try container.encode(OperationId.account_upgrade)
            try container.encode(op)
        case let op as AccountTransfer:
            try container.encode(OperationId.account_transfer)
            try container.encode(op)
        case let op as AssetCreate:
            try container.encode(OperationId.asset_create)
            try container.encode(op)
        case let op as AssetUpdate:
            try container.encode(OperationId.asset_update)
            try container.encode(op)
        case let op as AssetUpdateBitasset:
            try container.encode(OperationId.asset_update_bitasset)
            try container.encode(op)
        case let op as AssetUpdateFeedProducers:
            try container.encode(OperationId.asset_update_feed_producers)
            try container.encode(op)
        case let op as AssetIssue:
            try container.encode(OperationId.asset_issue)
            try container.encode(op)
        case let op as AssetReserve:
            try container.encode(OperationId.asset_reserve)
            try container.encode(op)
        case let op as AssetFundFeePool:
            try container.encode(OperationId.asset_fund_fee_pool)
            try container.encode(op)
            
        case let op as AssetSettle:
            try container.encode(OperationId.asset_settle)
            try container.encode(op)
        case let op as AssetGlobalSettle:
            try container.encode(OperationId.asset_global_settle)
            try container.encode(op)
        case let op as AssetPublishFeed:
            try container.encode(OperationId.asset_publish_feed)
            try container.encode(op)
        case let op as WitnessCreate:
            try container.encode(OperationId.witness_create)
            try container.encode(op)
        case let op as WitnessUpdate:
            try container.encode(OperationId.witness_update)
            try container.encode(op)
        case let op as ProposalCreate:
            try container.encode(OperationId.proposal_create)
            try container.encode(op)
        case let op as ProposalUpdate:
            try container.encode(OperationId.proposal_update)
            try container.encode(op)
        case let op as ProposalDelete:
            try container.encode(OperationId.proposal_delete)
            try container.encode(op)
        case let op as WithdrawPermissionCreate:
            try container.encode(OperationId.withdraw_permission_create)
            try container.encode(op)
        case let op as WithdrawPermissionUpdate:
            try container.encode(OperationId.withdraw_permission_update)
            try container.encode(op)
            
        case let op as WithdrawPermissionClaim:
            try container.encode(OperationId.withdraw_permission_claim)
            try container.encode(op)
        case let op as WithdrawPermissionDelete:
            try container.encode(OperationId.withdraw_permission_delete)
            try container.encode(op)
        case let op as CommitteeMemberCreate:
            try container.encode(OperationId.committee_member_create)
            try container.encode(op)
        case let op as CommitteeMemberUpdate:
            try container.encode(OperationId.committee_member_update)
            try container.encode(op)
        case let op as CommitteeMemberUpdateGlobalParameters:
            try container.encode(OperationId.committee_member_update_global_parameters)
            try container.encode(op)
        case let op as VestingBalanceCreate:
            try container.encode(OperationId.vesting_balance_create)
            try container.encode(op)
        case let op as VestingBalanceWithdraw:
            try container.encode(OperationId.vesting_balance_withdraw)
            try container.encode(op)
        case let op as WorkerCreate:
            try container.encode(OperationId.worker_create)
            try container.encode(op)
        case let op as Custom:
            try container.encode(OperationId.custom)
            try container.encode(op)
        case let op as Assert:
            try container.encode(OperationId.assert)
            try container.encode(op)
            
        case let op as BalanceClaim:
            try container.encode(OperationId.balance_claim)
            try container.encode(op)
        case let op as OverrideTransfer:
            try container.encode(OperationId.override_transfer)
            try container.encode(op)
        case let op as TransferToBlind:
            try container.encode(OperationId.transfer_to_blind)
            try container.encode(op)
        case let op as BlindTransfer:
            try container.encode(OperationId.blind_transfer)
            try container.encode(op)
        case let op as TransferFromBlind:
            try container.encode(OperationId.transfer_from_blind)
            try container.encode(op)
        case let op as AssetSettleCancel:
            try container.encode(OperationId.asset_settle_cancel)
            try container.encode(op)
        case let op as AssetClaimFees:
            try container.encode(OperationId.asset_claim_fees)
            try container.encode(op)
        case let op as FbaDistribute:
            try container.encode(OperationId.fba_distribute)
            try container.encode(op)
        case let op as AccountUpgradeMerchant:
            try container.encode(OperationId.account_upgrade_merchant)
            try container.encode(op)
        case let op as AccountUpgradeDatasource:
            try container.encode(OperationId.account_upgrade_datasource)
            try container.encode(op)
            
        case let op as StaleDataMarketCategoryCreate:
            try container.encode(OperationId.stale_data_market_category_create)
            try container.encode(op)
        case let op as StaleDataMarketCategoryUpdate:
            try container.encode(OperationId.stale_data_market_category_update)
            try container.encode(op)
        case let op as StaleFreeDataProductCreate:
            try container.encode(OperationId.stale_free_data_product_create)
            try container.encode(op)
        case let op as StaleFreeDataProductUpdate:
            try container.encode(OperationId.stale_free_data_product_update)
            try container.encode(op)
        case let op as StaleLeagueDataProductCreate:
            try container.encode(OperationId.stale_league_data_product_create)
            try container.encode(op)
        case let op as StaleLeagueDataProductUpdate:
            try container.encode(OperationId.stale_league_data_product_update)
            try container.encode(op)
        case let op as StaleLeagueCreate:
            try container.encode(OperationId.stale_league_create)
            try container.encode(op)
        case let op as StaleLeagueUpdate:
            try container.encode(OperationId.stale_league_update)
            try container.encode(op)
        case let op as DataTransactionCreate:
            try container.encode(OperationId.data_transaction_create)
            try container.encode(op)
        case let op as DataTransactionUpdate:
            try container.encode(OperationId.data_transaction_update)
            try container.encode(op)
            
        case let op as DataTransactionPay:
            try container.encode(OperationId.data_transaction_pay)
            try container.encode(op)
        case let op as AccountUpgradeDataTransactionMember:
            try container.encode(OperationId.account_upgrade_data_transaction_member)
            try container.encode(op)
        case let op as DataTransactionDatasourceUpload:
            try container.encode(OperationId.data_transaction_datasource_upload)
            try container.encode(op)
        case let op as DataTransactionDatasourceValidateError:
            try container.encode(OperationId.data_transaction_datasource_validate_error)
            try container.encode(op)
        case let op as DataMarketCategoryCreate:
            try container.encode(OperationId.data_market_category_create)
            try container.encode(op)
        case let op as DataMarketCategoryUpdate:
            try container.encode(OperationId.data_market_category_update)
            try container.encode(op)
        case let op as FreeDataProductCreate:
            try container.encode(OperationId.free_data_product_create)
            try container.encode(op)
        case let op as FreeDataProductUpdate:
            try container.encode(OperationId.free_data_product_update)
            try container.encode(op)
        case let op as LeagueDataProductCreate:
            try container.encode(OperationId.league_data_product_create)
            try container.encode(op)
        case let op as LeagueDataProductUpdate:
            try container.encode(OperationId.league_data_product_update)
            try container.encode(op)
            
        case let op as LeagueCreate:
            try container.encode(OperationId.league_create)
            try container.encode(op)
        case let op as LeagueUpdate:
            try container.encode(OperationId.league_update)
            try container.encode(op)
        case let op as DatasourceCopyrightClear:
            try container.encode(OperationId.datasource_copyright_clear)
            try container.encode(op)
        case let op as DataTransactionComplain:
            try container.encode(OperationId.data_transaction_complain)
            try container.encode(op)
        case let op as BalanceLock:
            try container.encode(OperationId.balance_lock)
            try container.encode(op)
        case let op as BalanceUnlock:
            try container.encode(OperationId.balance_unlock)
            try container.encode(op)
        case let op as ProxyTransfer:
            try container.encode(OperationId.proxy_transfer)
            try container.encode(op)
        case let op as CreateContract:
            try container.encode(OperationId.create_contract)
            try container.encode(op)
        case let op as CallContract:
            try container.encode(OperationId.call_contract)
            try container.encode(op)
        case let op as UpdateContract:
            try container.encode(OperationId.update_contract)
            try container.encode(op)
            
        case let op as TrustNodePledgeWithdraw:
            try container.encode(OperationId.trust_node_pledge_withdraw)
            try container.encode(op)
        case let op as InlineTransfer:
            try container.encode(OperationId.inline_transfer)
            try container.encode(op)
        case let op as InterContractCall:
            try container.encode(OperationId.inter_contract_call)
            try container.encode(op)
        default:
            throw EncodingError.invalidValue(self.operation, EncodingError.Context(
                codingPath: container.codingPath, debugDescription: "Encountered unknown operation type"))
        }
    }
}


