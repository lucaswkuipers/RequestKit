import XCTest
@testable import RESTKit

final class RESTKitTests: XCTestCase {
    func test() {
        Task {
            await MockRequest().send()
        }
    }
}

struct MockDecodable: Decodable {
    let name: String
}

struct MockRequest: Request {
    typealias RemoteModel = MockDecodable
    var url: URL? { "https://www.google.com" }
    var method: HTTPMethod { .get }
}
