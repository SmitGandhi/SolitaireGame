//
//  View+Extension.swift
//  CSC
//
//  Created by Archisman on 04/04/20.
//  Copyright © 2020 ITC Infotech India Ltd. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    // MARK: Rounded Corner
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    //MARK: Programtically constraints
    func anchor(topCons:NSLayoutYAxisAnchor? = nil,topConstant:CGFloat = 0.0,bottomCons: NSLayoutYAxisAnchor? = nil,bottomConstant: CGFloat = 0.0,leftCons: NSLayoutXAxisAnchor? = nil,leftConstant:CGFloat = 0.0,rightCons: NSLayoutXAxisAnchor? = nil,rightConstant: CGFloat = 0.0,width:CGFloat? = nil,height:CGFloat? = nil,centerXCons: NSLayoutXAxisAnchor? = nil,centerXConstant: CGFloat = 0.0,centerYCons: NSLayoutYAxisAnchor? = nil,centerYConstant: CGFloat = 0.0) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let topAnchor = topCons {
            self.topAnchor.constraint(equalTo: topAnchor, constant: topConstant).isActive = true
        }
        
        if let bottomAnchor = bottomCons {
            self.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottomConstant).isActive = true
        }
        
        if let leftAnchor = leftCons {
            self.leftAnchor.constraint(equalTo: leftAnchor, constant: leftConstant).isActive = true
        }
        
        if let rightAnchor = rightCons {
            self.rightAnchor.constraint(equalTo: rightAnchor, constant: rightConstant).isActive = true
        }
        
        if let width = width {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
        if let centerX = centerXCons {
            self.centerXAnchor.constraint(equalTo: centerX, constant: centerXConstant).isActive = true
        }
        
        if let centerY = centerYCons {
            self.centerYAnchor.constraint(equalTo: centerY, constant: centerYConstant).isActive = true
        }
    }
    
    func roundCornersRevised(_ corners: CACornerMask, radius: CGFloat, borderColor: UIColor?, borderWidth: CGFloat?) {
        
        self.layer.maskedCorners = corners
        self.layer.cornerRadius = radius
        
        if let width = borderWidth {
            
            self.layer.borderWidth = width
        }
        
        if let color = borderColor {
            
            self.layer.borderColor = color.cgColor
        }
    }
    
    class func fromNib<T: UIView>() -> T {
          return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)!.first! as! T
      }
    
    func addViewShadow() {
        // Shadow Color and Radius
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 10.0
        
        self.layer.masksToBounds = false
        
        self.layer.cornerRadius = 10.0
        self.layer.borderWidth = 0.0
        self.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    func addAnswerViewShadow() {
        // Shadow Color and Radius
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.5)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 4.0
        
        self.layer.masksToBounds = false
        
        self.layer.cornerRadius = 4.0
        self.layer.borderWidth = 0.0
        self.layer.borderColor = UIColor.darkGray.cgColor
    }
}
