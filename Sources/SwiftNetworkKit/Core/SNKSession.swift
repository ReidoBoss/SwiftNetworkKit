//
//  File.swift
//  SwiftNetworkKit
//
//  Created by Stephen T. Sagarino Jr. on 10/2/25.
//

import Foundation

open class SNKSession: @unchecked Sendable {

    let urlSession: URLSession

    init(
        urlSession: URLSession
    ) {
        self.urlSession = urlSession
    }

    open func request(url: String) -> SNKDataRequest {
        .init()
    }

}
