//
//  Vote.swift
//  gxclient-swift
//
//  Created by xgc on 2019/7/17.
//

import Foundation

public struct VoteId: Equatable, Hashable {
    
    internal let type: Int32
    internal let instance: Int32
    
    internal let id: String
    
    public init(_ type: Int32, _ instance: Int32) {
        self.type = type
        self.instance = instance
        
        self.id = "\(type):\(instance)"
    }
    
    
    public init?(_ value: String) {
        let parts = value.split(separator: ":")
        guard parts.count == 2 else {
            return nil
        }
        
        guard let type = Int32(parts[0]) else {
            return nil
        }
        
        guard let instance = Int32(parts[1]) else {
            return nil
        }
        
        self.init(type, instance)
    }
}

extension VoteId: LosslessStringConvertible {
    public var description: String {
        return self.id
    }
}

extension VoteId: GxcEncodable, Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        guard let voteId = VoteId(value) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Not a valid VoteId string")
        }
        self = voteId
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(String(self))
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        let bin = (self.type & 0xff) | (self.instance << 8)
        try encoder.encode(UInt32(bin))
    }
}


typealias VoteIds = Array<VoteId>

