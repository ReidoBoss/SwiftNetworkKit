//
//  ContentView.swift
//  Example
//
//  Created by Stephen T. Sagarino Jr. on 10/6/25.
//

import SwiftNetworkKit
import SwiftUI

struct ContentView: View {
    @State private var results: [TestResult] = []
    @State private var isLoading = false

    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("Running tests...")
                        .padding()
                }

                Button("Run All Tests") {
                    runAllTests()
                }
                .disabled(isLoading)
                .padding()

                List(results) { result in
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(result.name)
                                .font(.headline)
                            Spacer()
                            Text(result.status.rawValue)
                                .foregroundColor(result.status.color)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(result.status.color.opacity(0.2))
                                .cornerRadius(4)
                        }

                        if let response = result.response {
                            Text(response)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .lineLimit(3)
                        }

                        if let error = result.error {
                            Text("Error: \(error)")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.vertical, 2)
                }
            }
            .navigationTitle("SwiftNetworkKit Tests")
        }
    }

    func runAllTests() {
        isLoading = true
        results.removeAll()

        Task {
            await testJSONPost()
            await testFormPost()
            await testGETRequest()
            await testQueryParameters()
            await testCustomHeaders()
            await testErrorHandling()
            await testMultipleContentTypes()

            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }

    func testJSONPost() async {
        let testData = TestUser(
            name: "John Doe",
            email: "john@example.com",
            age: 30
        )

        let response =
            await SNK
            .request(url: URL(string: "https://httpbin.org/post")!)
            .contentType(.json)  // no need to write this, .json is already default
            .body(testData)
            .post(validateBodyAs: HttpBinResponse.self)

        let result = TestResult(
            name: "JSON POST",
            status: response.data != nil ? .success : .failed,
            response: response.data?.json?.description,
            error: response.error?.localizedDescription
        )

        DispatchQueue.main.async {
            self.results.append(result)
        }
    }

    func testFormPost() async {
        let formData = FormData(
            comments: "Great pizza!",
            custemail: "customer@example.com",
            custname: "Jane Smith",
            custtel: "555-1234",
            delivery: "19:30",
            size: "large",
            topping: "pepperoni"
        )

        let response =
            await SNK
            .request(url: URL(string: "https://httpbin.org/post")!)
            .contentType(.formURLEncoded)
            .body(formData)
            .post(validateBodyAs: HttpBinResponse.self)

        let result = TestResult(
            name: "Form POST",
            status: response.data != nil ? .success : .failed,
            response: response.data?.form?.description,
            error: response.error?.localizedDescription
        )

        DispatchQueue.main.async {
            self.results.append(result)
        }
    }

    func testGETRequest() async {
        let response =
            await SNK
            .request(url: URL(string: "https://httpbin.org/get")!)
            .get(validateBodyAs: HttpBinGetResponse.self)

        let result = TestResult(
            name: "GET Request",
            status: response.data != nil ? .success : .failed,
            response: "URL: \(response.data?.url ?? "none")",
            error: response.error?.localizedDescription
        )

        DispatchQueue.main.async {
            self.results.append(result)
        }
    }

    func testQueryParameters() async {
        let response =
            await SNK
            .request(url: URL(string: "https://httpbin.org/get")!)
            .addQueryParams("test", value: "value1")
            .addQueryParams("another", value: "value2")
            .get(validateBodyAs: HttpBinGetResponse.self)

        let result = TestResult(
            name: "Query Parameters",
            status: (response.data?.args.count ?? 0) >= 2 ? .success : .failed,
            response: "Args: \(response.data?.args.description ?? "none")",
            error: response.error?.localizedDescription
        )

        DispatchQueue.main.async {
            self.results.append(result)
        }
    }

    func testCustomHeaders() async {
        let response =
            await SNK
            .request(url: URL(string: "https://httpbin.org/headers")!)
            .addHeader("X-Custom-Header", value: "test-value")
            .addHeader("X-Another-Header", value: "another-value")
            .get(validateBodyAs: HttpBinHeaderResponse.self)

        let hasCustomHeaders = response.data?.headers["X-Custom-Header"] != nil

        let result = TestResult(
            name: "Custom Headers",
            status: hasCustomHeaders ? .success : .failed,
            response: "Custom header found: \(hasCustomHeaders)",
            error: response.error?.localizedDescription
        )

        DispatchQueue.main.async {
            self.results.append(result)
        }
    }

    func testErrorHandling() async {
        let response =
            await SNK
            .request(url: URL(string: "https://httpbin.org/status/404")!)
            .get(validateBodyAs: HttpBinResponse.self)

        let result = TestResult(
            name: "Error Handling(Json can't be decoded)",
            status: response.error != nil ? .success : .failed,
            response: "Status code: \(response.status?.code ?? 0)",
            error: response.error?.localizedDescription
        )

        DispatchQueue.main.async {
            self.results.append(result)
        }
    }

    func testMultipleContentTypes() async {
        // Test XML content type
        let response =
            await SNK
            .request(url: URL(string: "https://httpbin.org/post")!)
            .contentType(.applicationXML)
            .post(validateBodyAs: HttpBinResponse.self)

        let result = TestResult(
            name: "XML Content-Type",
            status: response.data?.headers["Content-Type"]?.contains("xml")
                == true ? .success : .failed,
            response:
                "Content-Type: \(response.data?.headers["Content-Type"] ?? "none")",
            error: response.error?.localizedDescription
        )

        DispatchQueue.main.async {
            self.results.append(result)
        }
    }
}

