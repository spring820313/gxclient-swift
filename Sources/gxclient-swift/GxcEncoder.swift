/// Steem protocol encoding.
/// - Author: Johan Nordberg <johan@steemit.com>

import Foundation
import OrderedDictionary

/// A type that can be encoded into Steem binary wire format.
public protocol GxcEncodable: Encodable {
    /// Encode self into Steem binary format.
    func binaryEncode(to encoder: GxcEncoder) throws
}

/// Default implementation which calls through to `Encodable`.
public extension GxcEncodable {
    func binaryEncode(to encoder: GxcEncoder) throws {
        try self.encode(to: encoder)
    }
}

/// Encodes data into Steem binary format.
public class GxcEncoder {
    /// All errors which `SteemEncoder` can throw.
    public enum Error: Swift.Error {
        /// Thrown if encoder encounters a type that is not conforming to `GxcEncodable`.
        case typeNotConformingToSteemEncodable(Encodable.Type)
        /// Thrown if encoder encounters a type that is not confirming to `Encodable`.
        case typeNotConformingToEncodable(Any.Type)
    }

    /// Data buffer holding the encoded bytes.
    /// - Note: Implementers of `SteemEncodable` can write directly into this.
    public var data = Data()

    /// Create a new encoder.
    public init() {}

    /// Convenience for creating an encoder, encoding a value and returning the data.
    public static func encode(_ value: GxcEncodable) throws -> Data {
        let encoder = GxcEncoder()
        try value.binaryEncode(to: encoder)
        return encoder.data
    }

    /// Encodes any `SteemEncodable`.
    /// - Note: Platform specific integer types `Int` and `UInt` are encoded as varints.
    public func encode(_ value: Encodable) throws {
        switch value {
        case let v as Int:
            self.appendVarint(UInt64(v))
        case let v as UInt:
            self.appendVarint(UInt64(v))
        case let v as Array<GxcEncodable>:
            self.appendVarint(UInt64(v.count))
            for i in v {
                try i.binaryEncode(to: self)
            }
            break
        case let v as GxcEncodable:
            try v.binaryEncode(to: self)
        default:
            throw Error.typeNotConformingToSteemEncodable(type(of: value))
        }
    }

    /// Append variable integer to encoder buffer.
    func appendVarint(_ value: UInt64) {
        var v = value
        while v > 127 {
            self.data.append(UInt8(v & 0x7F | 0x80))
            v >>= 7
        }
        self.data.append(UInt8(v))
    }

    /// Append the raw bytes of the parameter to the encoder's data.
    func appendBytes<T>(of value: T) {
        var v = value
        withUnsafeBytes(of: &v) {
            data.append(contentsOf: $0)
        }
    }
}

// Encoder conformance.
// Based on Mike Ash's BinaryEncoder
// https://github.com/mikeash/BinaryCoder
extension GxcEncoder: Encoder {
    public var codingPath: [CodingKey] { return [] }

    public var userInfo: [CodingUserInfoKey: Any] { return [:] }

    public func container<Key>(keyedBy _: Key.Type) -> KeyedEncodingContainer<Key> where Key: CodingKey {
        return KeyedEncodingContainer(KeyedContainer<Key>(encoder: self))
    }

    public func unkeyedContainer() -> UnkeyedEncodingContainer {
        return UnkeyedContanier(encoder: self)
    }

    public func singleValueContainer() -> SingleValueEncodingContainer {
        return UnkeyedContanier(encoder: self)
    }

    private struct KeyedContainer<Key: CodingKey>: KeyedEncodingContainerProtocol {
        var encoder: GxcEncoder

        var codingPath: [CodingKey] { return [] }

        func encode<T>(_ value: T, forKey _: Key) throws where T: Encodable {
            try self.encoder.encode(value)
        }

        func encodeNil(forKey _: Key) throws {}

        func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey _: Key) -> KeyedEncodingContainer<NestedKey> where NestedKey: CodingKey {
            return self.encoder.container(keyedBy: keyType)
        }

        func nestedUnkeyedContainer(forKey _: Key) -> UnkeyedEncodingContainer {
            return self.encoder.unkeyedContainer()
        }

        func superEncoder() -> Encoder {
            return self.encoder
        }

        func superEncoder(forKey _: Key) -> Encoder {
            return self.encoder
        }
    }

    private struct UnkeyedContanier: UnkeyedEncodingContainer, SingleValueEncodingContainer {
        var encoder: GxcEncoder

        var codingPath: [CodingKey] { return [] }

        var count: Int { return 0 }

        func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> where NestedKey: CodingKey {
            return self.encoder.container(keyedBy: keyType)
        }

        func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
            return self
        }

        func superEncoder() -> Encoder {
            return self.encoder
        }

        func encodeNil() throws {}

        func encode<T>(_ value: T) throws where T: Encodable {
            try self.encoder.encode(value)
        }
    }
}

// MARK: - Default type extensions

extension FixedWidthInteger where Self: GxcEncodable {
    public func binaryEncode(to encoder: GxcEncoder) {
        encoder.appendBytes(of: self.littleEndian)
    }
}

extension Int8: GxcEncodable {}
extension UInt8: GxcEncodable {}
extension Int16: GxcEncodable {}
extension UInt16: GxcEncodable {}
extension Int32: GxcEncodable {}
extension UInt32: GxcEncodable {}
extension Int64: GxcEncodable {}
extension UInt64: GxcEncodable {}

extension String: GxcEncodable {
    public func binaryEncode(to encoder: GxcEncoder) {
        encoder.appendVarint(UInt64(self.utf8.count))
        encoder.data.append(contentsOf: self.utf8)
    }
}

extension Array: GxcEncodable where Element: Encodable {
    public func binaryEncode(to encoder: GxcEncoder) throws {
        encoder.appendVarint(UInt64(self.count))
        for item in self {
            try encoder.encode(item)
        }
    }
}

extension OrderedDictionary: GxcEncodable where Key: GxcEncodable, Value: GxcEncodable {
    public func binaryEncode(to encoder: GxcEncoder) throws {
        encoder.appendVarint(UInt64(self.count))
        for (key, value) in self {
            try encoder.encode(key)
            try encoder.encode(value)
        }
    }
}

extension Date: GxcEncodable {
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(UInt32(self.timeIntervalSince1970))
    }
}

extension Data: GxcEncodable {
    public func binaryEncode(to encoder: GxcEncoder) {
        encoder.data.append(self)
    }
}

extension Bool: GxcEncodable {
    public func binaryEncode(to encoder: GxcEncoder) {
        encoder.data.append(self ? 1 : 0)
    }
}

extension Optional: GxcEncodable where Wrapped: GxcEncodable {
    public func binaryEncode(to encoder: GxcEncoder) throws {
        if let value = self {
            encoder.data.append(1)
            try encoder.encode(value)
        } else {
            encoder.data.append(0)
        }
    }
}
