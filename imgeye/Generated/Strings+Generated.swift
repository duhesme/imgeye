// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum Strings {

  public enum Favorites {
    public enum Navigation {
      /// Favorites
      public static let title = Strings.tr("Localizable", "Favorites.Navigation.Title")
    }
    public enum TableView {
      public enum Cell {
        public enum Deletion {
          public enum Alert {
            /// Are you sure you want to delete this photo from favorites?
            public static let message = Strings.tr("Localizable", "Favorites.TableView.Cell.Deletion.Alert.Message")
            /// Delete
            public static let title = Strings.tr("Localizable", "Favorites.TableView.Cell.Deletion.Alert.Title")
          }
        }
      }
      public enum SwipeAction {
        /// Delete
        public static let delete = Strings.tr("Localizable", "Favorites.TableView.SwipeAction.Delete")
      }
    }
  }

  public enum Feed {
    public enum Navigation {
      /// Feed
      public static let title = Strings.tr("Localizable", "Feed.Navigation.Title")
    }
    public enum Popup {
      /// Failed to download photos
      public static let downloadingFailed = Strings.tr("Localizable", "Feed.Popup.DownloadingFailed")
    }
  }

  public enum Popup {
    /// Added to favorites
    public static let addedToFavorites = Strings.tr("Localizable", "Popup.AddedToFavorites")
    /// Error saving image
    public static let imageNotSaved = Strings.tr("Localizable", "Popup.ImageNotSaved")
    /// Image saved to your photo library
    public static let imageSavedSuccesfuly = Strings.tr("Localizable", "Popup.ImageSavedSuccesfuly")
    /// Removed from favorites
    public static let removedFromFavorites = Strings.tr("Localizable", "Popup.RemovedFromFavorites")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension Strings {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
