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
        case .continue: "Continue"
        case .switchingProtocols: "Switching Protocols"
        case .processing: "Processing"
        case .earlyHints: "Early Hints"
        case .ok: "OK"
        case .created: "Created"
        case .accepted: "Accepted"
        case .nonAuthoritativeInformation:
            "Non-Authoritative Information"
        case .noContent: "No Content"
        case .resetContent: "Reset Content"
        case .partialContent: "Partial Content"
        case .multiStatus: "Multi-Status"
        case .alreadyReported: "Already Reported"
        case .thisIsFine: "This Is Fine"
        case .imUsed: "IM Used"
        case .multipleChoices: "Multiple Choices"
        case .movedPermanently: "Moved Permanently"
        case .found: "Found"
        case .seeOther: "See Other"
        case .notModified: "Not Modified"
        case .useProxy: "Use Proxy"
        case .switchProxy: "Switch Proxy"
        case .temporaryRedirect: "Temporary Redirect"
        case .permanentRedirect: "Permanent Redirect"
        }
    }

}
