//
//  HTTPStatusSuccessTests.swift
//  SwiftNetworkKit
//
//  Created by Stephen T. Sagarino Jr. on 10/1/25.
//

import Foundation
import Testing

@testable import SwiftNetworkKit

@Test func testAllHTTPStatusSuccessCases() async throws {
    for errorCase in HTTPStatusSuccess.allCases {
        // Raw value should match the enum's raw value
        #expect(errorCase.rawValue == errorCase.code)
        // Description should be a non-empty string
        #expect(!errorCase.description.isEmpty)
    }
}

@Test func testHTTPStatusSuccessDecoding() async throws {
    // Test decoding for a few representative cases
    let json = "200"
    let decoded = try JSONDecoder().decode(
        HTTPStatusSuccess.self,
        from: json.data(using: .utf8)!
    )
    #expect(decoded == .ok)
}
