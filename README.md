
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
