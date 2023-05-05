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

    @available(iOS 13.0.0, *)
    func perform() async throws -> (Data, URLResponse) {
        if #available(iOS 15.0, *) {
            return try await URLSession.shared.data(for: self)
        } else {
            // Fallback on earlier versions
            fatalError()
        }
    }

    @available(iOS 13.0.0, *)
    func getSuccessData() async throws -> Data {
        let (data, response) = try await perform()
        guard try response.toHTTP().hasSuccessStatusCode else { throw NetworkError.httpResponseFailureStatusCode }
            print("💾 [Data]: \(data)")
            print("📥 [Response]: \(response)")
        return data
    }
}
