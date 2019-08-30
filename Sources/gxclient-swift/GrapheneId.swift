//
//  GrapheneId.swift
//  gxclient-swift
//
//  Created by xgc on 2019/7/17.
//

import Foundation

public struct GrapheneId: Equatable {

    internal let space: Int32
    internal let type: Int32
    internal let instance: Int32
    
    internal let id: String
    
    public init(_ space: Int32, _ type: Int32, _ instance: Int32) {
        self.space = space
        self.type = type
        self.instance = instance
        
        self.id = "\(space).\(type).\(instance)"
    }
    

    public init?(_ value: String) {
        let parts = value.split(separator: ".")
        guard parts.count == 3 else {
            return nil
        }
        
        guard let space = Int32(parts[0]) else {
            return nil
        }
        
        guard let type = Int32(parts[1]) else {
            return nil
        }
        
        guard let instance = Int32(parts[2]) else {
            return nil
        }
    
        self.init(space, type, instance)
    }
}

extension GrapheneId: LosslessStringConvertible {
    public var description: String {
        return self.id
    }
}

extension GrapheneId: GxcEncodable, Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        guard let grapheneId = GrapheneId(value) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Not a valid GrapheneId string")
        }
        self = grapheneId
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(String(self))
    }
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(UInt(self.instance))
    }
}
