import Flutter
import UIKit
import WidgetKit

#if SWIFT_PACKAGE
import flutter_wk_core
#endif

/// Flutter plugin for Flutter WidgetKit
public class FlutterWidgetkitPlugin: NSObject, FlutterPlugin {
  /// Method channel name
  private static let methodChannelName = "ziqq.github/flutter_wk"

  private let store = FlutterWidgetkitGroupStore()

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: methodChannelName, binaryMessenger: registrar.messenger())
    let instance = FlutterWidgetkitPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  private func resolveSharedDefaults(appGroup: String, result: @escaping FlutterResult) -> UserDefaults? {
    do {
      return try store.sharedDefaults(for: appGroup)
    } catch FlutterWidgetkitGroupStoreError.missingAppGroup {
      result(
        FlutterError(
          code: "missing_app_group",
          message: "The appGroup argument must not be empty.",
          details: nil
        )
      )
      return nil
    } catch FlutterWidgetkitGroupStoreError.invalidAppGroup(let invalidAppGroup) {
      result(
        FlutterError(
          code: "invalid_app_group",
          message: "No shared UserDefaults suite exists for the provided app group.",
          details: invalidAppGroup
        )
      )
      return nil
    } catch {
      result(
        FlutterError(
          code: "app_group_error",
          message: "Failed to resolve the shared UserDefaults suite.",
          details: error.localizedDescription
        )
      )
      return nil
    }
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if call.method == "reload" {
      if #available(iOS 14.0, *) {
        #if arch(arm64) || arch(i386) || arch(x86_64)
          WidgetCenter.shared.reloadAllTimelines()
        #endif
      }
      result(nil)
      return
    } else if call.method == "reloadOfKind" {
      if #available(iOS 14.0, *) {
        if let args = call.arguments as? [String: Any],
          let ofKind = args["ofKind"] as? String
        {
          #if arch(arm64) || arch(i386) || arch(x86_64)
            WidgetCenter.shared.reloadTimelines(ofKind: ofKind)
          #endif
        }
      }

      result(nil)
      return
    } else if call.method == "read" {
      if let args = call.arguments as? [String: Any],
        let appGroup = args["appGroup"] as? String,
        let key = args["key"] as? String
      {
        guard let sharedDefaults = resolveSharedDefaults(appGroup: appGroup, result: result) else {
          return
        }

        let value = sharedDefaults.object(forKey: key)

        result(value)
        return
      }

      result(nil)
      return
    } else if call.method == "write" {
      if let args = call.arguments as? [String: Any],
        let appGroup = args["appGroup"] as? String,
        let key = args["key"] as? String,
        let value = args["value"]
      {
        guard let sharedDefaults = resolveSharedDefaults(appGroup: appGroup, result: result) else {
          return
        }

        sharedDefaults.set(value, forKey: key)

        result(value)
        return
      }

      result(nil)
      return
    } else if call.method == "remove" {
      if let args = call.arguments as? [String: Any],
        let appGroup = args["appGroup"] as? String,
        let key = args["key"] as? String
      {
        guard let sharedDefaults = resolveSharedDefaults(appGroup: appGroup, result: result) else {
          return
        }

        sharedDefaults.removeObject(forKey: key)

        result(true)
        return
      }
    }

    result(FlutterMethodNotImplemented)
  }
}