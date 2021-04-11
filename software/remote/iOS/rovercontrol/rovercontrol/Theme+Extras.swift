//
//  Theme+Extras.swift
//  rovercontrol
//
//  Created by Jeanette Müller on 11.04.21.
//

import Foundation
import JxThemeManager

extension ThemeManager {
    
    func applyTheme(_ t: ThemeProtocol, asTemporary temporary: Bool = false) {
        let theme = t as! Theme
        if !temporary {
            self.theme = theme
        }
        ThemeManager.applicationApplyTheme(theme: theme, asTemporary: temporary)
        
        if !temporary {
            
            UserDefaults.standard.set(theme.rawValue, forKey: SelectedThemeKey)
            UserDefaults.standard.synchronize()
            
            //ThemeManager.updateAppIcon(theme.iconName)
        }
        
        #if os(OSX) || os(iOS)
        // compiles for OS X and iOS
        UINavigationBar.appearance().barStyle = theme.barStyle
        UIToolbar.appearance().barStyle = theme.barStyle
        UISearchBar.appearance().barStyle = theme.barStyle
        UITabBar.appearance().barStyle = UIBarStyle.black
        
        UIToolbar.appearance().tintColor = theme.color
        
        UITableView.appearance().separatorColor = theme.titleTextColor
        UITableView.appearance().separatorColor = theme.tableViewSeparatorColor
        
        UISwitch.appearance().tintColor = theme.color
        UISwitch.appearance().onTintColor = theme.color
        #elseif os(tvOS)
        // compiles for TV OS
        #elseif os(watchOS)
        // compiles for Apple watch
        #endif
        
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().isTranslucent = false
        
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: theme.titleTextColor,
            NSAttributedString.Key.font: UIFont(name: theme.fontRegular, size: 17) as Any]
        
        UITextField.appearance().keyboardAppearance = theme.keyboardStyle
        
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().barTintColor = theme.tableBackgroundColor
        
        UINavigationBar.appearance().setBackgroundImage(theme.navigationBackgroundImage, for: .default)
        UITabBar.appearance().backgroundImage = theme.tabBarBackgroundImage
        
        UITabBar.appearance().tintColor = theme.highlight
        UINavigationBar.appearance().tintColor = theme.highlight
        
        
        UITableViewCell.appearance().backgroundColor = UIColor.clear
        UITableViewCell.appearance().tintColor = theme.titleTextColor
        
        if #available(iOS 9.0, *) {
            UILabel.appearance(whenContainedInInstancesOf: [UITextField.self]).textColor = theme.textFieldPlaceholderTextColor
        }
        
        UILabel.appearance().backgroundColor = UIColor.clear
        
        UIBarButtonItem.appearance().tintColor = theme.color
        
        UIProgressView.appearance().backgroundColor = theme.subtitleTextColor
        UIProgressView.appearance().tintColor = theme.color
        
        UITextField.appearance().backgroundColor = theme.textFieldBackground
        UITextField.appearance().textColor = theme.titleTextColor
        
        UITextView.appearance().backgroundColor = theme.textFieldBackground
        UITextView.appearance().textColor = theme.titleTextColor
        
    }
    
    static func applicationApplyTheme(theme: Theme, asTemporary temporary: Bool) {
        
        let sharedApplication = UIApplication.shared
        
        sharedApplication.delegate?.window??.tintColor = theme.color
    }
    
    static func refreshTheme() {
        
        for window in UIApplication.shared.windows {
            if let rootVC = window.rootViewController as? MainVC {
                rootVC.updateAppearance()
            }
            for view in window.subviews {
                view.removeFromSuperview()
                window.addSubview(view)
            }
        }
    }
    
    static func styleNavigationController(_ nav: UINavigationController) {
        let theme = ThemeManager.currentTheme()
        nav.isNavigationBarHidden = true
        nav.view.backgroundColor = .clear
        nav.navigationBar.barStyle = theme.barStyle
        nav.navigationBar.shadowImage = UIImage()
        nav.navigationBar.setBackgroundImage(UIImage(), for: .default)
        nav.navigationBar.isTranslucent = false
        nav.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: theme.titleTextColor,
            NSAttributedString.Key.font: UIFont(name: theme.fontRegular, size: 17) as Any]
        
        nav.navigationBar.setBackgroundImage(theme.navigationBackgroundImage, for: .default)
        nav.navigationBar.tintColor = theme.highlight
    }
}

