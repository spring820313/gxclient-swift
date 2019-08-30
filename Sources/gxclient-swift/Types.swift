//
//  Types.swift
//  gxclient-swift
//
//  Created by xgc on 2019/7/18.
//

import Foundation

public enum AccountCreateExtensionsType: UInt8, Equatable {

    case NullExt = 0, OwnerSpecial, ActiveSpecial, Buyback
    
}

public enum SpecialAuthorityType: UInt8, Equatable {
    
    case NoSpecial = 0, TopHolders
    
}

public enum PredicateType: UInt8, Equatable {
    
    case AccountNameEqLit = 0, AssetSymbolEqLit, BlockId
    
}

public enum WorkerInitializerType: UInt8, Equatable {
    
    case Refund = 0, VestingBalance, Burn
    
}

public enum VestingPolicyType: UInt8, Equatable {
    
    case CCD = 0, Linear
    
}

public enum FeeParametersType: UInt8, Equatable {
    
    case TransferOperation = 0
    
}
