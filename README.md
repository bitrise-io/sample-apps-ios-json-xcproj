# Bitrise sample iOS app (JSON `project.xcproj` format)

A minimal SwiftUI iOS app whose Xcode project uses Apple's **JSON project format**: the
`.xcodeproj` bundle keeps its name but holds `project.xcproj` instead of `project.pbxproj`.

It exists as a fixture for teaching Bitrise tooling (`go-xcode`, project-scanner, the Xcode
steps) to read and write that format. The format is described by
[apple/xcode-project-format](https://github.com/apple/xcode-project-format).

## Project layout

- SwiftUI app in an `.xcodeproj` holding `project.xcproj` (JWCC: JSON with comments and
  trailing commas).
- Three targets:
  - `sample-apps-ios-json-xcproj`, the app (one screen: a slider, a "Hit me" button and a score).
  - `sample-apps-ios-json-xcprojTests`, unit tests, written with Swift Testing.
  - `sample-apps-ios-json-xcprojUITests`, UI tests, written with XCTest.
- Swift 6 language mode, SwiftUI, and the Observation framework.
- iOS deployment target 27.2.
- Created with Xcode 27.2 beta (27B5028f). Only Xcode 27.2 and newer can write this format;
  Xcode 27.0 cannot.

## What the project file exercises

The point of this fixture is the shape of `project.xcproj`, not the app code. It currently
covers:

- **Synchronized folders.** All three source directories are `"kind": "folder"` entries with
  `target-membership`, not `group` trees of individual file references. This is the Xcode 16+
  model and the only form this project uses for sources.
- **Conditional build settings.** The project-wide `build-settings` uses `KEY[config=Debug]` and
  `KEY[config=Release]` keys instead of a per-configuration settings dict. The format has no
  per-configuration dict at all, so this is the only way per-configuration values appear.
- **Array setting values.** `LD_RUNPATH_SEARCH_PATHS` and `GCC_PREPROCESSOR_DEFINITIONS` are
  arrays, so a reader cannot assume every setting is a string.
- **Dense product types.** `application`, `bundle.unit-test` and `bundle.ui-testing`, which are
  the full identifiers with the `com.apple.product-type.` prefix stripped.
- **A `group` reference tree.** The `Products` group resolves each target's `product` by name
  path, using the `<PRODUCTS>` path base.
- **Local target dependencies** in the bare-string form, plus `test-host-target`.
- **Asset catalogs reached in two ways.**
  - `Assets.xcassets` (with `AppIcon.appiconset` and `AccentColor.colorset`) sits in the app's
    synchronized folder, so no file entry names it.
  - `Branding/Icons/Icons.xcassets` (with `AlternateIcon.appiconset`) is an explicit file
    reference inside two nested `group` entries, `Branding` and `Icons`, each with its own
    `path`. It is not at the project root. Its `target-membership` names a build phase,
    `sample-apps-ios-json-xcproj/resources`, where the synchronized folders name only the target.
- **Project-wide `default-configuration`**, set to `Release`. There is no per-target default.
- **Automatic code signing** with a `DEVELOPMENT_TEAM` build setting.
- **Autocreated schemes.** No scheme is checked in and `WorkspaceSettings.xcsettings` is absent.

## App and tests

`GuessingGame` is an `@Observable` class holding a target value, a round number and a score.
`check(guess:)` scores a round as `100 - abs(target - guess)` and adds it to the total. The target
is passed into the initialiser and into `startNewRound(targetValue:)`, defaulting to a random
value, so tests pin it and never have to stub randomness.

`ContentView` is SwiftUI, holding the game in `@State`. Every control carries an
`.accessibilityIdentifier`, which is what the UI tests query on; SwiftUI's generated labels are not
stable enough to key on.

Three Swift Testing cases cover the scoring, including one with a display name and one in a nested
`@Suite`. Two XCTest cases drive the app. The split is forced, not a preference: `XCUIApplication`
can only be driven from XCTest. It is also useful, because one run then reports results from both
frameworks.

The app target runs with `SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor`, so the model is main-actor
isolated. The test targets do not, so the suites are marked `@MainActor`, the nested one separately
because nested types do not inherit the outer suite's isolation.

Sources live in synchronized folders, so adding or removing Swift files never touches
`project.xcproj`. Only a build setting or a new target changes it.
