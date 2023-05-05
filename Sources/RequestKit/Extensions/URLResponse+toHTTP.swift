import Foundation

public extension URLResponse {
    func toHTTP() throws -> HTTPURLResponse {
        guard let httpResponse = self as? HTTPURLResponse else { throw NetworkError.invalidHTTPResponse }
        return httpResponse
    }
}
