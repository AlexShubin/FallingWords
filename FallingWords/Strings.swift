// swiftlint:disable all
// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {

  internal enum GameScreen {
    /// Is that translation correct?
    internal static let header = L10n.tr("Localizable", "game_screen.header")
    /// Right!
    internal static let rightButton = L10n.tr("Localizable", "game_screen.right_button")
    /// Game
    internal static let title = L10n.tr("Localizable", "game_screen.title")
    /// Wrong
    internal static let wrongButton = L10n.tr("Localizable", "game_screen.wrong_button")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
