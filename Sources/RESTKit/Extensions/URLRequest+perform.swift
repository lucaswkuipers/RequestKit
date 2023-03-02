import Foundation

public extension URLRequest {
    init(
        url: URL?,
        httpMethod: String,
        httpBody: Data? = nil,
        allHTTPHeaderFields: [String: String]? = nil
    ) throws {
        guard let url else { throw NetworkError.invalidURL }
        self.init(url: url)
        self.httpMethod = httpMethod
        self.httpBody = httpBody
        self.allHTTPHeaderFields = allHTTPHeaderFields
    }

    func perform() async throws -> (Data, URLResponse) {
        try await URLSession.shared.data(for: self)
    }

    func getSuccessData() async throws -> Data {
        let (data, response) = try await perform()
        guard try response.toHTTP().hasSuccessStatusCode else { throw NetworkError.httpResponseFailureStatusCode }

//        if Configuration.isLoggingEwnabled {
            print("💾 [Data]: \(data)")
            print("📥 [Response]: \(response)")
//        }

        return data
    }
}
