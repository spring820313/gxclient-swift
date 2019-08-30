//
//  ChainParameters.swift
//  gxclient-swift
//
//  Created by xgc on 2019/7/30.
//

import Foundation

public struct ChainParameters: GxcCodable, Equatable {
    public var maximumCommitteeCount: UInt16
    public var maximumWitnessCount: UInt16
}

public struct ObjectParameters: GxcCodable, Equatable {
    public var id: GrapheneId
    public var parameters: ChainParameters
}
