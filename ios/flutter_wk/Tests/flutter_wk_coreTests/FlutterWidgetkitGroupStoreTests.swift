import XCTest
@testable import flutter_wk_core

final class FlutterWidgetkitGroupStoreTests: XCTestCase {
  func testSharedDefaultsPassesAppGroupToProviderExactlyOnce() throws {
    var receivedAppGroups: [String] = []
    let expectedDefaults = UserDefaults(suiteName: #function)!
    let store = FlutterWidgetkitGroupStore { appGroup in
      receivedAppGroups.append(appGroup)
      return expectedDefaults
    }

    let resolvedDefaults = try store.sharedDefaults(for: "group.com.example.widget")

    XCTAssertTrue(resolvedDefaults === expectedDefaults)
    XCTAssertEqual(receivedAppGroups, ["group.com.example.widget"])
  }

  func testSharedDefaultsThrowsForEmptyAppGroup() {
    let store = FlutterWidgetkitGroupStore { _ in
      XCTFail("Provider should not be called for an empty app group")
      return nil
    }

    XCTAssertThrowsError(try store.sharedDefaults(for: "")) { error in
      XCTAssertEqual(error as? FlutterWidgetkitGroupStoreError, .missingAppGroup)
    }
  }

  func testSharedDefaultsThrowsForUnknownAppGroup() {
    let store = FlutterWidgetkitGroupStore { _ in nil }

    XCTAssertThrowsError(try store.sharedDefaults(for: "group.invalid")) { error in
      XCTAssertEqual(
        error as? FlutterWidgetkitGroupStoreError,
        .invalidAppGroup("group.invalid")
      )
    }
  }

  func testSharedDefaultsPreservesInvalidAppGroupValueInError() {
    let store = FlutterWidgetkitGroupStore { appGroup in
      XCTAssertEqual(appGroup, "group.com.example.missing")
      return nil
    }

    XCTAssertThrowsError(try store.sharedDefaults(for: "group.com.example.missing")) { error in
      XCTAssertEqual(
        error as? FlutterWidgetkitGroupStoreError,
        .invalidAppGroup("group.com.example.missing")
      )
    }
  }

  func testSharedDefaultsReturnsResolvedSuite() throws {
    let expectedDefaults = UserDefaults(suiteName: #filePath)!
    let store = FlutterWidgetkitGroupStore { appGroup in
      XCTAssertEqual(appGroup, "group.valid")
      return expectedDefaults
    }

    let resolvedDefaults = try store.sharedDefaults(for: "group.valid")

    XCTAssertTrue(resolvedDefaults === expectedDefaults)
  }
}