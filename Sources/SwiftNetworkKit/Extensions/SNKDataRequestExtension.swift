//
//  SNKDataRequest.swift
//  SwiftNetworkKit
//
//  Created by Stephen T. Sagarino Jr. on 10/6/25.
//

extension SNKDataRequest {
    @available(
        *,
        deprecated,
        message: "Use SwiftNetworkKit.ContentType instead"
    )
    internal struct ContentType {
        public static let json = "application/json"
        public static let formURLEncoded = "application/x-www-form-urlencoded"
        public static let multipartFormData = "multipart/form-data"
        public static let textPlain = "text/plain"
        public static let textHTML = "text/html"
        public static let applicationXML = "application/xml"
        public static let textXML = "text/xml"
        public static let applicationPDF = "application/pdf"
        public static let imagePNG = "image/png"
        public static let imageJPEG = "image/jpeg"
        public static let applicationOctetStream = "application/octet-stream"
    }

    @available(
        *,
        deprecated,
        message: "Use .contentType(.json) instead"
    )
    /// Sets the Content-Type header to application/json
    public func jsonContentType() -> SNKDataRequest {
        return self.addHeader("Content-Type", value: ContentType.json)
    }

    @available(
        *,
        deprecated,
        message: "Use .contentType(.formURLEncoded) instead"
    )
    /// Sets the Content-Type header to application/x-www-form-urlencoded
    public func formContentType() -> SNKDataRequest {
        return self.addHeader("Content-Type", value: ContentType.formURLEncoded)
    }

    @available(
        *,
        deprecated,
        message: "Use .contentType(.multipartFormData) instead"
    )
    /// Sets the Content-Type header to multipart/form-data
    public func multipartContentType() -> SNKDataRequest {
        return self.addHeader(
            "Content-Type",
            value: ContentType.multipartFormData
        )
    }

    @available(
        *,
        deprecated,
        message: "Use .contentType(.textPlain) instead"
    )
    /// Sets the Content-Type header to text/plain
    public func textContentType() -> SNKDataRequest {
        return self.addHeader("Content-Type", value: ContentType.textPlain)
    }

    @available(
        *,
        deprecated,
        message: "Use .contentType(.textHTML) instead"
    )
    /// Sets the Content-Type header to text/html
    public func htmlContentType() -> SNKDataRequest {
        return self.addHeader("Content-Type", value: ContentType.textHTML)
    }

    @available(
        *,
        deprecated,
        message: "Use .contentType(.applicationXML) instead"
    )
    /// Sets the Content-Type header to application/xml
    public func xmlContentType() -> SNKDataRequest {
        return self.addHeader("Content-Type", value: ContentType.applicationXML)
    }

    @available(
        *,
        deprecated,
        message: "Use .contentType(.applicationPDF) instead"
    )
    /// Sets the Content-Type header to application/pdf
    public func pdfContentType() -> SNKDataRequest {
        return self.addHeader("Content-Type", value: ContentType.applicationPDF)
    }

    @available(
        *,
        deprecated,
        message: "Use .contentType(.imagePNG) instead"
    )
    /// Sets the Content-Type header to image/png
    public func pngContentType() -> SNKDataRequest {
        return self.addHeader("Content-Type", value: ContentType.imagePNG)
    }

    @available(
        *,
        deprecated,
        message: "Use .contentType(.imageJPEG) instead"
    )
    /// Sets the Content-Type header to image/jpeg
    public func jpegContentType() -> SNKDataRequest {
        return self.addHeader("Content-Type", value: ContentType.imageJPEG)
    }

    @available(
        *,
        deprecated,
        message: "Use .contentType(.applicationOctetStream) instead"
    )
    /// Sets the Content-Type header to application/octet-stream
    public func binaryContentType() -> SNKDataRequest {
        return self.addHeader(
            "Content-Type",
            value: ContentType.applicationOctetStream
        )
    }
}
