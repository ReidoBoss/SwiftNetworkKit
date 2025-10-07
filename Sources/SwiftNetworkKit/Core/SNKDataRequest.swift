//
//  SNKDataRequest.swift
//  SwiftNetworkKit
//
//  Created by Stephen T. Sagarino Jr. on 10/2/25.
//

import Foundation

open class SNKDataRequest: @unchecked Sendable {

    /// the URLSession used to perform the request
    internal var urlSession: URLSession
    /// the URL used for the request
    internal var url: URL
    /// the headers of the request
    /// - default is `nil`
    /// - use the `headers(_:)` function to set
    internal var headers: [String: String]?
    /// the parameters of the request
    /// - default is `nil`
    /// - use the `queryParams(_:)` function to set
    internal var queryParams: [String: String]?
    /// the body of the request
    /// - default is `nil`
    /// - use the `body(_:)` function to set
    internal var body: Encodable?
    /// the decoder used to decode the response
    /// - default is `JSONDecoder()`
    /// - use the `decoder(_:)` function to set
    internal var decoder: JSONDecoder = JSONDecoder()
    /// the encoder used to encode the request body
    /// - Default:  `JSONEncoder()`
    /// - use the `encoder(_:)` function to set
    internal var encoder: JSONEncoder = JSONEncoder()
    /// The timeout interval for the request.
    /// - Default: `nil`, which uses the URLSession's default timeout.
    /// - Set using the `timeoutInterval(_:)` method.
    internal var timeoutInterval: TimeInterval?
    /// The cache policy for the request.
    /// - Default: `nil`, which uses the URLSession's default cache policy.
    /// - Set using the `cachePolicy(_:)` method.
    internal var cachePolicy: URLRequest.CachePolicy?
    /// The URLCredential for authentication.
    /// - Default: `nil`, which means no credential is used.
    /// - Set using the `credential(_:)` method.
    internal var credential: URLCredential?

    internal init(
        _ url: URL,
        urlSession: URLSession
    ) {
        self.url = url
        self.urlSession = urlSession
    }

    /// sets the URLCredential for authentication
    ///
    /// Use this method to provide credentials for HTTP Basic Auth.
    ///
    /// - Parameter credential: The `URLCredential` containing the username and password.
    /// - Returns: The same `SNKDataRequest` instance to enable method chaining.
    ///
    /// ## Example
    /// ```swift
    /// let credential = URLCredential(user: "username", password: "password", persistence: .forSession)
    /// let request = SNKDataRequest(url)
    ///    .urlCredential(credential)
    ///    .get()
    /// ```
    func urlCredential(_ credential: URLCredential) -> SNKDataRequest {
        self.credential = credential
        return self
    }

    /// Sets the cache policy for the request.
    ///
    /// Use this method to specify how the request should interact with the local cache.
    /// The cache policy determines whether the request should use cached data, ignore the cache,
    /// or fall back to the cache if the network is unavailable.
    ///
    /// - Parameter cachePolicy: The `URLRequest.CachePolicy` to use for this request.
    /// - Returns: The same `SNKDataRequest` instance to enable method chaining.
    ///
    /// ## Example
    /// ```swift
    /// let request = SNKDataRequest(url)
    ///     .cachePolicy(.reloadIgnoringLocalCacheData)
    ///     .get()
    /// ```
    ///
    /// - Note: If not set, the default cache policy of the underlying `URLSession` is used.
    public func cachePolicy(
        _ cachePolicy: URLRequest.CachePolicy
    ) -> SNKDataRequest {
        self.cachePolicy = cachePolicy
        return self
    }

    /// Sets the timeout interval for the request.
    ///
    /// Use this method to specify how long (in seconds) the request should wait before timing out.
    /// If not set, the default timeout interval of the underlying `URLSession` is used.
    ///
    /// - Parameter timeoutInterval: The timeout interval, in seconds.
    /// - Returns: The same `SNKDataRequest` instance to enable method chaining.
    ///
    /// ## Example
    /// ```swift
    /// let request = SNKDataRequest(url)
    ///     .timeoutInterval(30)
    ///     .get()
    /// ```
    public func timeoutInterval(
        _ timeoutInterval: TimeInterval
    ) -> SNKDataRequest {
        self.timeoutInterval = timeoutInterval
        return self
    }

