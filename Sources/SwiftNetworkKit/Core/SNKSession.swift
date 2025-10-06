//
//  SNKSession.swift
//  SwiftNetworkKit
//
//  Created by Stephen T. Sagarino Jr. on 10/2/25.
//

import Foundation

/// A session manager that provides a centralized interface for creating network requests.
///
/// `SNKSession` manages the underlying `URLSession` and provides factory methods for creating
/// `SNKDataRequest` instances. It supports custom session configurations, optional base URLs,
/// and provides both URL and string-based request creation methods.
///
/// ## Usage Example
/// ```swift
/// // Using default session
/// let session = SNKSession()
/// let request = try session.request(urlString: "https://api.example.com/users")
///
/// // Using base URL for convenience
/// let apiSession = SNKSession(baseURL: "https://api.example.com")
/// let request = try apiSession.request(path: "/users") // resolves to https://api.example.com/users
/// ```
///
/// - Since: SwiftNetworkKit 1.0
/// - Author: Stephen T. Sagarino Jr.
open class SNKSession: @unchecked Sendable {

    /// The shared singleton instance of `SNKSession`.
    /// use `SNK` to get default implementation
    static internal let `default` = SNKSession(urlSession: .shared)

    /// The URLSession instance used for network requests.
    ///
    /// This session is used by all requests created through this `SNKSession` instance.
    /// You can provide a custom session during initialization to control timeout values,
    /// caching policies, and other networking behaviors.
    ///
    /// - Note: Defaults to `URLSession.shared` if not specified during initialization.
    public private(set) var urlSession: URLSession

    /// The base URL used for relative path requests.
    ///
    /// When set, this URL is used as the foundation for requests created with `request(path:)`.
    /// If `nil`, only absolute URLs can be used with `request(url:)` and `request(urlString:)`.
    ///
    /// ## Example
    /// ```swift
    /// let session = SNKSession(baseURL: "https://api.example.com")
    /// // Now you can use relative paths:
    /// let request = try session.request(path: "/users/123")
    /// ```
    public private(set) var baseURL: URL?

    /// Creates a new SNKSession instance.
    ///
    /// - Parameters:
    ///   - urlSession: The URLSession to use for network requests. Defaults to `URLSession.shared`.
    ///   - baseURL: Optional base URL for relative path requests. Defaults to `nil`.
    ///
    /// ## Example
    /// ```swift
    /// // Default session
    /// let session = SNKSession()
    ///
    /// // With base URL
    /// let session = SNKSession(baseURL: "https://api.example.com")
    ///
    /// // Custom session with timeout and base URL
    /// let config = URLSessionConfiguration.default
    /// config.timeoutIntervalForRequest = 60
    /// let session = SNKSession(
    ///     urlSession: URLSession(configuration: config),
    ///     baseURL: "https://api.example.com"
    /// )
    /// ```
    internal init(
        urlSession: URLSession = .shared
    ) {
        self.urlSession = urlSession
        self.baseURL = nil
    }

    /// Creates a new SNKSession instance with a URL-based base URL.
    ///
    /// - Parameters:
    ///   - urlSession: The URLSession to use for network requests. Defaults to `URLSession.shared`.
    ///   - baseURL: Optional base URL for relative path requests.
    public init(urlSession: URLSession = .shared, baseURL: URL? = nil) {
        self.urlSession = urlSession
        self.baseURL = baseURL
    }

    /// Creates a new data request for the specified URL.
    ///
    /// - Parameter url: The URL for the request.
    /// - Returns: A new `SNKDataRequest` instance configured with this session.
    ///
    /// ## Example
    /// ```swift
    /// let url = URL(string: "https://api.example.com/users")!
    /// let request = session.request(url: url)
    /// let response = await request.get(validateBodyAs: [User].self)
    /// ```
    public func request(url: URL) -> SNKDataRequest {
        return SNKDataRequest(url, urlSession: self.urlSession)
    }

    /// Creates a new data request for the specified URL string.
    ///
    /// - Parameter url: The URL string for the request.
    /// - Returns: A new `SNKDataRequest` instance configured with this session.
    /// - Throws: `SNKError.invalidURL` if the URL string is malformed.
    ///
    /// ## Example
    /// ```swift
    /// do {
    ///     let request = try session.request(urlString: "https://api.example.com/users")
    ///     let response = await request.get(validateBodyAs: [User].self)
    /// } catch {
    ///     print("Invalid URL: \(error)")
    /// }
    /// ```
    public func request(urlString url: String) throws -> SNKDataRequest {
        guard let validURL = URL(string: url) else {
            throw SNKError.invalidURL(url)
        }
        return request(url: validURL)
    }

