import XCTest
import SnapshotTesting
@testable import Tracker

final class AlpabetTests: XCTestCase {
    func testLigthTrackersViewController() throws {
        let vc = TabBarController()
        assertSnapshot(
            matching: vc,
            as: .image(
                traits: .init(
                    userInterfaceStyle: .light
                )
            )
        )
    }
    
    func testDarkTrackersViewController() throws {
        let vc = TabBarController()
        assertSnapshot(
            matching: vc,
            as: .image(
                traits: .init(
                    userInterfaceStyle: .dark
                )
            )
        )
    }
}