// MARK: - Models

struct TestResult: Identifiable {
    let id = UUID()
    let name: String
    let status: TestStatus
    let response: String?
    let error: String?
}

enum TestStatus: String {
    case success = "✅ PASS"
    case failed = "❌ FAIL"
    case running = "🔄 RUNNING"

    var color: Color {
        switch self {
        case .success: return .green
        case .failed: return .red
        case .running: return .orange
        }
    }
}

struct TestUser: Codable {
    let name: String
    let email: String
    let age: Int
}

struct HttpBinResponse: Codable {
    let args: [String: String]
    let headers: [String: String]
    let origin: String
    let url: String
    let data: String?
    let form: [String: String]?
    let json: [String: AnyCodable]?
}

struct HttpBinGetResponse: Codable {
    let args: [String: String]
    let headers: [String: String]
    let origin: String
    let url: String
}

struct HttpBinHeaderResponse: Codable {
    let headers: [String: String]
}

struct AnyCodable: Codable {
    let value: Any

    private struct CodingKeys: CodingKey {
        var stringValue: String
        var intValue: Int?

        init?(stringValue: String) {
            self.stringValue = stringValue
            self.intValue = nil
        }

        init?(intValue: Int) {
            self.stringValue = "\(intValue)"
            self.intValue = intValue
        }
    }

    init<T>(_ value: T?) {
        self.value = value ?? ()
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let intVal = try? container.decode(Int.self) {
            value = intVal
        } else if let doubleVal = try? container.decode(Double.self) {
            value = doubleVal
        } else if let boolVal = try? container.decode(Bool.self) {
            value = boolVal
        } else if let stringVal = try? container.decode(String.self) {
            value = stringVal
        } else if let arrayVal = try? container.decode([AnyCodable].self) {
            value = arrayVal.map { $0.value }
        } else if let dictVal = try? container.decode([String: AnyCodable].self)
        {
            value = dictVal.mapValues { $0.value }
        } else {
            value = ()
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch value {
        case let intVal as Int:
            try container.encode(intVal)
        case let doubleVal as Double:
            try container.encode(doubleVal)
        case let boolVal as Bool:
            try container.encode(boolVal)
        case let stringVal as String:
            try container.encode(stringVal)
        case let arrayVal as [Any]:
            let codableArray = arrayVal.map { AnyCodable($0) }
            try container.encode(codableArray)
        case let dictVal as [String: Any]:
            let codableDict = dictVal.mapValues { AnyCodable($0) }
            try container.encode(codableDict)
        default:
            try container.encodeNil()
        }
    }
}

extension AnyCodable: CustomStringConvertible {
    var description: String {
        switch value {
        case let val as CustomStringConvertible:
            return val.description
        default:
            return String(describing: value)
        }
    }
}

struct FormData: Codable {
    let comments: String
    let custemail: String
    let custname: String
    let custtel: String
    let delivery: String
    let size: String
    let topping: String
}

#Preview {
    ContentView()
}
