# AutoThemeKit

AutoThemeKit is a **SwiftUI theme engine** that provides:

* Manual **Light / Dark toggle**
* User-customizable colors for **Light & Dark mode**
* Centralized `ThemeManager`
* `EnvironmentObject`-based propagation
* Clean, semantic color access (`colors.background`, `colors.text`)
* Persistent user preferences

Designed for **real apps**, **UI kits**, and **Swift Packages**.

---

## Features

* Light / Dark mode toggle
* User can choose **any color** for text in Light & Dark mode
* Persistent theme & color storage
* No hardcoded UI colors
* SwiftUI-native
* Works with large modular projects

---

## Requirements

* iOS 15+
* SwiftUI

---

## Installation (Swift Package Manager)

1. Open Xcode
2. Go to **File → Add Packages…**
3. Enter the repository URL:

```
https://github.com/Excelsior-Technologies-Community/AutoThemeKit
```

4. Add the package to your app target

---

## Importing AutoThemeKit

In any SwiftUI file where you use the theme system:

```swift
import AutoThemeKit
```

---

## Step 1: Inject ThemeManager (MANDATORY)

You **must** inject `ThemeManager` at the app root.

### App Entry File

```swift
@main
struct DemoProjactApp: App {

    @StateObject private var themeManager = ThemeManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(themeManager)
                .preferredColorScheme(
                    themeManager.mode == .dark ? .dark : .light
                )
        }
    }
}
```

Why this is required:

* `ThemeManager` is used via `@EnvironmentObject`
* Without this, the app will crash at runtime

---

## Step 2: Use ThemeManager in Any View

```swift
@EnvironmentObject private var themeManager: ThemeManager
```

Get resolved colors:

```swift
let colors = themeManager.colors
```

---

## Full ContentView Example

```swift
import SwiftUI
import AutoThemeKit

struct ContentView: View {

    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        let colors = themeManager.colors

        ZStack {
            colors.background
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 32) {

                    ProfileHeaderView()
                        .environmentObject(themeManager)

                    Divider()
                        .background(colors.text.opacity(0.2))
                        .padding(.horizontal)

                    VStack(spacing: 24) {
                        ThemeToggleView()
                        ThemeCustomizationView()
                    }
                }
                .padding(.vertical, 32)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(ThemeManager.shared)
}
```

---

## Profile Header Example

```swift
public struct ProfileHeaderView: View {

    @EnvironmentObject private var themeManager: ThemeManager

    public init() {}

    public var body: some View {
        let colors = themeManager.colors

        VStack(spacing: 16) {

            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            colors.text.opacity(0.3),
                            colors.text.opacity(0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 100, height: 100)
                .overlay(
                    Text("NB")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(colors.text)
                )

            VStack(spacing: 8) {
                Text("Noman Belim")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(colors.text)

                Text("iOS Developer")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(colors.text.opacity(0.7))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(colors.text.opacity(0.1))
                    .cornerRadius(12)
            }
        }
        .padding()
    }
}
```

---

## Theme Toggle View (Light / Dark)

```swift
public struct ThemeToggleView: View {

    @EnvironmentObject private var themeManager: ThemeManager
    public init() {}

    public var body: some View {
        let colors = themeManager.colors

        VStack(alignment: .leading, spacing: 12) {
            Text("Appearance")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(colors.text)

            Toggle(
                "Dark Mode",
                isOn: Binding(
                    get: { themeManager.mode == .dark },
                    set: { _ in themeManager.toggleMode() }
                )
            )
        }
        .padding()
    }
}
```

---

## Theme Customization (User Color Picker)

Users can select **any color** for Light & Dark text.

```swift
public struct ThemeCustomizationView: View {

    @EnvironmentObject private var themeManager: ThemeManager
    @State private var lightTextColor: Color = .black
    @State private var darkTextColor: Color = .white

    public init() {}

    public var body: some View {

        VStack(spacing: 16) {

            ColorPicker("Light Mode Text", selection: $lightTextColor)
                .onChange(of: lightTextColor) {
                    themeManager.setLightTextColor($0)
                }

            ColorPicker("Dark Mode Text", selection: $darkTextColor)
                .onChange(of: darkTextColor) {
                    themeManager.setDarkTextColor($0)
                }
        }
        .padding()
        .onAppear {
            lightTextColor = themeManager.theme.lightTextColor ?? .black
            darkTextColor = themeManager.theme.darkTextColor ?? .white
        }
    }
}
```

---

## If You Want Your Own UI Design

You **do not need to use the provided views**.

Just use:

```swift
@EnvironmentObject private var themeManager: ThemeManager
let colors = themeManager.colors
```

And design freely:

```swift
Text("Hello")
    .foregroundColor(colors.text)

ZStack {
    colors.background
}
```

---

## Important Rules

* Always inject `ThemeManager` at app root
* Always use `@EnvironmentObject`
* Do NOT hardcode colors
* Always use `colors.background` and `colors.text`

---

## Summary

AutoThemeKit gives you:

* Central theme control
* User-driven customization
* Clean SwiftUI architecture
* Production-ready theming

No hacks. No magic. Just correct SwiftUI design.

---
  