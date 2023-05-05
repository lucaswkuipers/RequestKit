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

    @available(iOS 15.0, *)
    func perform() async throws -> (Data, URLResponse) {
        return try await URLSession.shared.data(for: self)
    }

    func perform(completion: @escaping (Result<(Data, URLResponse), Error>) -> Void) {
        URLSession.shared.dataTask(with: self) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data, let response = response {
                completion(.success((data, response)))
            } else {
                completion(.failure(NetworkError.invalidHTTPResponse))
            }
        }.resume()
    }

    @available(iOS 15.0, *)
    func getSuccessData() async throws -> Data {
        let (data, response) = try await perform()
        guard try response.toHTTP().hasSuccessStatusCode else { throw NetworkError.httpResponseFailureStatusCode }
            print("💾 [Data]: \(data)")
            print("📥 [Response]: \(response)")
        return data
    }

    func getSuccessData(completion: @escaping (Result<Data, Error>) -> Void) {
        perform { result in
            switch result {
            case .success(let (data, response)):
                if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                    print("💾 [Data]: \(data)")
                    print("📥 [Response]: \(response)")
                    completion(.success(data))
                } else {
                    completion(.failure(NetworkError.httpResponseFailureStatusCode))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