    /// Sets the Content-Type for the request body.
    ///
    /// Use this method to specify the MIME type of the request body, such as `.json` or `.formURLEncoded`.
    /// The Content-Type header informs the server about the format of the data being sent.
    ///
    /// - Parameter contentType: The desired `ContentType` for the request body.
    /// - Returns: The same `SNKDataRequest` instance to allow method chaining.
    ///
    /// ## Example
    /// ```swift
    /// let request = SNKDataRequest(url)
    ///     .contentType(.json)
    ///     .post()
    /// ```
    public func contentType(
        _ contentType: SwiftNetworkKit.ContentType
    ) -> SNKDataRequest {
        self.addHeader("Content-Type", value: contentType.rawValue)
        return self
    }

    /// Executes an HTTP request and returns the raw response data without decoding.
    ///
    /// This internal method performs the actual HTTP request using URLSession and returns
    /// the raw `Data` response without any JSON decoding. It handles HTTP status validation
    /// and error handling, wrapping the result in an `SNKResponse<Data>`.
    ///
    /// - Parameter method: The HTTP method to use for the request (GET, POST, PUT, etc.)
    /// - Returns: An `SNKResponse<Data>` containing the raw response data, HTTP status, and any error that occurred
    ///
    /// ## Error Handling
    /// - Returns HTTP status errors in the response's `status` and `error` fields
    /// - Returns network or other errors in the response's `error` field with `nil` status
    /// - Always returns a valid `SNKResponse` object, never throws
    ///
    /// ## Usage
    /// This method is used internally by the public raw data request methods:
    /// ```swift
    /// public func get() async -> SNKResponse<Data> {
    ///     return await self.executeRaw(.get)
    /// }
    /// ```
    ///
    /// - Important: This method always sets `isNilable` to `false` during validation since raw data responses are expected to contain actual data.
    internal func executeRaw(_ method: HTTPMethod) async -> SNKResponse<Data> {
        do {
            let request = try self.request(method)
            let (data, response) = try await urlSession.data(for: request)

            let output = URLSession.DataTaskPublisher.Output(
                data: data,
                response: response
            )

            let validatedOutput = try self.validate(
                output: output,
                isNilable: false
            )

            return SNKResponse(
                data: validatedOutput.data,
                status: validatedOutput.status,
                error: nil
            )

        } catch let httpError as HTTPStatusError {
            return SNKResponse(data: nil, status: httpError, error: httpError)
        } catch {
            return SNKResponse(data: nil, status: nil, error: error)
        }
    }

    /// Executes an HTTP request with automatic JSON decoding of the response.
    ///
    /// This internal method performs the actual HTTP request using URLSession and attempts
    /// to decode the response JSON into the specified `Decodable` type. It handles HTTP status
    /// validation, JSON decoding, and comprehensive error handling.
    ///
    /// - Parameter method: The HTTP method to use for the request (GET, POST, PUT, etc.)
    /// - Parameter type: The `Decodable` type to decode the response JSON into
    /// - Returns: An `SNKResponse<ResultBody>` containing the decoded response data, HTTP status, and any error that occurred
    ///
    /// ## Decoding Behavior
    /// - Uses the configured `decoder` (defaults to `JSONDecoder()`) to parse the response
    /// - Handles nullable types by checking if `ResultBody` conforms to `ExpressibleByNilLiteral`
    /// - Returns `nil` data with success status when response is empty and type is nullable
    /// - Throws decoding errors if JSON structure doesn't match the expected type
    ///
    /// ## Error Handling
    /// - Returns HTTP status errors in the response's `status` and `error` fields
    /// - Returns JSON decoding errors in the response's `error` field
    /// - Returns network or other errors in the response's `error` field with `nil` status
    /// - Always returns a valid `SNKResponse` object, never throws
    ///
    /// ## Usage
    /// This method is used internally by the public typed request methods:
    /// ```swift
    /// public func get<ResultBody: Decodable>(
    ///     validateBodyAs type: ResultBody.Type
    /// ) async -> SNKResponse<ResultBody> {
    ///     return await self.execute(.get, validateOutputAs: type)
    /// }
    /// ```
    ///
    /// ## Example Response Types
    /// ```swift
    /// struct ApiResponse: Codable {
    ///     let message: String
    ///     let data: [String]
    /// }
    ///
    /// // This will decode the JSON response into ApiResponse
    /// let response = await execute(.get, validateOutputAs: ApiResponse.self)
    /// ```
    ///
    /// - Important: The response JSON structure must match the provided `Decodable` type, otherwise a decoding error will be returned.
    internal func execute<ResultBody: Decodable>(
        _ method: HTTPMethod,
        validateOutputAs type: ResultBody.Type
    ) async -> SNKResponse<ResultBody> {
        do {
            let request = try self.request(method)
            let (data, response) = try await urlSession.data(for: request)

            let output = URLSession.DataTaskPublisher.Output(
                data: data,
                response: response
            )
            let isNilable = ResultBody.self is ExpressibleByNilLiteral.Type
            let validatedOutput = try self.validate(
                output: output,
                isNilable: isNilable
            )
            guard let responseData = validatedOutput.data else {
                return SNKResponse(
                    data: nil,
                    status: validatedOutput.status,
                    error: validatedOutput.status?.asError()
                )
            }

            let decodedData = try self.decoder.decode(type, from: responseData)

            return SNKResponse(
                data: decodedData,
                status: validatedOutput.status,
                error: nil
            )

        } catch let httpError as HTTPStatusError {
            return SNKResponse(data: nil, status: httpError, error: httpError)
        } catch {
            return SNKResponse(
                data: nil,
                status: nil,
                error: error
            )
        }
    }
}

