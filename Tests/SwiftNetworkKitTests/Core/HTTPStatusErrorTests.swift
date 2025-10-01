import Foundation
import Testing

@testable import SwiftNetworkKit

@Test func testAllHTTPStatusErrorCases() async throws {
    for errorCase in HTTPStatusError.allCases {
        // Raw value should match the enum's raw value
        #expect(errorCase.rawValue == errorCase.code)
        // Description should be a non-empty string
        #expect(!errorCase.description.isEmpty)
        // Localized description should be a non-empty string
        #expect(!errorCase.localizedDescription.isEmpty)
        // Failure reason should be a non-empty string
        #expect(!errorCase.failureReason!.isEmpty)
    }
}

@Test func testHTTPStatusErrorDecoding() async throws {
    // Test decoding for a few representative cases
    let json = "400"
    let decoded = try JSONDecoder().decode(
        HTTPStatusError.self,
        from: json.data(using: .utf8)!
    )
    #expect(decoded == .badRequest)
}
