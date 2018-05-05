import XCTest
@testable import IDZSwiftSafePipe

final class IDZSwiftSafePipeTests: XCTestCase {
    /// Tests that it is possible to create a valid `SafePipe`.
    func testCreation() {
        let pipe = SafePipe()
        XCTAssertNotNil(pipe, "Successfully created `Pipe`.")
        
    }
    /// Test the file handles for a created `SafePipe` are valid.
    func testFileHandles() {
        let pipe = SafePipe()
        XCTAssertNotNil(pipe, "Successfully created `Pipe`.")
        XCTAssert(pipe!.fileHandleForReading.fileDescriptor >= 0, "Read file descriptor is valid.")
        XCTAssert(pipe!.fileHandleForWriting.fileDescriptor >= 0, "Read file descriptor is valid.")
    }
    /// Test that `SafePipe` behaves sensible in error condition.
    func testErrorCondition() {
        var pipes = [SafePipe]()
        while true {
            if let pipe = SafePipe() {
                pipes.append(pipe)
            }
            else {
                break
            }
        }
        XCTAssert(true, "Did not crash under error conditions")
        pipes.removeAll()
        let pipe = SafePipe()
        XCTAssert(pipe != nil, "Was able to recover by closing some pipes.")
    }


    static var allTests = [
        ("testCreation", testCreation),
        ("testFileHandles", testFileHandles),
        ("testErrorCondition", testErrorCondition)
    ]
}
