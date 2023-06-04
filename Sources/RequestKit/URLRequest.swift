import Foundation

public extension URL {
    var request: URLRequest {
        URLRequest(url: self)
    }
}

public extension URLRequest {
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case patch = "PATCH"
        case delete = "DELETE"
    }

    enum ContentType: String {
        case html = "text/html"
        case json = "application/json"
        case xml = "application/xml"
        case plainText = "text/plain"
        case formData = "multipart/form-data"
    }

    init?(url: URL?) {
        guard let url else { return nil }
        self.init(url: url)
    }

    @discardableResult
    func url(_ url: URL?) -> URLRequest {
        var request = self
        request.url = url
        return request
    }

    @discardableResult
    func authorizationBearer(_ token: String) -> Self {
        return authorization("Bearer \(token)")
    }

    @discardableResult
    func method(_ method: HTTPMethod) -> URLRequest {
        var request = self
        request.httpMethod = method.rawValue
        return request
    }

    @discardableResult
    func headers(_ headers: [String: String]) -> URLRequest {
        var request = self
        request.allHTTPHeaderFields = headers
        return request
    }

    @discardableResult
    func contentType(_ type: ContentType) -> URLRequest {
        var request = self
        request.addValue(type.rawValue, forHTTPHeaderField: "Content-Type")
        return request
    }

    @discardableResult
    func accept(_ type: String) -> URLRequest {
        var request = self
        request.addValue(type, forHTTPHeaderField: "Accept")
        return request
    }

    @discardableResult
    func authorization(_ value: String) -> URLRequest {
        var request = self
        request.addValue(value, forHTTPHeaderField: "Authorization")
        return request
    }

    @discardableResult
    func userAgent(_ value: String) -> URLRequest {
        var request = self
        request.addValue(value, forHTTPHeaderField: "User-Agent")
        return request
    }

    @discardableResult
    func body(_ body: Data?) -> URLRequest {
        var request = self
        request.httpBody = body
        return request
    }

    @discardableResult
    func cachePolicy(_ policy: CachePolicy) -> URLRequest {
        var request = self
        request.cachePolicy = policy
        return request
    }

    func perform(completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        URLSession.shared.dataTask(with: self, completionHandler: completion).resume()
    }

    @available(iOS 13.0, macOS 10.15, *)
    func perform() async -> (data: Data, response: URLResponse)? {
        if #available(iOS 15.0, macOS 12.0, *) {
            return try? await URLSession.shared.data(for: self)
        } else {
            return try? await withCheckedThrowingContinuation { continuation in
                perform { (data, response, error) in
                    if let error {
                        continuation.resume(throwing: error)
                    } else if let data, let response {
                        continuation.resume(returning: (data, response))
                    } else {
                        let error = NSError(
                            domain: "",
                            code: 0,
                            userInfo: [NSLocalizedDescriptionKey: "Unknown error"]
                        )
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }

}

public extension Encodable {
    func encoded(with encoder: JSONEncoder = JSONEncoder()) -> Data? {
        try? encoder.encode(self)
    }
}

public extension Data {
    func decoded<T: Decodable>(with decoder: JSONDecoder = JSONDecoder(), of type: T.Type) -> T? {
        try? decoder.decode(type, from: self)
    }
}
