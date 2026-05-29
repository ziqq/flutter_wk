# Contributing

## Validation Commands

Use the Makefile targets below while working on the package:

- `make test-dart` runs the package Dart tests.
- `make test-swift` runs the native Swift package tests in `ios/flutter_wk`.
- `make test-example` runs the example widget tests.
- `make test-ios-build` runs `pod install` for the example app and builds the iOS simulator app.
- `make test-native` runs the native Swift tests and the iOS simulator build.
- `make test-all` runs the Dart tests, native Swift tests, example widget tests, and the iOS simulator build.

## Notes

- Run commands from the repository root.
- `make test-ios-build`, `make test-native`, and `make test-all` require macOS with Xcode and CocoaPods installed.
- If CocoaPods integration gets out of sync after iOS changes, rerun `make test-ios-build`.