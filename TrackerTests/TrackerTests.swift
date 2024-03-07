import XCTest
import SnapshotTesting
@testable import Tracker

final class AlpabetTests: XCTestCase {
    func testViewController() {
        let vc = TrackersViewController()
        
        assertSnapshot(matching: vc, as: .image)
        
    }
}
