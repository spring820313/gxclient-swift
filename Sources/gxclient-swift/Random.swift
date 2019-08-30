/// Cryptographically secure random number generation.
/// - Author: Johan Nordberg <johan@steemit.com>

import Foundation

#if !os(Linux)
    import Security
#else
    import Glibc
#endif

/// A cryptographically secure number random generator.
internal struct Random {
    /// Get random bytes.
    /// - Parameter count: How many bytes to generate.
    static func bytes(count: Int) -> Data {
        var rv = Data(count: count)
        #if os(Linux)
            guard let file = fopen("/dev/urandom", "r") else {
                fatalError("Unable to open /dev/urandom for reading.")
            }
            defer { fclose(file) }
            let bytesRead = rv.withUnsafeMutableBytes {
                fread($0, 1, count, file)
            }
            guard bytesRead == count else {
                fatalError("Unable to read from /dev/urandom.")
            }
        #else
            let result = rv.withUnsafeMutableBytes {
                SecRandomCopyBytes(kSecRandomDefault, count, $0)
            }
            guard result == errSecSuccess else {
                fatalError("Unable to generate random data.")
            }
        #endif
        return rv
    }
}

func arc4random<T:FixedWidthInteger>(_ type: T.Type) -> T {
    var r: T = 0
    arc4random_buf(&r,  MemoryLayout<T>.size)
    return r
}

extension UInt64 {
    static func random(lower: UInt64 = min, upper: UInt64 = max) -> UInt64 {
        var m: UInt64
        
        let u = upper - lower
        
        var r = arc4random(UInt64.self)
        
        if u > UInt64(Int64.max) {
            
            m = 1 + ~u
            
        } else{
            
            m = ((max - (u * 2)) + 1) % u
            
        }
        while r < m {
            
            r = arc4random(UInt64.self)
            
        }
        
        return (r % u) + lower
        
    }
}
