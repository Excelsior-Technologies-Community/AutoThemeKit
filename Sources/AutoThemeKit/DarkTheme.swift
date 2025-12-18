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

// MARK: - Theme Customization
public struct ThemeCustomizationView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var lightTextColor: Color = .black
    @State private var darkTextColor: Color = .white
    @State private var showResetAlert = false
    // ✅ ADD THIS
    public init() {}

    public  var body: some View {
        let colors = themeManager.colors
        
        VStack(alignment: .leading, spacing: 12) {
            Text("Customize Colors")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(colors.text)
                .padding(.horizontal, 24)
            
            VStack(spacing: 16) {
                // Light Mode Color
                ColorPickerRow(
                    icon: "sun.max.fill",
                    iconColor: .orange,
                    title: "Light Mode Text",
                    color: $lightTextColor
                )
                .onChange(of: lightTextColor) { newColor in
                    themeManager.setLightTextColor(newColor)
                }
                
                Divider()
                    .padding(.horizontal, 16)
                
                // Dark Mode Color
                ColorPickerRow(
                    icon: "moon.fill",
                    iconColor: .blue,
                    title: "Dark Mode Text",
                    color: $darkTextColor
                )
                .onChange(of: darkTextColor) { newColor in
                    themeManager.setDarkTextColor(newColor)
                }
                
                // Reset Button
                Button(action: {
                    showResetAlert = true
                }) {
                    HStack {
                        Image(systemName: "arrow.counterclockwise")
                        Text("Reset to Defaults")
                            .font(.system(size: 15, weight: .medium))
                    }
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(12)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
            .padding(.vertical, 16)
            .background(colors.text.opacity(0.05))
            .cornerRadius(16)
            .padding(.horizontal, 20)
        }
        .onAppear {
            lightTextColor = themeManager.theme.lightTextColor ?? .black
            darkTextColor = themeManager.theme.darkTextColor ?? .white
        }
        .alert("Reset Colors", isPresented: $showResetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                withAnimation {
                    lightTextColor = .black
                    darkTextColor = .white
                    themeManager.setLightTextColor(.black)
                    themeManager.setDarkTextColor(.white)
                }
            }
        } message: {
            Text("This will reset all custom colors to their default values.")
        }
    }
}
// MARK: - Theme Toggle
public struct ThemeToggleView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    public  var body: some View {
        let colors = themeManager.colors
        
        VStack(alignment: .leading, spacing: 12) {
            Text("Appearance")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(colors.text)
                .padding(.horizontal, 24)
            
            HStack {
                Label {
                    Text("Dark Mode")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(colors.text)
                } icon: {
                    Image(systemName: themeManager.mode == .dark ? "moon.fill" : "sun.max.fill")
                        .foregroundColor(themeManager.mode == .dark ? .blue : .orange)
                        .font(.system(size: 20))
                }
                
                Spacer()
                
                Toggle("", isOn: Binding(
                    get: { themeManager.mode == .dark },
                    set: { _ in
                        withAnimation(.easeInOut(duration: 0.3)) {
                            themeManager.toggleMode()
                        }
                    }
                ))
                .labelsHidden()
                .tint(.blue)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .background(colors.text.opacity(0.05))
            .cornerRadius(16)
            .padding(.horizontal, 20)
        }
    }
}
public struct ProfileHeaderView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    public  var body: some View {
        let colors = themeManager.colors
        
        VStack(spacing: 16) {
            // Avatar
            Circle()
                .fill(
                    LinearGradient(
                        colors: [colors.text.opacity(0.3), colors.text.opacity(0.1)],
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
                .shadow(color: colors.text.opacity(0.15), radius: 10, x: 0, y: 5)
            
            // Name & Title
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
 
