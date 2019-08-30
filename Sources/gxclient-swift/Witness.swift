//
//  Witness.swift
//  gxclient-swift
//
//  Created by xgc on 2019/7/30.
//

import Foundation

public struct Witness: GxcCodable, Equatable {
    public var id:String
    public var isValid:Bool
    public var lastAslot:UInt64
    public var lastConfirmedBlockNum: Int64
    public var signingKey: String
    public var totalMissed:Int64
    public var totalVotes:Int64
    public var url:String
    public var voteId:String
    public var witnessAccount:String
}
