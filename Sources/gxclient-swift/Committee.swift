//
//  Committee.swift
//  gxclient-swift
//
//  Created by xgc on 2019/7/30.
//

import Foundation

public struct Committee: GxcCodable, Equatable {
    public var id:String
    public var isValid:Bool
    public var totalVotes:Int64
    public var url:String
    public var voteId:String
}
