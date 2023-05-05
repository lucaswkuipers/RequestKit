import XCTest
@testable import RequestKit

final class RESTKitTests: XCTestCase {
    func test() {}
}

struct MockDecodable: Decodable {
    let name: String
}

struct MockRequest: Request {
    typealias RemoteModel = MockDecodable
    var url: URL? { "https://www.google.com" }
    var method: HTTPMethod { .get }
}
