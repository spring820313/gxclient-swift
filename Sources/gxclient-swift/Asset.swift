
import Foundation


public struct Asset: Equatable {
    internal let id: GrapheneId
    /// The asset symbol.
    internal let symbol: String

    internal let precision: UInt8
    internal let issuer: String


    public init(_ id: GrapheneId, _ symbol: String, _ precision: UInt8, _ issuer: String, _ dynamicAssetDataID: String) {
        self.id = id
        self.symbol = symbol
        self.precision = precision
        self.issuer = issuer
    }
}



extension Asset: GxcEncodable, Decodable {
    fileprivate enum Key: CodingKey {
        case id
        case symbol
        case precision
        case issuer
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        self.id = try container.decode(GrapheneId.self, forKey: .id)
        self.symbol = try container.decode(String.self, forKey: .symbol)
        self.precision = try container.decode(UInt8.self, forKey: .precision)
        self.issuer = try container.decode(String.self, forKey: .issuer)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.symbol, forKey: .symbol)
        try container.encode(self.precision, forKey: .precision)
        try container.encode(self.issuer, forKey: .issuer)
    }

    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.id)
        try encoder.encode(self.symbol)
        try encoder.encode(self.precision)
        try encoder.encode(self.issuer)
    }
}
