import Foundation

public protocol BaseFeeParameters:GxcCodable{
    
}

public struct TransferOperationFeeParameters: BaseFeeParameters {
    public var fee: UInt64
	public var pricePerKbyte: UInt32 
}

public struct LimitOrderCreateOperationFeeParameters: BaseFeeParameters {
    public var fee: UInt64
}

public struct LimitOrderCancelOperationFeeParameters: BaseFeeParameters {
    public var fee: UInt64
}

public struct CallOrderUpdateOperationFeeParameters: BaseFeeParameters {
    public var fee: UInt64
}

public struct FillOrderOperationFeeParameters: BaseFeeParameters {

}

public struct AccountCreateOperationFeeParameters: BaseFeeParameters {
    public var basicFee: UInt64
	public var premiumFee: UInt64 
	public var pricePerKbyte: UInt32
}

public struct AccountUpdateOperationFeeParameters: BaseFeeParameters {
    public var fee: UInt64
	public var pricePerKbyte: UInt32 
}

public struct AccountWhitelistOperationFeeParameters: BaseFeeParameters {
    public var fee: UInt64
}

public struct AccountUpgradeOperationFeeParameters: BaseFeeParameters {
    public var membershipAnnualFee: UInt64
	public var membershipLifetimeFee: UInt64 
}

public struct AccountTransferOperationFeeParameters: BaseFeeParameters {
    public var fee: UInt64
}

public struct AssetCreateOperationFeeParameters: BaseFeeParameters {
    public var symbol3: UInt64
	public var symbol4: UInt64 
	public var longSymbol: UInt64
	public var pricePerKbyte: UInt32
}

public struct AssetUpdateOperationFeeParameters: BaseFeeParameters {
    public var fee: UInt64
	public var pricePerKbyte: UInt32 
}

public struct AssetUpdateBitassetOperationFeeParameters: BaseFeeParameters {
    public var fee: UInt64
}

public struct AssetUpdateFeedProducersOperationFeeParameters: BaseFeeParameters {
    public var fee: UInt64
}

public struct AssetIssueOperationFeeParameters: BaseFeeParameters {
    public var fee: UInt64
	public var pricePerKbyte: UInt32 
}

public struct AssetReserveOperationFeeParameters: BaseFeeParameters {
    public var fee: UInt64
}

public struct AssetFundFeePoolOperationFeeParameters: BaseFeeParameters {
    public var fee: UInt64
}

public struct AssetSettleOperationFeeParameters: BaseFeeParameters {
    public var fee: UInt64
}

public struct AssetGlobalSettleOperationFeeParameters: BaseFeeParameters {
    public var fee: UInt64
}

public struct AssetPublishFeedOperationFeeParameters: BaseFeeParameters {
    public var fee: UInt64
}

public struct WitnessCreateOperationFeeParameters: BaseFeeParameters {
    public var fee: UInt64
}

public struct WitnessUpdateOperationFeeParameters: BaseFeeParameters {
    public var fee: UInt64
}

public struct ProposalCreateOperationFeeParameters: BaseFeeParameters {
    public var fee: UInt64
}

public struct ProposalUpdateOperationFeeParameters: BaseFeeParameters {
    public var fee: UInt64
}

public struct ProposalDeleteOperationFeeParameters: BaseFeeParameters {
    public var fee: UInt64
}

public struct WithdrawPermissionCreateOperationFeeParameters: BaseFeeParameters {
    public var fee: UInt64
}

public struct WithdrawPermissionUpdateOperationFeeParameters: BaseFeeParameters {
    public var fee: UInt64
}

public struct WithdrawPermissionClaimOperationFeeParameters: BaseFeeParameters {
    public var fee: UInt64
	public var pricePerKbyte: UInt32 
}

public struct WithdrawPermissionDeleteOperationFeeParameters: BaseFeeParameters {
    public var fee: UInt64
}

public struct CommitteeMemberCreateOperationFeeParameters: BaseFeeParameters {
    public var fee: UInt64
}

public struct CommitteeMemberUpdateOperationFeeParameters: BaseFeeParameters {
    public var fee: UInt64
}

public struct CommitteeMemberUpdateGlobalParametersOperationFeeParameters: BaseFeeParameters {
    public var fee: UInt64
}

public struct VestingBalanceCreateOperationFeeParameters: BaseFeeParameters {
    public var fee: UInt64
}

public struct VestingBalanceWithdrawOperationFeeParameters: BaseFeeParameters {
    public var fee: UInt64
}

public struct WorkerCreateOperationFeeParameters: BaseFeeParameters {
    public var fee: UInt64
}

public struct CustomOperationFeeParameters: BaseFeeParameters {
    public var fee: UInt64
}

public struct AssertOperationFeeParameters: BaseFeeParameters {
    public var fee: UInt64
}

public struct BalanceClaimOperationFeeParameters: BaseFeeParameters {

}

public struct OverrideTransferOperationFeeParameters: BaseFeeParameters {
    public var fee: UInt64
	public var pricePerKbyte: UInt32 
}

public struct TransferToBlindOperationFeeParameters: BaseFeeParameters {
    public var fee: UInt64
	public var pricePerKbyte: UInt32 
}

public struct BlindTransferOperationFeeParameters: BaseFeeParameters {
    public var fee: UInt64
	public var pricePerKbyte: UInt32 
}

public struct TransferFromBlindOperationFeeParameters: BaseFeeParameters {
    public var fee: UInt64
}

public struct AssetSettleCancelOperationFeeParameters: BaseFeeParameters {

}

public struct AssetClaimFeesOperationFeeParameters: BaseFeeParameters {
    public var fee: UInt64
}

public struct FeeParameters: GxcCodable {
    public var typ: FeeParametersType
	public var data: BaseFeeParameters
    
    public init(type: FeeParametersType,
				data: BaseFeeParameters
				) {
        self.typ = type
		self.data = data
    }
	
	 public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
  
        let typ = try FeeParametersType(rawValue: container.decode(UInt8.self))!
        let tmp: BaseFeeParameters
        switch typ {
        case .TransferOperation: tmp = try container.decode(TransferOperationFeeParameters.self)
        }
        self.typ = typ
		self.data = tmp
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(typ.rawValue)
        switch data {
        case let op as TransferOperationFeeParameters:
            try container.encode(op)
        default:
            throw EncodingError.invalidValue(data, EncodingError.Context(
                codingPath: container.codingPath, debugDescription: "Encountered unknown type"))
        }
    }
    
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(typ.rawValue)
        switch data {
        case let op as TransferOperationFeeParameters:
            try encoder.encode(op)
        default:
            throw GxcEncoder.Error.typeNotConformingToSteemEncodable(type(of: data))
        }
    }
    
}



