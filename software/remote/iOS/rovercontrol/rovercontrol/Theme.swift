//
//  Theme.swift
//  rovercontrol
//
//  Created by Jeanette Müller on 11.04.21.
//

import UIKit
import JxThemeManager

enum Theme: Int, ThemeProtocol {
    
    case RoverControl
    
    var name: String { return "arika" }
    var readableName: String { return "Arika" }
    var cssFileName: String{ return "arika" }
    var iconName: String? { return nil }
    var appIcon: UIImage { return UIImage() }
    
    // MARK: - Fonts
    var fontUltraLight: String {
        return "HelveticaNeue-Ultralight"
    }
    var fontLight: String {
        return "HelveticaNeue-Light"
    }
    var fontRegular: String {
        return "HelveticaNeue"
    }
    var fontMedium: String {
        return "HelveticaNeue-Medium"
    }
    var fontBold: String {
        return "HelveticaNeue-Bold"
    }
    
    var fontSizeLargeTitle: CGFloat { return 26 }
    
    var fontSizeTitle: CGFloat { return 24 }
    
    var fontSizeContenTitle: CGFloat { return 16 }
    
    var fontSizeContentLarge: CGFloat { return 14 }
    
    var fontSizeContentMedium: CGFloat { return 12 }
    
    var fontSizeContentSmall: CGFloat { return 10 }
    
    func getFont(name:String, size:CGFloat) -> UIFont? {
        
        
        guard let customFont = UIFont(name: name, size: size) else {
            fatalError("""
        Failed to load the "CustomFont-Light" font.
        Make sure the font file is included in the project and the font name is spelled correctly.
        """
            )
        }
        
        var style:UIFont.TextStyle // = UIFont.TextStyle.body
        
        switch size {
        case self.fontSizeLargeTitle:
            style = .largeTitle
        case self.fontSizeTitle:
            style = .title1
        case self.fontSizeContenTitle:
            style = .title2
        case self.fontSizeContentLarge:
            style = .body
        case self.fontSizeContentMedium:
            style = .caption1
        case self.fontSizeContentSmall:
            style = .caption2
            
        default:
            style = UIFont.TextStyle.body
        }
        
        //return UIFont.preferredFont(forTextStyle: style)
        
        //        return UIFontMetrics.default.scaledFont(for: customFont)
        return UIFontMetrics(forTextStyle: style).scaledFont(for: customFont)
        
        //return customFont.scaled
    }
    
    // MARK: - Colors
    
    var backgroundColor: UIColor { return UIColor.black }
    var contentBackgroundColor: UIColor { return UIColor.black }
    
    var titleTextColor: UIColor { return .white }
    var subtitleTextColor: UIColor { return .lightGray }
    
    var color: UIColor { return UIColor(red:0.95, green:0.69, blue:0.41, alpha:1.00)}
    var highlight: UIColor { return UIColor(red:0.95, green:0.69, blue:0.41, alpha:1.00)}
    var highlightTextColor: UIColor { return .white }
    var warnColor: UIColor { return .yellow }
    var errorColor: UIColor { return .red }
    var shadowColor: UIColor  { return .black }
    var shadowHighlightColor: UIColor { return .red }
    
    var actionButtonsColor: UIColor { return .yellow }
    var textFieldBackground: UIColor { return .black }
    var textFieldPlaceholderTextColor: UIColor { return .lightGray }
    
    var tableViewHeadlineBackgroundColor: UIColor { return .yellow }
    var tableViewSeparatorColor: UIColor { return .yellow }
    var tableBackgroundColor: UIColor { return self.backgroundColor }
    
    var tabBarBackgroundImage: UIImage? { return nil }
    var tabBarBackgroundColor: UIColor { return .black }
    var tabBarIconColor: UIColor { return .white }
    
    // MARK: - Alpha
    var imageAlpha: CGFloat { return 1.0 }
    var headerBackgroundAlphaPerPixel: CGFloat  { return 1.0 }
    
    // MARK: - Sizes
    var cornerRadiusPercent: CGFloat { return 10 }
    var contentInsetFromDisplayBorder: CGFloat { return 10 }
    
    var tableViewCellDefaultHeight: CGFloat { return 40 }
    var tableViewHeadlineHeight: CGFloat { return 30 }
    
    var minimalBorderWidth: CGFloat { return 1 }
    
    // MARK: - Images
    var backgroundImage: UIImage { return UIImage() }
    var navigationBackgroundImage: UIImage? { return nil }
    var fallbackImageName: String { return "fallback" }
    var fallbackImage: UIImage { return UIImage() }
    
    // MARK: - System
    var statusbarStyle: UIStatusBarStyle { return .lightContent }
    var barStyle: UIBarStyle { return .black }
    var artworkContentMode: UIView.ContentMode { return .scaleAspectFill }
    var artworkLargeContentMode: UIView.ContentMode{ return .scaleAspectFit }
    var isLight: Bool { return false }
    var keyboardStyle: UIKeyboardAppearance {return .dark}
    
    
    
}

