//
//  UITextview+Extension.swift
//  CSC
//
//  Created by Nitesh on 20/04/20.
//  Copyright © 2020 ITC Infotech India Ltd. All rights reserved.
//

import UIKit

extension UITextView: DynamicFontSizeProtocol {
    
    override open func awakeFromNib() {
        
        super.awakeFromNib()
        
        setFontSize()
    }
    
    func setFontSize() {
        
        /*
        switch UIDevice().type {
            
        case .iPhoneSE, .iPhone5, .iPhone5S, .iPhone5C:
            self.font = self.font?.withSize((self.font?.pointSize ?? 10.0) - 3)
            
        case .iPhone6, .iPhone6S, .iPhone7, .iPhone8:
            self.font = self.font?.withSize((self.font?.pointSize ?? 10.0))
            
        case .iPhone6plus, .iPhone6Splus, .iPhone7plus, .iPhone8plus:
            self.font = self.font?.withSize((self.font?.pointSize ?? 10.0))
            
        case .iPhoneX, .iPhoneXR, .iPhoneXS, .iPhoneXSMax, .iPhone11, .iPhone11Pro, .iPhone11ProMax:
            self.font = self.font?.withSize((self.font?.pointSize ?? 10.0) + 1)
            
        default:
            self.font = self.font?.withSize((self.font?.pointSize ?? 10.0) + 2)
            
        }
        */
    }
}
