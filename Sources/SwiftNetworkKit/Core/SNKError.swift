//
//  SNKError.swift
//  SwiftNetworkKit
//
//  Created by Stephen T. Sagarino Jr. on 10/3/25.
//

import Foundation

enum SNKError: Error {
    case noStatusCode
    case invalidURL(String)
    case invalidResponseType
    case missingBaseURL
}

extension SNKError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .noStatusCode:
            "The response did not contain a valid HTTP status code."
        case .invalidURL(let urlString):
            "The URL string provided is invalid: \(urlString)"
        case .invalidResponseType:
            "The response type is invalid or unsupported."
        case .missingBaseURL:
            "No base URL configured for relative path requests"
        }
    }
}
