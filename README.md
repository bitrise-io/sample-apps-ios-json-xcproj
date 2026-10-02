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
  - `sample-apps-ios-json-xcproj`, the app (a single "Hello, world!" screen).
  - `sample-apps-ios-json-xcprojTests`, unit-test bundle.
  - `sample-apps-ios-json-xcprojUITests`, UI-test bundle.
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
- **An asset catalog** (`Assets.xcassets` with `AppIcon.appiconset` and `AccentColor.colorset`)
  reachable only through a synchronized folder, not through a resources build phase.
- **Project-wide `default-configuration`**, set to `Release`. There is no per-target default.
- **Automatic code signing** with a `DEVELOPMENT_TEAM` build setting.

## Not covered yet

Known gaps, listed so nobody assumes coverage that is not here:

- No **shared scheme**. Xcode auto-creates the scheme, so nothing resolves a scheme by name from
  a clean checkout.
- No **manual code signing**, so no `legacy-team-id` or `legacy-provisioning-style` keys.
- No `specialized-configurations`, `required-capabilities`, `packages` or `imported-products`.
- No **app clip** or **framework** target, and no app extension.
- No reference by `id:`, and no `FilePath` base other than `<PRODUCTS>`.
