import XCTest
@testable import RESTKit

final class RESTKitTests: XCTestCase {
    func test() {
        if #available(iOS 13.0, *) {
            Task {
                await MockRequest().send()
            }
        } else {
            // Fallback on earlier versions
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