// MARK: - Data Requests
extension SNKDataRequest {

    /// Executes a PATCH request with automatic response decoding.
    ///
    /// This method performs an HTTP PATCH request and attempts to decode the response
    /// into the specified type. PATCH requests are used to apply partial modifications
    /// to a resource, typically updating only specific fields of an existing entity.
    ///
    /// - Parameter type: The type to decode the response body into. Must conform to `Decodable`
    /// - Returns: An `SNKResponse` containing the decoded response data, HTTP status, and any error that occurred
    ///
    /// ## Example
    /// ```swift
    /// struct UpdateResponse: Codable {
    ///     let id: Int
    ///     let updated: Bool
    ///     let modifiedFields: [String]
    /// }
    ///
    /// // Decode response as UpdateResponse
    /// let updateResponse = await request.patch(validateBodyAs: UpdateResponse.self)
    /// ```
    ///
    /// ## Usage with Request Body
    /// ```swift
    /// struct UserUpdate: Codable {
    ///     let name: String?
    ///     let email: String?
    /// }
    ///
    /// let updateData = UserUpdate(name: "New Name", email: nil)
    ///
    /// let response = await SNK.dataRequest(url)
    ///     .addHeader("Content-Type", value: "application/json")
    ///     .encoder(JSONEncoder())
    ///     .body(jsonData)
    ///     .patch(validateBodyAs: UpdateResponse.self)
    /// ```
    public func patch<ResultBody: Decodable>(
        validateBodyAs type: ResultBody.Type
    ) async -> SNKResponse<ResultBody> {
        return await self.execute(.patch, validateOutputAs: type)
    }

    /// Executes a POST request with automatic response decoding.
    ///
    /// This method performs an HTTP POST request and attempts to decode the response
    /// into the specified type. If no type is provided, the response will be returned as `Data`.
    ///
    /// - Parameter type: The type to decode the response body into. Must conform to `Decodable`. Defaults to `Data.self`
    /// - Returns: An `SNKResponse` containing the decoded response data, HTTP status, and any error that occurred
    ///
    /// ## Example
    /// ```swift
    /// struct User: Codable {
    ///     let id: Int
    ///     let name: String
    /// }
    ///
    /// // Decode response as User
    /// let userResponse = await request.post(validateBodyAs: User.self)
    ///
    /// ```
    public func post<ResultBody: Decodable>(
        validateBodyAs type: ResultBody.Type
    ) async -> SNKResponse<ResultBody> {
        return await self.execute(.post, validateOutputAs: type)
    }

    /// Executes a GET request with automatic response decoding.
    ///
    /// This method performs an HTTP GET request and attempts to decode the response
    /// into the specified type. If no type is provided, the response will be returned as `Data`.
    ///
    /// - Parameter type: The type to decode the response body into. Must conform to `Decodable`. Defaults to `Data.self`
    /// - Returns: An `SNKResponse` containing the decoded response data, HTTP status, and any error that occurred
    ///
    /// ## Example
    /// ```swift
    /// struct ApiResponse: Codable {
    ///     let message: String
    ///     let data: [String]
    /// }
    ///
    /// // Decode response as ApiResponse
    /// let apiResponse = await request.get(validateBodyAs: ApiResponse.self)
    ///
    /// ```
    public func get<ResultBody: Decodable>(
        validateBodyAs type: ResultBody.Type
    ) async -> SNKResponse<ResultBody> {
        return await self.execute(.get, validateOutputAs: type)
    }

