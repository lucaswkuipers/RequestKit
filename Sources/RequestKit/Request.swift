import Foundation

public enum HTTPMethod: String {
    case get
    case post
    case put
    case delete
    case head
    case patch
    case options
    case connect
    case trace

    var verb: String { rawValue.uppercased() }
}

public protocol Request {
    associatedtype RemoteModel: Decodable
    var url: URL? { get }
    var method: HTTPMethod { get }
    var header: [String: String]? { get }
    var body: Data? { get }
}

public extension Request {
    var header: [String: String]? { nil }
    var body: Data? { nil }
}

public extension HTTPURLResponse {
    var hasSuccessStatusCode: Bool { (200..<300).contains(statusCode) }
}

public extension Request {
    func toURLRequest() throws -> URLRequest {
        return try URLRequest(
            url: url,
            httpMethod: method.verb,
            httpBody: body,
            allHTTPHeaderFields: header
        )
    }
}

public extension Request {
    func decode(_ data: Data) throws -> RemoteModel {
        return try RemoteModel.decoding(data)
    }
}

public extension Request {
    @available(iOS 15.0, *)
    func send() async -> Result<RemoteModel, Error> {
        do {
            let data = try await toURLRequest().getSuccessData()
            let remoteModel = try decode(data)
            return .success(remoteModel)
        } catch {
            print("🚩 ERROR: \(error.localizedDescription)")
            return .failure(error)
        }
    }

    func send(completion: @escaping (Result<RemoteModel, Error>) -> Void) {
        do {
            try toURLRequest().getSuccessData { result in
                switch result {
                case .success(let data):
                    do {
                        let remoteModel = try decode(data)
                        completion(.success(remoteModel))
                    } catch {
                        print("🚩 ERROR: \(error.localizedDescription)")
                        completion(.failure(error))
                    }
                case .failure(let error):
                    print("🚩 ERROR: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        } catch {
            print("🚩 ERROR: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }

}
