//
//  HTTPStatus.swift
//  SwiftNetworkKit
//
//  Created by Stephen T. Sagarino Jr. on 10/1/25.
//

import Foundation

internal protocol HTTPStatus:
    Decodable,
    RawRepresentable<Int>,
    CaseIterable
{
    /// The status code in `Integer` of the HTTPStatus
    var code: Int { get }
    /// A human-readable description for each HTTP error status code.
    var description: String { get }

    /// Gets the corresponding HTTPStatus from an integer status code
    static func from(statusCode: Int) -> Self?
}

// MARK: computed variable helpers
extension HTTPStatus {
    var code: Int { return self.rawValue }
}

// MARK: static function helpers
extension HTTPStatus {

    /// the HTTPStatus of the `Int`
    /// returns `nil` if no match is found
    static func from(statusCode: Int) -> Self? {
        return Self.allCases.first { $0.rawValue == statusCode }
    }
}
// MARK: Typecast helper
extension HTTPStatus {

    func asSuccess() -> HTTPStatusSuccess? {
        return self as? HTTPStatusSuccess
    }

    func asError() -> HTTPStatusError? {
        return self as? HTTPStatusError
    }

}
