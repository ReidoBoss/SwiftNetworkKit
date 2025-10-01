//
//  HTTPStatusError.swift
//  SwiftNetworkKit
//
//  Created by Stephen T. Sagarino Jr. on 10/1/25.
//

import Foundation

public enum HTTPStatusError: Int, HTTPStatus, Error {
    case badRequest = 400
    case unauthorized = 401
    case paymentRequired = 402
    case forbidden = 403
    case notFound = 404
    case methodNotAllowed = 405
    case notAcceptable = 406
    case proxyAuthenticationRequired = 407
    case requestTimeout = 408
    case conflict = 409
    case gone = 410
    case lengthRequired = 411
    case preconditionFailed = 412
    case payloadTooLarge = 413
    case uriTooLong = 414
    case unsupportedMediaType = 415
    case rangeNotSatisfiable = 416
    case expectationFailed = 417
    case imATeapot = 418
    case misdirectedRequest = 421
    case unprocessableEntity = 422
    case locked = 423
    case failedDependency = 424
    case tooEarly = 425
    case upgradeRequired = 426
    case preconditionRequired = 428
    case tooManyRequests = 429
    case requestHeaderFieldsTooLarge = 431
    case unavailableForLegalReasons = 451
    case internalServerError = 500
    case notImplemented = 501
    case badGateway = 502
    case serviceUnavailable = 503
    case gatewayTimeout = 504
    case httpVersionNotSupported = 505
    case variantAlsoNegotiates = 506
    case insufficientStorage = 507
    case loopDetected = 508
    case notExtended = 510
    case networkAuthenticationRequired = 511
    case webServerUnknownError = 520
    case webServerIsDown = 521
    case webServerIsUnreachable = 522
    case webServerIsCannotHandleRequest = 523
    case webServerTimeout = 524
    case sslHandshakeFailed = 525
    case invalidSSLCertificate = 526
    case railgunError = 527
    case serverIsOverloaded = 529
    case siteIsFrozen = 530
    case unauthorizedIPRange = 561
    case networkReadTimeoutError = 598
    case networkConnectTimeoutError = 599
}

// MARK: HTTPStatus conformations
extension HTTPStatusError {

    public var description: String {
        switch self {
        case .badRequest: "Bad Request"
        case .unauthorized: "Unauthorized"
        case .paymentRequired: "Payment Required"
        case .forbidden: "Forbidden"
        case .notFound: "Not Found"
        case .methodNotAllowed: "Method Not Allowed"
        case .notAcceptable: "Not Acceptable"
        case .proxyAuthenticationRequired: "Proxy Authentication Required"
        case .requestTimeout: "Request Timeout"
        case .conflict: "Conflict"
        case .gone: "Gone"
        case .lengthRequired: "Length Required"
        case .preconditionFailed: "Precondition Failed"
        case .payloadTooLarge: "Payload Too Large"
        case .uriTooLong: "URI Too Long"
        case .unsupportedMediaType: "Unsupported Media Type"
        case .rangeNotSatisfiable: "Range Not Satisfiable"
        case .expectationFailed: "Expectation Failed"
        case .imATeapot: "I'm a teapot"
        case .misdirectedRequest: "Misdirected Request"
        case .unprocessableEntity: "Unprocessable Entity"
        case .locked: "Locked"
        case .failedDependency: "Failed Dependency"
        case .tooEarly: "Too Early"
        case .upgradeRequired: "Upgrade Required"
        case .preconditionRequired: "Precondition Required"
        case .tooManyRequests: "Too Many Requests"
        case .requestHeaderFieldsTooLarge: "Request Header Fields Too Large"
        case .unavailableForLegalReasons: "Unavailable For Legal Reasons"
        case .internalServerError: "Internal Server Error"
        case .notImplemented: "Not Implemented"
        case .badGateway: "Bad Gateway"
        case .serviceUnavailable: "Service Unavailable"
        case .gatewayTimeout: "Gateway Timeout"
        case .httpVersionNotSupported: "HTTP Version Not Supported"
        case .variantAlsoNegotiates: "Variant Also Negotiates"
        case .insufficientStorage: "Insufficient Storage"
        case .loopDetected: "Loop Detected"
        case .notExtended: "Not Extended"
        case .networkAuthenticationRequired: "Network Authentication Required"
        case .webServerUnknownError: "Web Server Unknown Error"
        case .webServerIsDown: "Web Server Is Down"
        case .webServerIsUnreachable: "Web Server Is Unreachable"
        case .webServerIsCannotHandleRequest: "Web Server Cannot Handle Request"
        case .webServerTimeout: "Web Server Timeout"
        case .sslHandshakeFailed: "SSL Handshake Failed"
        case .invalidSSLCertificate: "Invalid SSL Certificate"
        case .railgunError: "Railgun Error"
        case .serverIsOverloaded: "Server Is Overloaded"
        case .siteIsFrozen: "Site Is Frozen"
        case .unauthorizedIPRange: "Unauthorized IP Range"
        case .networkReadTimeoutError: "Network Read Timeout Error"
        case .networkConnectTimeoutError: "Network Connect Timeout Error"
        }
    }

}

