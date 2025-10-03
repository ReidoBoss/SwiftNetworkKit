//
//  File 2.swift
//  SwiftNetworkKit
//
//  Created by Stephen T. Sagarino Jr. on 10/2/25.
//

import Combine
import Foundation

open class SNKDataRequest: @unchecked Sendable {

    open private(set) var method: HTTPMethod = .get
    open private(set) var coder: JSONDecoder = JSONDecoder()
    //    open private(set) var decoder: JSONDecoder = .get
    //
    //    open func method(_ method: HTTPMethod) -> SNKDataRequest {
    //        self.method = method
    //        return self
    //    }

    open func method(_ method: HTTPMethod) -> SNKDataRequest {
        self.method = method
        return self
    }
    
    open func coder(_ method: HTTPMethod) -> SNKDataRequest {
        self.method = method
        return self
    }

}
