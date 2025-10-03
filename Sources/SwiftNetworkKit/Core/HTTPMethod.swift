//
//  File.swift
//  SwiftNetworkKit
//
//  Created by Stephen T. Sagarino Jr. on 10/2/25.
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
    case head = "HEAD"
    case options = "OPTIONS"
    case trace = "TRACE"
}
