//
//  File.swift
//  SwiftNetworkKit
//
//  Created by Stephen T. Sagarino Jr. on 10/2/25.
//

import Foundation

struct Usage {

    let session =
        SNKSession(urlSession: .shared)
        .request(url: "https://vueuse.org/core/useFetch/")
        .method(.get)

}
