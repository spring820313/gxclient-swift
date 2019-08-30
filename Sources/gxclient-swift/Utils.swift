//
//  Utils.swift
//  gxclient-swift
//
//  Created by xgc on 2019/7/29.
//

import Foundation


extension Data {
    
    var uint8: UInt8 {
        get {
            var number: UInt8 = 0
            self.copyBytes(to:&number, count: MemoryLayout<UInt8>.size)
            return number
        }
    }
    
    var uint16: UInt16 {
        get {
            let i16array = self.withUnsafeBytes {
                UnsafeBufferPointer<UInt16>(start: $0, count: self.count/2).map(UInt16.init(littleEndian:))
            }
            return i16array[0]
        }
    }
    
    var uint32: UInt32 {
        get {
            let i32array = self.withUnsafeBytes {
                UnsafeBufferPointer<UInt32>(start: $0, count: self.count/2).map(UInt32.init(littleEndian:))
            }
            return i32array[0]
        }
    }
    
    var uuid: NSUUID? {
        get {
            var bytes = [UInt8](repeating: 0, count: self.count)
            self.copyBytes(to:&bytes, count: self.count * MemoryLayout<UInt32>.size)
            return NSUUID(uuidBytes: bytes)
        }
    }
    var stringASCII: String? {
        get {
            return NSString(data: self, encoding: String.Encoding.ascii.rawValue) as String?
        }
    }
    
    var stringUTF8: String? {
        get {
            return NSString(data: self, encoding: String.Encoding.utf8.rawValue) as String?
        }
    }
    
    /*
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }
    
    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return map { String(format: format, $0) }.joined()
    }
    */
    
}

extension Int {
    var data: Data {
        var int = self
        return Data(bytes: &int, count: MemoryLayout<Int>.size)
    }
}

extension UInt8 {
    var data: Data {
        var int = self
        return Data(bytes: &int, count: MemoryLayout<UInt8>.size)
    }
}

extension UInt16 {
    var data: Data {
        var int = self
        return Data(bytes: &int, count: MemoryLayout<UInt16>.size)
    }
}

extension UInt32 {
    var data: Data {
        var int = self
        return Data(bytes: &int, count: MemoryLayout<UInt32>.size)
    }
    
    var byteArrayLittleEndian: [UInt8] {
        return [
            UInt8((self & 0xFF000000) >> 24),
            UInt8((self & 0x00FF0000) >> 16),
            UInt8((self & 0x0000FF00) >> 8),
            UInt8(self & 0x000000FF)
        ]
    }
}

extension String {
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }
    
    func toUint8() -> [UInt8] {
        return [UInt8](self.utf8)
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
}

public extension Date {
    
    public static func defaultTransactionExpiry() -> Date {
        return Date(timeIntervalSince1970: (Date().timeIntervalSince1970) + 120)
    }
}

extension Character {
    func toUInt8() -> UInt8 {
        return Array(String(self).utf8)[0]
    }
    
    func toString() -> String {
        return String(self)
    }
}

extension UInt8 {
    
    func toInt() -> Int {
        return Int.init(self)
    }
    
    static func toInt(array: [UInt8]) -> Int {
        let data = Data(bytes: array)
        return Int(bigEndian: data.withUnsafeBytes { $0.pointee })
    }
}

extension Int8 {
    
    func toInt() -> Int {
        return Int.init(self)
    }
    
    static func toInt(array: [Int8]) -> Int {
        let data = Data(bytes: array, count: MemoryLayout<Int8>.size)
        return Int(bigEndian: data.withUnsafeBytes { $0.pointee })
    }
}

extension Int {
    func toUInt8() -> UInt8 {
        return UInt8.init(self)
    }
    
    func toInt8() -> Int8 {
        return Int8.init(self)
    }
}

extension Data {
    
    func toArray<T>(type: T.Type) -> [T] {
        return self.withUnsafeBytes {
            [T](UnsafeBufferPointer(start: $0, count: self.count/MemoryLayout<T>.stride))
        }
    }
    
    func toUInt8Array() -> [UInt8] {
        return [UInt8](self)
    }
    
    func subdata(in range: ClosedRange<Index>) -> Data {
        return subdata(in: range.lowerBound ..< range.upperBound + 1)
    }
    
    enum Endianness {
        case BigEndian
        case LittleEndian
    }
    
    func scanValue<T: FixedWidthInteger>(at index: Data.Index, endianess: Endianness) -> T {
        let number: T = self.subdata(in: index..<index + MemoryLayout<T>.size).withUnsafeBytes({ $0.pointee })
        switch endianess {
        case .BigEndian:
            return number.bigEndian
        case .LittleEndian:
            return number.littleEndian
        }
    }
}

extension Array where Element:Hashable{
    var unique : [Element] {
        var keys:[Element:()] = [:]
        return filter{keys.updateValue((), forKey:$0) == nil}
    }
}

