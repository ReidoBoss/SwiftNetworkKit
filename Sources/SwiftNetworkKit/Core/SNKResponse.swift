//
//  SNKResponse.swift
//  SwiftNetworkKit
//
//  Created by Stephen T. Sagarino Jr. on 10/3/25.
//

import Foundation

/// A generic response container that encapsulates the result of a network request.
///
/// `SNKResponse` provides a unified interface for handling network responses, whether they succeed or fail.
/// It contains the parsed response data, HTTP status information, and any errors that occurred during the request.
///
/// ## Usage Example
/// ```swift
/// let response: SNKResponse<User> = await SNK
///     .request(url: userURL)
///     .get(validateBodyAs: User.self)
///
/// if let user = response.data {
///     // Handle successful response
///     print("User: \(user.name)")
/// } else if let error = response.error {
///     // Handle error
///     print("Request failed: \(error)")
/// }
/// ```
///
/// ## Type Parameters
/// - `Result`: The expected type of the response data. This should conform to `Codable` when using automatic JSON parsing.
///
/// ## Thread Safety
/// This struct is marked as `@unchecked Sendable` to allow it to be passed between concurrent contexts.
/// The properties are immutable after initialization, making it safe to use across different threads.
///
/// - Since: SwiftNetworkKit 1.0
/// - Author: Stephen T. Sagarino Jr.
public struct SNKResponse<Result>: @unchecked Sendable {

    /// The parsed response data from the network request.
    ///
    /// This property contains the successfully parsed response body when the request completes successfully.
    /// It will be `nil` if the request failed, the response couldn't be parsed, or if there was no response body.
    ///
    /// ## Example
    /// ```swift
    /// let response = await SNK.request(url: apiURL).get(validateBodyAs: ApiResponse.self)
    /// if let data = response.data {
    ///     // Use the parsed response data
    ///     processApiResponse(data)
    /// }
    /// ```
    public let data: Result?

    /// The HTTP status information from the response.
    ///
    /// Contains the HTTP status code and related information when available.
    /// This will be `nil` if the request failed before receiving a response (e.g., network connectivity issues).
    ///
    /// ## Common Status Codes
    /// - `200`: Success
    /// - `201`: Created
    /// - `400`: Bad Request
    /// - `401`: Unauthorized
    /// - `404`: Not Found
    /// - `500`: Internal Server Error
    ///
    /// ## Example
    /// ```swift
    /// let response = await SNK.request(url: apiURL).get(validateBodyAs: String.self)
    /// if let status = response.status {
    ///     print("HTTP Status: \(status.code)")
    ///     if status.isSuccessful {
    ///         // Handle success
    ///     }
    /// }
    /// ```
    public let status: (any HTTPStatus)?

    /// The error that occurred during the network request, if any.
    ///
    /// This property contains error information when the request fails at any stage:
    /// - Network connectivity issues
    /// - Invalid URLs
    /// - HTTP errors (4xx, 5xx status codes)
    /// - JSON parsing failures
    /// - Timeout errors
    ///
    /// It will be `nil` when the request completes successfully.
    ///
    /// ## Error Types
    /// Common error types you might encounter:
    /// - `URLError`: Network-related errors (no internet, timeout, etc.)
    /// - `DecodingError`: JSON parsing failures
    /// - `SNKError`: Custom SwiftNetworkKit errors
    ///
    /// ## Example
    /// ```swift
    /// let response = await SNK.request(url: invalidURL).get(validateBodyAs: Data.self)
    /// if let error = response.error {
    ///     switch error {
    ///     case let urlError as URLError:
    ///         print("Network error: \(urlError.localizedDescription)")
    ///     case let decodingError as DecodingError:
    ///         print("Parsing error: \(decodingError.localizedDescription)")
    ///     default:
    ///         print("Unknown error: \(error.localizedDescription)")
    ///     }
    /// }
    /// ```
    public let error: (any Error)?
}

// MARK: - Convenience Properties

extension SNKResponse {
    /// Indicates whether the request was successful.
    ///
    /// A request is considered successful when:
    /// - `data` is not `nil`
    /// - `error` is `nil`
    /// - HTTP status code is in the success range (200-299)
    ///
    /// ## Example
    /// ```swift
    /// let response = await SNK.request(url: apiURL).get(validateBodyAs: User.self)
    /// if response.isSuccessful {
    ///     // Process successful response
    ///     handleUser(response.data!)
    /// }
    /// ```
    public var isSuccessful: Bool {
        return data != nil && error == nil
            && ((status?.asSuccess() != nil) ?? false)
    }

    /// The HTTP status code from the response.
    ///
    /// Returns the status code as an integer, or `nil` if no status is available.
    ///
    /// ## Example
    /// ```swift
    /// let response = await SNK.request(url: apiURL).get(validateBodyAs: Data.self)
    /// switch response.statusCode {
    /// case 200:
    ///     print("Success!")
    /// case 404:
    ///     print("Resource not found")
    /// case 500...599:
    ///     print("Server error")
    /// default:
    ///     print("Other status: \(response.statusCode ?? -1)")
    /// }
    /// ```
    public var statusCode: Int? {
        return status?.code
    }
}