    /// Creates a new data request for a relative path using the base URL.
    ///
    /// - Parameter path: The relative path to append to the base URL.
    /// - Returns: A new `SNKDataRequest` instance configured with this session.
    /// - Throws:
    ///   - `SNKError.missingBaseURL` if no base URL is configured.
    ///   - `SNKError.invalidURL` if the resulting URL is malformed.
    ///
    /// ## Example
    /// ```swift
    /// let session = SNKSession(baseURL: "https://api.example.com")
    ///
    /// do {
    ///     let request = try session.request(path: "/users") // https://api.example.com/users
    ///     let response = await request.get(validateBodyAs: [User].self)
    /// } catch {
    ///     print("Error creating request: \(error)")
    /// }
    /// ```
    ///
    /// - Note: The path should start with "/" for proper URL construction.
    public func request(path: String) throws -> SNKDataRequest {
        guard let baseURL = baseURL else {
            throw SNKError.missingBaseURL
        }

        guard let fullURL = URL(string: path, relativeTo: baseURL) else {
            throw SNKError.invalidURL(path)
        }

        return request(url: fullURL)
    }

    /// Updates the URLSession used by this session manager.
    ///
    /// - Parameter urlSession: The new URLSession to use for future requests.
    ///
    /// ## Example
    /// ```swift
    /// let newConfig = URLSessionConfiguration.default
    /// newConfig.timeoutIntervalForRequest = 120
    /// session.updateSession(URLSession(configuration: newConfig))
    /// ```
    ///
    /// - Warning: This will not affect requests that have already been created.
    public func updateSession(_ urlSession: URLSession) {
        self.urlSession = urlSession
    }

    /// Updates the base URL used for relative path requests.
    ///
    /// - Parameter baseURL: The new base URL, or `nil` to remove the base URL.
    /// - Throws: `SNKError.invalidURL` if the URL string is malformed.
    ///
    /// ## Example
    /// ```swift
    /// // Update to new base URL
    /// try session.updateBaseURL("https://api-v2.example.com")
    ///
    /// // Remove base URL
    /// session.updateBaseURL(nil)
    /// ```
    public func updateBaseURL(_ baseURL: String?) throws {
        if let baseURLString = baseURL {
            guard let url = URL(string: baseURLString) else {
                throw SNKError.invalidURL(baseURLString)
            }
            self.baseURL = url
        } else {
            self.baseURL = nil
        }
    }

    /// Updates the base URL used for relative path requests.
    ///
    /// - Parameter baseURL: The new base URL, or `nil` to remove the base URL.
    public func updateBaseURL(_ baseURL: URL?) {
        self.baseURL = baseURL
    }
}

// MARK: - Convenience Methods

extension SNKSession {
    /// Creates a new data request with common configuration for JSON APIs.
    ///
    /// This is a convenience method that creates a request pre-configured for JSON communication.
    ///
    /// - Parameter url: The URL for the request.
    /// - Returns: A new `SNKDataRequest` with JSON content type and accept headers set.
    ///
    /// ## Example
    /// ```swift
    /// let request = session.jsonRequest(url: apiURL)
    /// let response = await request.body(userData).post(validateBodyAs: ApiResponse.self)
    /// ```
    public func jsonRequest(url: URL) -> SNKDataRequest {
        return request(url: url)
            .jsonContentType()
            .addHeader("Accept", value: "application/json")
    }

    /// Creates a new data request with common configuration for JSON APIs using a URL string.
    ///
    /// - Parameter urlString: The URL string for the request.
    /// - Returns: A new `SNKDataRequest` with JSON content type and accept headers set.
    /// - Throws: `SNKError.invalidURL` if the URL string is malformed.
    public func jsonRequest(urlString: String) throws -> SNKDataRequest {
        let request = try self.request(urlString: urlString)
        return
            request
            .jsonContentType()
            .addHeader("Accept", value: "application/json")
    }

    /// Creates a new data request with common configuration for JSON APIs using a relative path.
    ///
    /// - Parameter path: The relative path to append to the base URL.
    /// - Returns: A new `SNKDataRequest` with JSON content type and accept headers set.
    /// - Throws:
    ///   - `SNKError.missingBaseURL` if no base URL is configured.
    ///   - `SNKError.invalidURL` if the resulting URL is malformed.
    public func jsonRequest(path: String) throws -> SNKDataRequest {
        let request = try self.request(path: path)
        return
            request
            .jsonContentType()
            .addHeader("Accept", value: "application/json")
    }
}
