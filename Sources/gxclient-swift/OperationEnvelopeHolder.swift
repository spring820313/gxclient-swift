import Foundation


public struct OperationEnvelopeHolder: GxcCodable {
    public var op: AnyOperation
    
    public init(op: AnyOperation) {
        self.op = op
    }
    
    
    public func binaryEncode(to encoder: GxcEncoder) throws {
        try encoder.encode(self.op)
    }
    
}
