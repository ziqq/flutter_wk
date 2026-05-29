# Roadmap

`flutter_wk` is intentionally a low-level bridge for WidgetKit and App Group communication.
It does not try to generate widgets, styles, or SwiftUI layouts from Dart.

The package can still grow around that core. The list below captures the highest-value gaps identified while comparing `flutter_wk` with a richer reference package structure.

### Priority 1: Better onboarding for native widget extensions

- Add a dedicated setup guide for creating the iOS Widget Extension target.
- Document the exact App Group wiring between the app target and the widget extension.
- Ship a clearer SwiftUI reference implementation for reading shared data from `UserDefaults`.

Why this is first: the plugin API is already small and usable, but setup friction remains the main failure point for new adopters.

### Priority 2: A small optional facade above the bridge

- Add an opt-in higher-level Dart facade for common widget data flows.
- Keep the existing `WidgetKit` API as the stable low-level contract.
- Limit the facade to serialization and ergonomics, not widget rendering.

Why this is second: a thin convenience layer can reduce app boilerplate without turning the package into a full widget framework.

### Priority 3: Shared config and example assets

- Add a documented JSON payload convention for widget data.
- Provide example assets and sample decoding patterns for SwiftUI widgets.
- Keep config support optional so simple key-value usage stays lightweight.

Why this is third: configuration helps larger integrations, but should not complicate the package's base use case.

### Priority 4: Broader native examples and validation

- Expand the example app and widget extension scenarios.
- Add more native-side tests for storage and widget reload flows.
- Cover migration paths for both CocoaPods and Swift Package Manager consumers.

Why this is fourth: the package already has solid core contract tests, so the next leverage comes from examples and integration confidence.

### Out of scope for now

- Building SwiftUI widget views from Dart-side style classes.
- Shipping a large design-system layer inside the plugin.
- Adding event channels or extra dependencies without a concrete end-to-end use case.

These are valid product directions, but they increase surface area faster than they improve the plugin's core reliability.

### Reference notes

- Use richer widget packages as references for docs, example structure, and configuration ideas.
- Do not copy broader APIs unless they are backed by tests, real native behavior, and a clear maintenance story.
- Prefer `flutter_wk`'s current model: a strict bridge with explicit native ownership of the widget UI.