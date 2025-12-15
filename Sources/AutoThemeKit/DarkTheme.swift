import SwiftUI
import SwiftUI

// MARK: - Semantic Colors (roles, not actual meaning)
public struct SemanticColors {

    public let background: Color
    public let primaryText: Color
    public let secondaryText: Color
    public let highlightText: Color
    public let inverseText: Color

    public init(
        background: Color,
        primaryText: Color,
        secondaryText: Color,
        highlightText: Color,
        inverseText: Color
    ) {
        self.background = background
        self.primaryText = primaryText
        self.secondaryText = secondaryText
        self.highlightText = highlightText
        self.inverseText = inverseText
    }
}

// MARK: - Theme (Light + Dark mapping)
public struct Theme {

    public let light: SemanticColors
    public let dark: SemanticColors

    public init(light: SemanticColors, dark: SemanticColors) {
        self.light = light
        self.dark = dark
    }

    public func colors(for scheme: ColorScheme) -> SemanticColors {
        scheme == .dark ? dark : light
    }
}

// MARK: - Default Theme (Library gives ONE safe default)
public extension Theme {

    static let `default` = Theme(

        light: SemanticColors(
            background: .white,
            primaryText: .black,
            secondaryText: .blue,
            highlightText: .blue,
            inverseText: .white
        ),

        dark: SemanticColors(
            background: .black,
            primaryText: .white,
            secondaryText: .yellow,
            highlightText: .yellow,
            inverseText: .black
        )
    )
}

// MARK: - Theme Mode (ONLY Light / Dark)
public enum ThemeMode: String, Codable {
    case light
    case dark
}


 
// MARK: - Theme Manager (Engine)
public final class ThemeManager: ObservableObject {

    @Published public private(set) var mode: ThemeMode
    private let theme: Theme

    public static let shared = ThemeManager(theme: .default)

    private let storageKey = "app.theme.mode"

    private init(theme: Theme) {
        self.theme = theme
        let saved = UserDefaults.standard.string(forKey: storageKey)
        self.mode = ThemeMode(rawValue: saved ?? "") ?? .light
    }

    public func toggleMode() {
        mode = (mode == .light) ? .dark : .light
        UserDefaults.standard.set(mode.rawValue, forKey: storageKey)
    }

    public var colors: SemanticColors {
        mode == .light ? theme.light : theme.dark
    }
}