    /// Executes a DELETE request with automatic response decoding.
    ///
    /// This method performs an HTTP DELETE request and attempts to decode the response
    /// into the specified type. If no type is provided, the response will be returned as `Data`.
    ///
    /// - Parameter type: The type to decode the response body into. Must conform to `Decodable`. Defaults to `Data.self`
    /// - Returns: An `SNKResponse` containing the decoded response data, HTTP status, and any error that occurred
    ///
    /// ## Example
    /// ```swift
    /// struct DeleteResponse: Codable {
    ///     let success: Bool
    ///     let message: String
    /// }
    ///
    /// // Decode response as DeleteResponse
    /// let deleteResponse = await request.delete(validateBodyAs: DeleteResponse.self)
    ///
    /// ```
    public func delete<ResultBody: Decodable>(
        validateBodyAs type: ResultBody.Type
    ) async -> SNKResponse<ResultBody> {
        return await self.execute(.delete, validateOutputAs: type)
    }

    /// Executes a HEAD request with automatic response decoding.
    ///
    /// This method performs an HTTP HEAD request and attempts to decode the response
    /// into the specified type. HEAD requests typically return only headers without a body.
    ///
    /// - Parameter type: The type to decode the response body into. Must conform to `Decodable`. Defaults to `Data.self`
    /// - Returns: An `SNKResponse` containing the decoded response data, HTTP status, and any error that occurred
    ///
    /// ## Example
    /// ```swift
    /// // Check if resource exists (HEAD typically returns no body)
    /// let headResponse = await request.head()
    /// ```
    public func head<ResultBody: Decodable>(
        validateBodyAs type: ResultBody.Type
    ) async -> SNKResponse<ResultBody> {
        return await self.execute(.head, validateOutputAs: type)
    }

    /// Executes an OPTIONS request with automatic response decoding.
    ///
    /// This method performs an HTTP OPTIONS request and attempts to decode the response
    /// into the specified type. OPTIONS requests are used to determine allowed methods for a resource.
    ///
    /// - Parameter type: The type to decode the response body into. Must conform to `Decodable`. Defaults to `Data.self`
    /// - Returns: An `SNKResponse` containing the decoded response data, HTTP status, and any error that occurred
    ///
    /// ## Example
    /// ```swift
    /// // Check allowed methods for a resource
    /// let optionsResponse = await request.options()
    /// ```
    public func options<ResultBody: Decodable>(
        validateBodyAs type: ResultBody.Type
    ) async -> SNKResponse<ResultBody> {
        return await self.execute(.options, validateOutputAs: type)
    }

    /// Executes a PUT request with automatic response decoding.
    ///
    /// This method performs an HTTP PUT request and attempts to decode the response
    /// into the specified type. If no type is provided, the response will be returned as `Data`.
    ///
    /// - Parameter type: The type to decode the response body into. Must conform to `Decodable`. Defaults to `Data.self`
    /// - Returns: An `SNKResponse` containing the decoded response data, HTTP status, and any error that occurred
    ///
    /// ## Example
    /// ```swift
    /// struct UpdateResponse: Codable {
    ///     let id: Int
    ///     let updated: Bool
    /// }
    ///
    /// // Decode response as UpdateResponse
    /// let updateResponse = await request.put(validateBodyAs: UpdateResponse.self)
    ///
    /// ```
    public func put<ResultBody: Decodable>(
        validateBodyAs type: ResultBody.Type
    ) async -> SNKResponse<ResultBody> {
        return await self.execute(.put, validateOutputAs: type)
    }

    /// Executes a TRACE request with automatic response decoding.
    ///
    /// This method performs an HTTP TRACE request and attempts to decode the response
    /// into the specified type. TRACE requests are used for diagnostic purposes.
    ///
    /// - Parameter type: The type to decode the response body into. Must conform to `Decodable`. Defaults to `Data.self`
    /// - Returns: An `SNKResponse` containing the decoded response data, HTTP status, and any error that occurred
    ///
    /// ## Example
    /// ```swift
    /// // Perform diagnostic trace
    /// let traceResponse = await request.trace()
    /// ```
    public func trace<ResultBody: Decodable>(
        validateBodyAs type: ResultBody.Type
    ) async -> SNKResponse<ResultBody> {
        return await self.execute(.trace, validateOutputAs: type)
    }
}

// MARK: - Raw Data Requests
extension SNKDataRequest {

