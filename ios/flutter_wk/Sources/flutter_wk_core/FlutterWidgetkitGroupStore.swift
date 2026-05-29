import Foundation

public enum FlutterWidgetkitGroupStoreError: Error, Equatable {
  case missingAppGroup
  case invalidAppGroup(String)
}

public struct FlutterWidgetkitGroupStore {
  public typealias UserDefaultsProvider = (String) -> UserDefaults?

  private let provider: UserDefaultsProvider

  public init(provider: @escaping UserDefaultsProvider = UserDefaults.init(suiteName:)) {
    self.provider = provider
  }

  public func sharedDefaults(for appGroup: String) throws -> UserDefaults {
    guard !appGroup.isEmpty else {
      throw FlutterWidgetkitGroupStoreError.missingAppGroup
    }

    guard let sharedDefaults = provider(appGroup) else {
      throw FlutterWidgetkitGroupStoreError.invalidAppGroup(appGroup)
    }

    return sharedDefaults
  }
}