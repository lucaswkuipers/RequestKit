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
        var request = self
        return request.authorization("Bearer \(token)")
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
    func body(_ body: [String: Any]) -> URLRequest {
        var request = self
        let data = try? JSONSerialization.data(withJSONObject: body, options: [])
        request.httpBody = data
        return request
    }

    @discardableResult
    func body<T: Encodable>(_ body: T) -> URLRequest {
        var request = self
        let encoder = JSONEncoder()
        let data = try? encoder.encode(body)
        request.httpBody = data
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

    func perform<T: Decodable>(completion: @escaping (Result<T, Error>) -> Void) {
        perform { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let decodedObject = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedObject))
                } catch let decodeError {
                    completion(.failure(decodeError))
                }
            }
        }
    }
}