    /// Executes a PATCH request returning raw `Data`.
    ///
    /// This method performs an HTTP PATCH request and returns the response as raw `Data`
    /// without attempting to decode it. Use this when you need access to the raw response
    /// or when you want to handle decoding manually. PATCH requests are used to apply
    /// partial modifications to a resource.
    ///
    /// - Returns: An `SNKResponse<Data>` containing the raw response data, HTTP status, and any error that occurred
    ///
    /// ## Example
    /// ```swift
    /// let response = await request.patch()
    /// if let data = response.data {
    ///     // Handle raw data manually
    ///     let json = try JSONSerialization.jsonObject(with: data)
    /// }
    /// ```
    ///
    /// ## Usage with Request Body
    /// ```swift
    /// let patchData = #"{"name": "Updated Name"}"#.data(using: .utf8)!
    ///
    /// let response = await SNK.dataRequest(url)
    ///     .addHeader("Content-Type", value: "application/json")
    ///     .body(patchData)
    ///     .patch()
    /// ```
    public func patch() async -> SNKResponse<Data> {
        return await self.executeRaw(.patch)
    }
    /// Executes a GET request returning raw `Data`.
    ///
    /// This method performs an HTTP GET request and returns the response as raw `Data`
    /// without attempting to decode it. Use this when you need access to the raw response
    /// or when you want to handle decoding manually.
    ///
    /// - Returns: An `SNKResponse<Data>` containing the raw response data, HTTP status, and any error that occurred
    ///
    /// ## Example
    /// ```swift
    /// let response = await request.get()
    /// if let data = response.data {
    ///     // Handle raw data manually
    ///     let string = String(data: data, encoding: .utf8)
    /// }
    /// ```
    public func get() async -> SNKResponse<Data> {
        return await self.executeRaw(.get)
    }

    /// Executes a POST request returning raw `Data`.
    ///
    /// This method performs an HTTP POST request and returns the response as raw `Data`
    /// without attempting to decode it. Use this when you need access to the raw response
    /// or when you want to handle decoding manually.
    ///
    /// - Returns: An `SNKResponse<Data>` containing the raw response data, HTTP status, and any error that occurred
    ///
    /// ## Example
    /// ```swift
    /// let response = await request.post()
    /// if let data = response.data {
    ///     // Handle raw data manually
    ///     let json = try JSONSerialization.jsonObject(with: data)
    /// }
    /// ```
    public func post() async -> SNKResponse<Data> {
        return await self.executeRaw(.post)
    }

    /// Executes a DELETE request returning raw `Data`.
    ///
    /// This method performs an HTTP DELETE request and returns the response as raw `Data`
    /// without attempting to decode it.
    ///
    /// - Returns: An `SNKResponse<Data>` containing the raw response data, HTTP status, and any error that occurred
    public func delete() async -> SNKResponse<Data> {
        return await self.executeRaw(.delete)
    }

    /// Executes a HEAD request returning raw `Data`.
    ///
    /// This method performs an HTTP HEAD request and returns the response as raw `Data`.
    /// HEAD requests typically return no body, only headers.
    ///
    /// - Returns: An `SNKResponse<Data>` containing the raw response data, HTTP status, and any error that occurred
    public func head() async -> SNKResponse<Data> {
        return await self.executeRaw(.head)
    }

    /// Executes an OPTIONS request returning raw `Data`.
    ///
    /// This method performs an HTTP OPTIONS request and returns the response as raw `Data`.
    /// OPTIONS requests are used to determine allowed methods for a resource.
    ///
    /// - Returns: An `SNKResponse<Data>` containing the raw response data, HTTP status, and any error that occurred
    public func options() async -> SNKResponse<Data> {
        return await self.executeRaw(.options)
    }

    /// Executes a PUT request returning raw `Data`.
    ///
    /// This method performs an HTTP PUT request and returns the response as raw `Data`
    /// without attempting to decode it.
    ///
    /// - Returns: An `SNKResponse<Data>` containing the raw response data, HTTP status, and any error that occurred
    public func put() async -> SNKResponse<Data> {
        return await self.executeRaw(.put)
    }

    /// Executes a TRACE request returning raw `Data`.
    ///
    /// This method performs an HTTP TRACE request and returns the response as raw `Data`.
    /// TRACE requests are used for diagnostic purposes.
    ///
    /// - Returns: An `SNKResponse<Data>` containing the raw response data, HTTP status, and any error that occurred
    public func trace() async -> SNKResponse<Data> {
        return await self.executeRaw(.trace)
    }
}

// MARK: - Setters
extension SNKDataRequest {

