import XCTest
@testable import WebBrowser

final class WebBrowserTests: XCTestCase {
    /// Integration test. This will open Google in your browser
    func testExample() {
        do {
            try open(url: URL(string: "http://google.com/")!)
        } catch {
            XCTFail("Unexpected error \(error)")
        }
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
