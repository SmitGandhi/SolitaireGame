//
//  UIButton+Extension.swift
//  CSC
//
//  Created by Nitesh on 21/04/20.
//  Copyright © 2020 ITC Infotech India Ltd. All rights reserved.
//

import UIKit

extension UIButton{
    
    override open func awakeFromNib() {
        
        super.awakeFromNib()
        
        setFontSize()
    }
    
    func setFontSize() {
        
        /*
        switch UIDevice().type {
            
        case .iPhoneSE, .iPhone5, .iPhone5S, .iPhone5C:
            self.titleLabel?.font = self.titleLabel?.font?.withSize((self.titleLabel?.font?.pointSize ?? 10.0) - 3)
            
        case .iPhone6, .iPhone6S, .iPhone7, .iPhone8:
            self.titleLabel?.font = self.titleLabel?.font?.withSize((self.titleLabel?.font?.pointSize ?? 10.0))
            
        case .iPhone6plus, .iPhone6Splus, .iPhone7plus, .iPhone8plus:
            self.titleLabel?.font = self.titleLabel?.font?.withSize((self.titleLabel?.font?.pointSize ?? 10.0))
            
        case .iPhoneX, .iPhoneXR, .iPhoneXS, .iPhoneXSMax, .iPhone11, .iPhone11Pro, .iPhone11ProMax:
            self.titleLabel?.font = self.titleLabel?.font?.withSize((self.titleLabel?.font?.pointSize ?? 10.0) + 1)
            
        default:
            self.titleLabel?.font = self.titleLabel?.font?.withSize((self.titleLabel?.font?.pointSize ?? 10.0) + 2)
            
        }
        */
    }
    
    func appPrimaryButton(isEnable:Bool, title:String, titleFont:UIFont) {
        self.backgroundColor = isEnable ? AppConstants.Colors.PrimaryButton : AppConstants.Colors.PrimaryButton
        self.isUserInteractionEnabled = isEnable
        self.setTitleColor(AppConstants.Colors.AppWhite, for: .normal)
        self.titleLabel?.font = titleFont
        self.layer.cornerRadius = self.frame.height/2;
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFit

        
        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineHeightMultiple = 1.18
        paragraphStyle.alignment = .center
//        paragraphStyle.lineBreakMode = .byWordWrapping

        let attributedText = NSMutableAttributedString(string: title, attributes: [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.foregroundColor: AppConstants.Colors.AppWhite,
            NSAttributedString.Key.font: titleFont
        ])

        self.setAttributedTitle(attributedText, for: .normal)

    }
 
    func addBtnShadow() {
        // Shadow Color and Radius
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 10.0
        
        self.layer.masksToBounds = false
        
        self.layer.cornerRadius = 10.0
        self.layer.borderWidth = 0.0
        self.layer.borderColor = UIColor.black.cgColor
    }
}