    /// Sets the encoder used to encode the request body.
    ///
    /// This method configures which encoder will be used to serialize the request body data.
    /// By default, `JSONEncoder()` is used. You can provide a custom encoder to handle
    /// specific encoding strategies, such as custom date formats or key strategies.
    ///
    /// - Parameter encoder: The `JSONEncoder` to use for encoding the request body.
    /// - Returns: The same `SNKDataRequest` instance to enable method chaining.
    ///
    /// ## Example
    /// ```swift
    /// let customEncoder = JSONEncoder()
    /// customEncoder.dateEncodingStrategy = .iso8601
    ///
    /// let request = SNKDataRequest(url)
    ///     .encoder(customEncoder)
    ///     .post()
    /// ```
    public func encoder(
        _ encoder: JSONEncoder
    ) -> SNKDataRequest {
        self.encoder = encoder
        return self
    }

    /// Sets the decoder used to parse the response data.
    ///
    /// This method configures which decoder will be used to transform the raw response data
    /// into the expected return type. The decoder must conform to `TopLevelDecoder`.
    /// If not specified, `JSONDecoder()` is used by default.
    ///
    /// - Parameter decoder: Any decoder conforming to `TopLevelDecoder` (e.g., `JSONDecoder`, `PropertyListDecoder`)
    /// - Returns: The same `SNKDataRequest` instance to enable method chaining
    ///
    /// ## Example
    /// ```swift
    /// let customDecoder = JSONDecoder()
    /// customDecoder.dateDecodingStrategy = .iso8601
    ///
    /// let request = SNKDataRequest()
    ///     .decoder(customDecoder)
    ///     .post()
    /// ```
    ///
    public func decoder(
        _ decoder: JSONDecoder
    ) -> SNKDataRequest {
        self.decoder = decoder
        return self
    }

    /// Sets the HTTP headers for this request.
    ///
    /// This method configures the headers that will be sent with the HTTP request.
    /// Headers are used to provide metadata about the request, such as content type,
    /// authorization tokens, or custom application-specific information.
    ///
    /// - Parameter headers: A dictionary of header field names and values to include in the request
    /// - Returns: The same `SNKDataRequest` instance to enable method chaining
    ///
    /// ## Example
    /// ```swift
    /// let request = SNKDataRequest(url)
    ///     .method(.post)
    ///     .headers([
    ///         "Content-Type": "application/json",
    ///         "Authorization": "Bearer \(token)",
    ///         "User-Agent": "MyApp/1.0"
    ///     ])
    /// ```
    ///
    /// - Important: Setting headers will replace any previously set headers. To add individual headers, use `addHeader(_:value:)` method.
    public func headers(_ headers: [String: String]) -> SNKDataRequest {
        self.headers = headers
        return self
    }
    /// Adds a single HTTP header to this request.
    ///
    /// This method adds or updates a single header field for the HTTP request.
    /// Unlike `headers(_:)` which replaces all headers, this method allows you to
    /// add headers incrementally without overwriting existing ones. If a header
    /// with the same field name already exists, its value will be updated.
    ///
    /// - Parameter field: The header field name (e.g., "Content-Type", "Authorization")
    /// - Parameter value: The header field value
    /// - Returns: The same `SNKDataRequest` instance to enable method chaining
    ///
    /// ## Example
    /// ```swift
    /// let request = SNKDataRequest(url, urlSession: session)
    ///     .method(.post)
    ///     .addHeader("Content-Type", value: "application/json")
    ///     .addHeader("Authorization", value: "Bearer \(token)")
    ///     .addHeader("X-Custom-Header", value: "custom-value")
    /// ```
    ///
    /// ## Updating Existing Headers
    /// ```swift
    /// let request = SNKDataRequest(url, urlSession: session)
    ///     .headers(["Content-Type": "text/plain"])
    ///     .addHeader("Content-Type", value: "application/json") // Adds new header
    ///     .addHeader("Authorization", value: "Bearer token")    // Adds new header
    ///     .addHeader("Authorization", value: "Bearer token321") // replaces the "Authorization" header value
    /// ```
    ///
    /// - Note: This method is preferred over `headers(_:)` when you need to build headers incrementally.
    public func addHeader(_ field: String, value: String) -> SNKDataRequest {
        if var headers {
            headers.updateValue(value, forKey: field)
        } else {
            self.headers = [field: value]
        }
        return self
    }

