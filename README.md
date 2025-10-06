
# Swift Network Kit

A modern HTTP networking library for Swift and SwiftUI, supporting all Apple platforms.

[![Platforms](https://img.shields.io/badge/Platforms-macOS_iOS_tvOS_watchOS_visionOS-yellowgreen?style=flat-square)](https://img.shields.io/badge/Platforms-macOS_iOS_tvOS_watchOS_visionOS-green?style=flat-square)


---

## Features

\- Simple, fluent API for HTTP requests  
\- Built for SwiftUI and concurrency  
\- Codable support for request and response bodies  
\- Customizable headers, query parameters, and content types  
\- Optional base URL for convenient relative path requests  
\- Works on macOS, iOS, tvOS, watchOS, and visionOS

---

## Installation

Add SwiftNetworkKit to your project using Swift Package Manager:

```
https://github.com/reidoboss/SwiftNetworkKit.git
```

---

## Quick Start

Basic POST request example:

```swift
import SwiftNetworkKit

struct User: Encodable {
    let name: String
    let email: String
}

struct UserResponse: Decodable {
    let id: UUID
    let name: String
}

let user = User(
    name: "Stephen T. Sagarino Jr.",
    email: "stephen@stsagarino.com"
)
let url = URL(string: "http://your.api/post")!

let response = await SNK
    .request(url: url)
    .jsonContentType()
    .body(user)
    .post(validateBodyAs: UserResponse.self)

if let userData = response.data {
    print("User ID: \(userData.id), Name: \(userData.name)")
} else if let error = response.error {
    print("Error: \(error)")
}
```

---

## Websocket
\- **Coming Soon**

---

## Documentation

\- API Reference (coming soon)  
\- Examples (coming soon)  
\- FAQ (coming soon)
