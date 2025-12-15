
# AutoThemeKit

AutoThemeKit is a lightweight SwiftUI library that automatically adapts your app’s UI to the **system Light / Dark mode** and lets developers **fully control colors per text, per screen, and per mode** using **semantic color roles**.

The library does **not** add any toggle buttons.
It follows the iPhone’s system appearance settings automatically.

---

## Features

* Follows iOS system Light / Dark mode automatically
* No manual toggle or state management required
* Semantic color roles (not hardcoded colors)
* Developer decides colors for Light and Dark mode
* Different screens can use different themes
* SwiftUI native
* iOS 15+

---

## Requirements

* iOS 15 or later
* SwiftUI

---

## Installation (Swift Package Manager)

### Step 1: Add Dependency

1. Open your Xcode project
2. Go to **File → Add Packages…**
3. Enter the repository URL:

```
https://github.com/Excelsior-Technologies-Community/AutoThemeKit
```

4. Select the latest version
5. Add the package to your app target

---

## Importing the Library

In any SwiftUI file where you want to use themes:

```swift
import AutoThemeKit
```

---

## Basic Usage (Default Theme)

AutoThemeKit provides a default theme that already supports Light and Dark mode.

### Step 1: Read system color scheme

```swift
@Environment(\.colorScheme) private var colorScheme
```

---

### Step 2: Choose a theme

```swift
let theme: Theme = .default
```

---

### Step 3: Resolve colors for current mode

```swift
let colors = theme.colors(for: colorScheme)
```

---

### Full ContentView Example (Default Theme)

```swift
import SwiftUI
import AutoThemeKit

struct ContentView: View {

    @Environment(\.colorScheme) private var colorScheme

    // App chooses which theme to use
    let theme: Theme = .default

    var body: some View {

        let colors = theme.colors(for: colorScheme)

        ZStack {
            colors.background
                .ignoresSafeArea()

            VStack(spacing: 12) {

                Text("Noman Belim")
                    .foregroundColor(colors.primaryText)

                Text("I am iOS Developer")
                    .foregroundColor(colors.highlightText)
            }
        }
    }
}

#Preview {
    ContentView()
}
```

---

## Creating Your Own Theme (Recommended Way)

If you want custom colors, create a **new file** in your app.

### Recommended File Name

```
AppThemes.swift
```

---

### Example: Custom Purple / Yellow Theme

```swift
import SwiftUI
import AutoThemeKit

public enum AppThemes {

    public static let purpleYellow = Theme(
        light: SemanticColors(
            background: .white,
            primaryText: .orange,
            secondaryText: .orange,
            highlightText: .green,     // Light mode color
            inverseText: .white
        ),
        dark: SemanticColors(
            background: .black,
            primaryText: .blue,
            secondaryText: .blue,
            highlightText: .orange,    // Dark mode color
            inverseText: .black
        )
    )
}
```

Here:

* Light mode highlight text is green
* Dark mode highlight text is orange
* System decides which mode is active

---

## Using Your Custom Theme in ContentView

You only change **one line** in your view.

### Updated ContentView Using Custom Theme

```swift
import SwiftUI
import AutoThemeKit

struct ContentView: View {

    @Environment(\.colorScheme) private var colorScheme

    // Use your custom theme
    let theme: Theme = AppThemes.purpleYellow

    var body: some View {

        let colors = theme.colors(for: colorScheme)

        ZStack {
            colors.background
                .ignoresSafeArea()

            VStack(spacing: 12) {

                Text("Noman Belim")
                    .foregroundColor(colors.primaryText)

                Text("I am iOS Developer")
                    .foregroundColor(colors.highlightText)
            }
        }
    }
}
```

No other changes are required.

---

## Semantic Color Roles Explained

| Role          | Usage                       |
| ------------- | --------------------------- |
| background    | Screen background           |
| primaryText   | Main text                   |
| secondaryText | Supporting text             |
| highlightText | Emphasized text             |
| inverseText   | Text on colored backgrounds |

Views never use raw colors.
They only use semantic roles.

---

## How It Works Internally

* iOS controls Light / Dark mode
* SwiftUI provides `ColorScheme`
* AutoThemeKit maps Light / Dark to your colors
* UI updates automatically when system mode changes

No state, no storage, no toggle button.

---

## Best Practices

* Keep themes in a separate file (AppThemes.swift)
* Use semantic roles consistently
* Do not hardcode colors in views
* Let the system control Light / Dark mode
 
