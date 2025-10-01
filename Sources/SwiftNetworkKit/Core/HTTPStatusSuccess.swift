//
//  HTTPStatusSuccess.swift
//  SwiftNetworkKit
//
//  Created by Stephen T. Sagarino Jr. on 10/1/25.
//

import Foundation

public enum HTTPStatusSuccess: Int, HTTPStatus {

    case `continue` = 100
    case switchingProtocols = 101
    case processing = 102
    case earlyHints = 103
    case ok = 200
    case created = 201
    case accepted = 202
    case nonAuthoritativeInformation = 203
    case noContent = 204
    case resetContent = 205
    case partialContent = 206
    case multiStatus = 207
    case alreadyReported = 208
    case thisIsFine = 218
    case imUsed = 226
    case multipleChoices = 300
    case movedPermanently = 301
    case found = 302
    case seeOther = 303
    case notModified = 304
    case useProxy = 305
    case switchProxy = 306
    case temporaryRedirect = 307
    case permanentRedirect = 308

}

// MARK: HTTPStatus conformations
extension HTTPStatusSuccess {
    /// A human-readable description for each HTTP status code.
    public var description: String {
        switch self {
        case .continue: return "Continue"
        case .switchingProtocols: return "Switching Protocols"
        case .processing: return "Processing"
        case .earlyHints: return "Early Hints"
        case .ok: return "OK"
        case .created: return "Created"
        case .accepted: return "Accepted"
        case .nonAuthoritativeInformation:
            return "Non-Authoritative Information"
        case .noContent: return "No Content"
        case .resetContent: return "Reset Content"
        case .partialContent: return "Partial Content"
        case .multiStatus: return "Multi-Status"
        case .alreadyReported: return "Already Reported"
        case .thisIsFine: return "This Is Fine"
        case .imUsed: return "IM Used"
        case .multipleChoices: return "Multiple Choices"
        case .movedPermanently: return "Moved Permanently"
        case .found: return "Found"
        case .seeOther: return "See Other"
        case .notModified: return "Not Modified"
        case .useProxy: return "Use Proxy"
        case .switchProxy: return "Switch Proxy"
        case .temporaryRedirect: return "Temporary Redirect"
        case .permanentRedirect: return "Permanent Redirect"
        }
    }

}
