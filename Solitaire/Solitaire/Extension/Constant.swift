//
//  Constant.swift
//  SudokuUIKit
//
//  Created by Smit Gandhi on 09/04/25.
//

import UIKit

public struct AppConstants {
    enum difficultyLevel: Int {
        case easy = 30
        case medium = 40
        case hard = 50
    }
    // MARK: - App Configurations
    struct AppConfigurations {

        static var removeCellCounts: difficultyLevel = .easy
        static var isDarkModeEnabled: Bool = false
        static var isSoundEnable: Bool = false
        
    }
    
    // MARK: - App Environemnts
    //Note:- Please add here App Environemnts
    enum appEnvironments : String{
        case Dev            = "com.game.solitaire.dev"
        case Live           = ""
    }
    
   
    
    // MARK: - File Names
    struct FileNames {
        
        struct StoryboardNames {
            
            static let REGISTRATION = "Registration"
            static let MAIN = "Main"
            static let HOME = "Home"
        }
        
        struct XibNames {
            
            // MARK: Home Screen
            static let HOME_VIEW_PROFILE_INTRO_XIB = "HomeViewProfileIntroTableViewCell"
            
            // MARK: SignUpLogin Screen
            static let SIGNUP_LOGIN_VIEW_XIB = "SignUpLogin"
            
            //MARK: Home Screen
            static let MORE_VIEW_TABLECELL_XIB = "MoreTableViewCell"
            static let COLLECTION_VIEW_LOADER_XIB = "CollectionViewLoaderCell"
            
            // MARK: SignUpLogin Screen
            static let NO_NETWORK_VIEW_XIB = "NoNetworkView"
        }
    }
    
    
    
    //MARK: - Colors
    class Colors {

        //App Color Set
        static let AppWhite             = UIColor(hex: "#FFFFFF")
        static let AppBlack             = UIColor(hex: "#000000")
        static let TabColor             = UIColor.black.withAlphaComponent(0.8)
        static var BackGround           = AppConstants.AppConfigurations.isDarkModeEnabled ? UIColor(hex: "#EFEFE6") : UIColor(hex: "#EFEFE6")
        static var Accent               = AppConstants.AppConfigurations.isDarkModeEnabled ? UIColor(hex: "#FFAB91") : UIColor(hex: "#FFC107")
        static var Highlight            = AppConstants.AppConfigurations.isDarkModeEnabled ? UIColor(hex: "#FFAB91") : UIColor(hex: "#FF7043")
        static var Text                 = AppConstants.AppConfigurations.isDarkModeEnabled ? UIColor(hex: "#FAFAFA") : UIColor(hex: "#212121")
        static var PrimaryButton             = AppConstants.AppConfigurations.isDarkModeEnabled ? UIColor(hex: "#FF784B") : UIColor(hex: "#FF784B")
    }
    
    //MARK: - Device
    struct Device {
        
        //Device Height-Width
        static let screenWidth  : CGFloat = UIScreen.main.bounds.size.width
        static let screenHeight : CGFloat = UIScreen.main.bounds.size.height
        
    }
    
    //MARK:- Fonts
    struct Fonts {
        
        static func getSizeInRationaleWith375(_ size : Float ) -> CGFloat{
            return CGFloat((Float(AppConstants.Device.screenWidth) * size)/375)
        }
    
        //MARK:- Font Name
        struct FontName {
            
//            Marker Felt
//            == MarkerFelt-Thin
//            == MarkerFelt-Wide
            
            static let MarkerFeltThin       = "MarkerFelt-Thin"
            static let MarkerFeltWide       = "MarkerFelt-Wide"
        }
        
        //Common App Fonts
        static let MarkerFeltThin_12    = UIFont(name: FontName.MarkerFeltThin, size: getSizeInRationaleWith375(12))
        static let MarkerFeltThin_16    = UIFont(name: FontName.MarkerFeltThin, size: getSizeInRationaleWith375(16))
        static let MarkerFeltThin_18    = UIFont(name: FontName.MarkerFeltThin, size: getSizeInRationaleWith375(18))
        static let MarkerFeltThin_20    = UIFont(name: FontName.MarkerFeltThin, size: getSizeInRationaleWith375(20))
        static let MarkerFeltThin_22    = UIFont(name: FontName.MarkerFeltThin, size: getSizeInRationaleWith375(22))
        
        static let MarkerFeltWide_12    = UIFont(name: FontName.MarkerFeltWide, size: getSizeInRationaleWith375(12))
        static let MarkerFeltWide_14    = UIFont(name: FontName.MarkerFeltWide, size: getSizeInRationaleWith375(14))
        static let MarkerFeltWide_16    = UIFont(name: FontName.MarkerFeltWide, size: getSizeInRationaleWith375(16))
        static let MarkerFeltWide_18    = UIFont(name: FontName.MarkerFeltWide, size: getSizeInRationaleWith375(18))
        static let MarkerFeltWide_20    = UIFont(name: FontName.MarkerFeltWide, size: getSizeInRationaleWith375(20))
        static let MarkerFeltWide_22    = UIFont(name: FontName.MarkerFeltWide, size: getSizeInRationaleWith375(22))
        
    }
    
}