// MARK: - LocalizedError Conformance
extension HTTPStatusError: LocalizedError {

    /// Localized description for the error, suitable for displaying to users
    public var localizedDescription: String {
        return description
    }

    /// A localized message describing the reason for the failure
    public var failureReason: String? {
        switch self {
        case .badRequest:
            "The request was malformed or contained invalid parameters"
        case .unauthorized:
            "Authentication credentials are missing or invalid"
        case .paymentRequired:
            "Payment is required to access this resource"
        case .forbidden:
            "Access to the requested resource is forbidden"
        case .notFound:
            "The requested resource could not be found"
        case .methodNotAllowed:
            "The HTTP method is not allowed for this resource"
        case .notAcceptable:
            "The server cannot produce a response matching the request's accept headers"
        case .proxyAuthenticationRequired:
            "Authentication with the proxy server is required"
        case .requestTimeout:
            "The server timed out waiting for the request"
        case .conflict:
            "The request conflicts with the current state of the resource"
        case .gone:
            "The requested resource is no longer available"
        case .lengthRequired:
            "The request must specify a Content-Length header"
        case .preconditionFailed:
            "One or more preconditions in the request headers failed"
        case .payloadTooLarge:
            "The request payload is larger than the server can process"
        case .uriTooLong:
            "The request URI is too long for the server to process"
        case .unsupportedMediaType:
            "The request media type is not supported by the server"
        case .rangeNotSatisfiable:
            "The requested range cannot be satisfied"
        case .expectationFailed:
            "The server cannot meet the requirements of the Expect header"
        case .imATeapot:
            "The server refuses to brew coffee because it is a teapot"
        case .misdirectedRequest:
            "The request was directed at a server that cannot produce a response"
        case .unprocessableEntity:
            "The request is well-formed but contains semantic errors"
        case .locked:
            "The requested resource is locked"
        case .failedDependency:
            "The request failed due to failure of a previous request"
        case .tooEarly:
            "The server is unwilling to process a request that might be replayed"
        case .upgradeRequired:
            "The client should switch to a different protocol"
        case .preconditionRequired:
            "The origin server requires the request to be conditional"
        case .tooManyRequests:
            "Too many requests have been sent in a given time frame"
        case .requestHeaderFieldsTooLarge:
            "The server refuses to process the request because header fields are too large"
        case .unavailableForLegalReasons:
            "The resource is unavailable for legal reasons"
        case .internalServerError:
            "The server encountered an unexpected condition"
        case .notImplemented:
            "The server does not support the functionality required to fulfill the request"
        case .badGateway:
            "The server received an invalid response from an upstream server"
        case .serviceUnavailable:
            "The server is temporarily unavailable due to maintenance or overload"
        case .gatewayTimeout:
            "The server did not receive a timely response from an upstream server"
        case .httpVersionNotSupported:
            "The HTTP version used in the request is not supported"
        case .variantAlsoNegotiates:
            "The server has an internal configuration error"
        case .insufficientStorage:
            "The server is unable to store the representation needed to complete the request"
        case .loopDetected:
            "The server detected an infinite loop while processing the request"
        case .notExtended:
            "Further extensions to the request are required for the server to fulfill it"
        case .networkAuthenticationRequired:
            "Network authentication is required to access the resource"
        case .webServerUnknownError:
            "The web server returned an unknown error"
        case .webServerIsDown:
            "The web server is currently down"
        case .webServerIsUnreachable:
            "The web server is unreachable"
        case .webServerIsCannotHandleRequest:
            "The web server cannot handle the request"
        case .webServerTimeout:
            "The web server timed out"
        case .sslHandshakeFailed:
            "SSL handshake failed during connection"
        case .invalidSSLCertificate:
            "The SSL certificate is invalid or expired"
        case .railgunError:
            "A Railgun error occurred"
        case .serverIsOverloaded:
            "The server is overloaded and cannot process the request"
        case .siteIsFrozen:
            "The site is temporarily frozen"
        case .unauthorizedIPRange:
            "The request originated from an unauthorized IP range"
        case .networkReadTimeoutError:
            "A network read timeout occurred"
        case .networkConnectTimeoutError:
            "A network connection timeout occurred"
        }
    }
}