    /// Sets the query parameters for this request.
    ///
    /// This method configures the query parameters that will be appended to the URL.
    /// Query parameters are automatically URL-encoded and appended to the request URL
    /// in the format `?key1=value1&key2=value2`.
    ///
    /// - Parameter queryParams: A dictionary of parameter names and values to include as query parameters
    /// - Returns: The same `SNKDataRequest` instance to enable method chaining
    ///
    /// ## Example
    /// ```swift
    /// let request = SNKDataRequest(url)
    ///     .method(.get)
    ///     .queryParams([
    ///         "page": 1,
    ///         "limit": 20,
    ///         "search": "swift networking"
    ///     ])
    /// ```
    ///
    /// - Warning: Existing query parameters in the original URL may be overwritten.
    public func queryParams(_ queryParams: [String: String]) -> SNKDataRequest {
        self.queryParams = queryParams
        return self
    }
    /// Adds query parameters to this request incrementally.
    ///
    /// This method adds new query parameters or updates existing ones without replacing
    /// the entire query parameters dictionary. Unlike `queryParams(_:)` which replaces
    /// all parameters, this method allows you to build query parameters incrementally.
    /// If a parameter with the same key already exists, its value will be updated.
    ///
    /// - Parameter queryParams: A dictionary of parameter names and values to add to the existing query parameters
    /// - Returns: The same `SNKDataRequest` instance to enable method chaining
    ///
    /// ## Example
    /// ```swift
    /// let request = SNKDataRequest(url, urlSession: session)
    ///     .method(.get)
    ///     .addQueryParams(["page": 1, "limit": 20])
    ///     .addQueryParams(["search": "swift networking"])
    ///     .addQueryParams(["sort": "name"]) // Adds additional parameters
    /// ```
    ///
    /// ## Updating Existing Parameters
    /// ```swift
    /// let request = SNKDataRequest(url, urlSession: session)
    ///     .queryParams(["page": 1, "limit": 10])
    ///     .addQueryParams(["limit": 20, "search": "swift"]) // Updates limit, adds search
    /// ```
    ///
    /// - Note: This method is preferred over `queryParams(_:)` when you need to build parameters incrementally.
    public func addQueryParams(
        _ key: String,
        value: String
    ) -> SNKDataRequest {
        if var existingParams = self.queryParams {
            existingParams.updateValue(value, forKey: key)
            self.queryParams = existingParams
        } else {
            self.queryParams = [key: value]
        }
        return self
    }
    /// Sets the request body data.
    ///
    /// This method configures the raw data that will be sent as the HTTP request body.
    /// The body is typically used with HTTP methods like POST, PUT, or PATCH to send
    /// data to the server. The data format should match the Content-Type header.
    ///
    /// - Parameter body: The raw data to include in the request body
    /// - Returns: The same `SNKDataRequest` instance to enable method chaining
    ///
    /// ## Example
    /// ```swift
    /// struct User: Encodable {
    ///     let name: String
    ///     let age: Int
    /// }
    /// let user = User(name: "Stephen Sagarino", age: 23)
    /// let request = SNKDataRequest(url)
    ///     .method(.post)
    ///     .headers(["Content-Type": "application/json"])
    ///     .body(jsonData)
    /// ```
    ///
    /// ## Alternative Example with String
    /// ```swift
    /// let bodyString = "username=john&password=secret"
    /// let request = SNKDataRequest(url)
    ///     .method(.post)
    ///     .headers(["Content-Type": "application/x-www-form-urlencoded"])
    ///     .body(bodyData)
    /// ```
    ///
    /// - Important: Ensure the Content-Type header matches the format of your body data.
    public func body(_ body: Encodable) -> SNKDataRequest {
        self.body = body
        return self
    }

    /// Sets the request body using raw `Data`.
    ///
    /// Use this method to provide a pre-encoded or binary payload as the HTTP request body.
    /// This is useful for sending files, images, or custom-encoded data formats.
    ///
    /// - Parameter body: The raw `Data` to include in the request body.
    /// - Returns: The same `SNKDataRequest` instance to enable method chaining.
    ///
    /// ## Example
    /// ```swift
    /// let imageData: Data = ... // Load image data
    /// let request = SNKDataRequest(url)
    ///     .contentType(.imagePNG)
    ///     .body(imageData)
    ///     .post()
    /// ```
    ///
    /// - Important: Ensure the `Content-Type` header matches the format of your body data.
    public func body(_ body: Data) -> SNKDataRequest {
        self.body = body
        return self
    }
}

