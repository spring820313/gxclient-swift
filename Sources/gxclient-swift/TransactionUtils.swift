//
//  TransactionUtils.swift
//  gxclient-swift
//
//  Created by xgc on 2019/7/29.
//

import Foundation

class TransactionUtils {
    class func refBlockNum(_ blockNumber: UInt32) -> UInt16{
        
        return UInt16(truncatingIfNeeded: blockNumber)
    }
    
    class func refBlockPrefix(_ blockID: String) -> UInt32{
        let bytes = Data(hex: blockID)
        let rawPrefix = bytes.subdata(in: 4..<8)
        return rawPrefix.uint32
    }
}
