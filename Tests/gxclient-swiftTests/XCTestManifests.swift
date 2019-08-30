import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(gxclient_swiftTests.allTests),
    ]
}
#endif