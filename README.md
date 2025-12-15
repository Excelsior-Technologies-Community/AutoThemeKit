
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
 ![IMG-1783](https://github.com/user-attachments/assets/18bb88e5-e6bb-4673-be63-0cecb00f9f98)

## Using a Custom Theme for Specific Text (Light & Dark Mode)

In many apps, you may want **some texts to use different colors** than the default theme.

Example requirement:

* Text: `Text("AutoThemeKit SwiftUI project")`
* Light Mode → **Green**
* Dark Mode → **Orange**

AutoThemeKit supports this using **semantic roles**.

---

## Step 1: Create a Custom Theme (Recommended in a New File)

Create a new file in your app:

```
AppThemes.swift
```

### AppThemes.swift

```swift
import SwiftUI
import AutoThemeKit

public enum AppThemes {

    public static let purpleYellow = Theme(
        light: SemanticColors(
            background: .white,
            primaryText: .orange,
            secondaryText: .orange,
            highlightText: .green,   // Light mode → Green
            inverseText: .white
        ),
        dark: SemanticColors(
            background: .black,
            primaryText: .blue,
            secondaryText: .blue,
            highlightText: .orange,  // Dark mode → Orange
            inverseText: .black
        )
    )
}
```

Here:

* `highlightText` is **green in light mode**
* `highlightText` is **orange in dark mode**
* System appearance decides which one is used

---

## Step 2: Use Default Theme + Custom Theme Together

You can safely use:

* **Default theme** for most UI
* **Custom theme** only for specific text

This is a recommended and common approach.

---

## Final ContentView Example (Default + Custom Theme Combined)

```swift
import SwiftUI
import AutoThemeKit

struct ContentView: View {

    @Environment(\.colorScheme) private var colorScheme

    // Default app theme
    let theme: Theme = .default

    var body: some View {

        let colors = theme.colors(for: colorScheme)
        let customTheme = AppThemes.purpleYellow.colors(for: colorScheme)

        ZStack {
            colors.background
                .ignoresSafeArea()

            VStack(spacing: 12) {

                // Uses default theme primary text
                Text("Noman Belim")
                    .foregroundColor(colors.primaryText)

                // Uses default theme highlight text
                Text("I am iOS Developer")
                    .foregroundColor(colors.highlightText)

                // Uses custom theme highlight text
                // Light mode → Green
                // Dark mode → Orange
                Text("AutoThemeKit SwiftUI project")
                    .foregroundColor(customTheme.highlightText)
            }
        }
    }
}

#Preview {
    ContentView()
}
```

---

## What Happens Automatically

| System Mode | Text Color |
| ----------- | ---------- |
| Light Mode  | Green      |
| Dark Mode   | Orange     |

No conditions
No if-else
No manual toggle

SwiftUI updates the UI automatically when the system theme changes.

---

## Key Concept to Remember

* **Theme** defines Light and Dark color meaning
* **Semantic role** decides which color is used
* Views never hardcode colors
* System controls Light / Dark mode

If a color looks wrong, check:

* Which semantic role is used
* Not the theme logic

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
 