// MARK: - Helper Functions
extension SNKDataRequest {
    /// Validates the HTTP response and creates an appropriate SNKResponse object.
    ///
    /// This method processes the raw URLSession response, extracts the HTTP status code,
    /// and determines whether the response represents success or an error. It handles
    /// both successful responses and HTTP error status codes, wrapping them in a
    /// consistent `SNKResponse<Data>` format.
    ///
    /// - Parameter output: The raw response data and metadata from URLSession
    /// - Parameter isNilable: Whether the expected response type can be nil (affects empty response handling)
    /// - Returns: An `SNKResponse<Data>` containing the validated response data and status information
    /// - Throws: `SNKError.noStatusCode` if the response cannot be cast to `HTTPURLResponse` or lacks a status code
    ///
    /// ## Validation Logic
    /// - Extracts HTTP status code from the response
    /// - Categorizes status codes into success or error types using `HTTPStatusError` and `HTTPStatusSuccess`
    /// - For error status codes: Returns response with error status and the error object
    /// - For success status codes: Returns response with success status and no error
    /// - Handles empty responses based on the `isNilable` parameter
    ///
    /// ## Empty Response Handling
    /// When `isNilable` is `true` and response data is empty, the method injects `"null"` as UTF-8 data
    /// to facilitate JSON decoding of optional types. Otherwise, returns the raw empty data.
    ///
    /// ## Example Usage
    /// ```swift
    /// let output = URLSession.DataTaskPublisher.Output(data: data, response: response)
    /// let validatedResponse = try validate(output: output, isNilable: false)
    /// ```
    ///
    /// - Important: This method does not perform JSON decoding - it only validates HTTP status and prepares data for decoding.
    fileprivate func validate(
        output: URLSession.DataTaskPublisher.Output,
        isNilable: Bool
    ) throws -> SNKResponse<Data> {
        guard let statusCode = (output.response as? HTTPURLResponse)?.statusCode
        else {
            throw SNKError.noStatusCode
        }

        if let errorStatus = HTTPStatusError.from(statusCode: statusCode) {
            return SNKResponse(
                data: output.data,
                status: errorStatus,
                error: errorStatus
            )
        }

        let successStatus =
            HTTPStatusSuccess.from(statusCode: statusCode) ?? .ok

        let responseData =
            (output.data.isEmpty && isNilable) ? Data("null".utf8) : output.data

        return SNKResponse(
            data: responseData,
            status: successStatus,
            error: nil
        )
    }

    /// Builds a complete URLRequest from the current request configuration.
    ///
    /// This method constructs the final `URLRequest` that will be sent to the server
    /// by combining all the configured components: URL, HTTP method, headers, query parameters,
    /// and request body. It validates the URL and properly formats query parameters.
    ///
    /// - Parameter method: The HTTP method to use for this request (GET, POST, PUT, etc.)
    /// - Returns: A fully configured `URLRequest` ready for network execution
    /// - Throws: `URLError(.badURL)` if the request URL is invalid or nil
    ///
    /// ## Request Building Process
    /// 1. Copies the base `urlRequest` and validates the URL exists
    /// 2. Appends query parameters to the URL if any are configured
    /// 3. Sets the HTTP method from the provided parameter
    /// 4. Applies all configured headers to the request
    ///     - Automatically adds the `Content-Type` header based on `contentType`, default is `application/json`
    /// 5. Attaches the request body data if present
    ///
    /// ## Query Parameter Handling
    /// Query parameters are automatically converted to `URLQueryItem` objects and
    /// properly URL-encoded before being appended to the request URL.
    ///
    /// ## Example Usage
    /// ```swift
    /// // Internal usage within execute methods
    /// let urlRequest = try self.request(.post)
    /// let (data, response) = try await urlSession.data(for: urlRequest)
    /// ```
    ///
    /// ## Configuration Sources
    /// The method uses these instance properties to build the request:
    /// - `urlRequest`: Base URL and request configuration
    /// - `queryParams`: Dictionary converted to URL query items
    /// - `headers`: Applied as HTTP header fields
    /// - `body`: Set as the HTTP request body
    /// - `contentType`: Set as the HTTP request body's Content-Type header, defaults to `application/json`
    ///
    /// - Important: This method should only be called after all request configuration is complete.
    fileprivate func request(_ method: HTTPMethod) throws -> URLRequest {
        var request = URLRequest(url: self.url)

        guard request.url != nil
        else { throw URLError(.badURL) }

        if let params = self.paramsAsQueryItems() {
            request.url?.append(queryItems: params)
        }

        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = self.headers

        if let timeoutInterval = self.timeoutInterval {
            request.timeoutInterval = timeoutInterval
        }

        if let cachePolicy = self.cachePolicy {
            request.cachePolicy = cachePolicy
        }

        if let body = self.body {
            let body = try self.encoder.encode(body)
            request.httpBody = body
        }

        return request
    }
}

// MARK: - Transformer Functions
extension SNKDataRequest {
    fileprivate func paramsAsQueryItems() -> [URLQueryItem]? {
        guard let queryParams
        else { return nil }
        return queryParams.map { key, value in
            URLQueryItem(name: key, value: value)
        }
    }
}
