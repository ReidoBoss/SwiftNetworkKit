//
//  File.swift
//  SwiftNetworkKit
//
//  Created by Stephen T. Sagarino Jr. on 10/7/25.
//

import Foundation

public enum ContentType: String {
    case json = "application/json"
    case formURLEncoded = "application/x-www-form-urlencoded"
    case multipartFormData = "multipart/form-data"
    case textPlain = "text/plain"
    case textHTML = "text/html"
    case applicationXML = "application/xml"
    case textXML = "text/xml"
    case applicationPDF = "application/pdf"
    case imagePNG = "image/png"
    case imageJPEG = "image/jpeg"
    case applicationOctetStream = "application/octet-stream"
}
