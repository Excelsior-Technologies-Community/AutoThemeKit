import SwiftUI


import SwiftUI

// MARK: - Color Picker Row
public struct ColorPickerRow: View {

    private let icon: String
    private let iconColor: Color
    private let title: String
    @Binding private var color: Color

    // ✅ CORRECT PUBLIC INITIALIZER
    public init(
        icon: String,
        iconColor: Color,
        title: String,
        color: Binding<Color>
    ) {
        self.icon = icon
        self.iconColor = iconColor
        self.title = title
        self._color = color
    }

    public var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .foregroundColor(iconColor)
                .font(.system(size: 18))
                .frame(width: 24)

            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.primary.opacity(0.8))

            Spacer()

            ColorPicker("", selection: $color)
                .labelsHidden()
        }
        .padding(.horizontal, 16)
    }
}


// MARK: - Theme Manager
public final class ThemeManager: ObservableObject {
    @Published public private(set) var mode: ThemeMode = .light
    @Published public private(set) var theme: Theme = Theme()
    
    public static let shared = ThemeManager()
    
    private let modeKey = "theme.mode"
    private let lightColorKey = "theme.lightColor"
    private let darkColorKey = "theme.darkColor"
    
    private init() {
        load()
    }
    
    public func toggleMode() {
        mode = (mode == .light) ? .dark : .light
        save()
    }
    
    public func setLightTextColor(_ color: Color) {
        theme = Theme(
            lightTextColor: color,
            darkTextColor: theme.darkTextColor
        )
        saveColors()
    }
    
    public func setDarkTextColor(_ color: Color) {
        theme = Theme(
            lightTextColor: theme.lightTextColor,
            darkTextColor: color
        )
        saveColors()
    }
    
    public var colors: SemanticColors {
        theme.colors(for: mode)
    }
    
    private func save() {
        UserDefaults.standard.set(mode.rawValue, forKey: modeKey)
    }
    
    private func saveColors() {
        if let lightColor = theme.lightTextColor {
            if let data = try? NSKeyedArchiver.archivedData(withRootObject: UIColor(lightColor), requiringSecureCoding: false) {
                UserDefaults.standard.set(data, forKey: lightColorKey)
            }
        }
        if let darkColor = theme.darkTextColor {
            if let data = try? NSKeyedArchiver.archivedData(withRootObject: UIColor(darkColor), requiringSecureCoding: false) {
                UserDefaults.standard.set(data, forKey: darkColorKey)
            }
        }
    }
    
    private func load() {
        // Load mode
        if let raw = UserDefaults.standard.string(forKey: modeKey),
           let saved = ThemeMode(rawValue: raw) {
            mode = saved
        }
        
        // Load colors
        var lightColor: Color? = nil
        var darkColor: Color? = nil
        
        if let lightData = UserDefaults.standard.data(forKey: lightColorKey),
           let uiColor = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: lightData) {
            lightColor = Color(uiColor)
        }
        
        if let darkData = UserDefaults.standard.data(forKey: darkColorKey),
           let uiColor = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: darkData) {
            darkColor = Color(uiColor)
        }
        
        theme = Theme(lightTextColor: lightColor, darkTextColor: darkColor)
    }
}

// MARK: - Theme Models
public enum ThemeMode: String, Codable {
    case light
    case dark
}

public struct SemanticColors {
    public let background: Color
    public let text: Color
}

public struct Theme {
    public let lightTextColor: Color?
    public let darkTextColor: Color?
    
    public init(
        lightTextColor: Color? = nil,
        darkTextColor: Color? = nil
    ) {
        self.lightTextColor = lightTextColor
        self.darkTextColor = darkTextColor
    }
    
    public func colors(for mode: ThemeMode) -> SemanticColors {
        switch mode {
        case .light:
            return SemanticColors(
                background: .white,
                text: lightTextColor ?? .black
            )
        case .dark:
            return SemanticColors(
                background: .black,
                text: darkTextColor ?? .white
            )
        }
    }
}
