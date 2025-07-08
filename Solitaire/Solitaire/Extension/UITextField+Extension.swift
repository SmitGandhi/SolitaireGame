//
//  UITextField+Extension.swift
//  CSC
//
//  Created by Adavan on 08/04/20.
//  Copyright © 2020 ITC Infotech India Ltd. All rights reserved.
//

import Foundation
import UIKit

extension UITextField: DynamicFontSizeProtocol {
    
    override open func awakeFromNib() {
        
        super.awakeFromNib()
        
        setFontSize()
    }
    
    func setFontSize() {
        
        // self.adjustsFontSizeToFitWidth = true
        // self.minimumFontSize = self.font?.pointSize ?? 10 / 2
        
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
    
    func setInputViewDatePicker(target: Any, selector: Selector,cancelSelector: Selector) {
        
        // Create a UIDatePicker object and assign to inputView
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.setYearValidation()
        datePicker.datePickerMode = .date
        self.inputView = datePicker
        
        // Create a toolbar and assign it to inputAccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: target, action: cancelSelector)
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        toolBar.setItems([cancel, flexible, barButton], animated: false) //8
        self.inputAccessoryView = toolBar //9
    }
    
    @objc func tapCancel() {
        
        self.resignFirstResponder()
    }
    
    func setInputViewPicker(target: Any, selector: Selector,cancelSelector: Selector,sender : UIViewController,tagId : Int) {
        
        // Create a UIDatePicker object and assign to inputView
        let screenWidth = UIScreen.main.bounds.width
        let uiPicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        uiPicker.delegate = sender as? UIPickerViewDelegate
        uiPicker.dataSource = sender as? UIPickerViewDataSource
        uiPicker.tag = tagId
        self.inputView = uiPicker
        
        // Create a toolbar and assign it to inputAccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: target, action: cancelSelector)
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        toolBar.setItems([cancel, flexible, barButton], animated: false) //8
        self.inputAccessoryView = toolBar //9
    }
    
}


extension UIDatePicker {
    
    func setYearValidation() {
        
        let currentDate: Date = Date()
        var calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        var components: DateComponents = DateComponents()
        components.calendar = calendar
        components.year = -13
        let maxDate: Date = calendar.date(byAdding: components, to: currentDate)!
        components.year = -128
        let minDate: Date = calendar.date(byAdding: components, to: currentDate)!
        self.minimumDate = minDate
        self.maximumDate = maxDate
    }
}

@IBDesignable
class CustomTextField: UITextField {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        
        didSet {
            
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        
        didSet {
            
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        
        didSet {
            
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    // MARK: - Setting placeholder color
    @IBInspectable var placeHolderColor: UIColor = UIColor.black {
        
        didSet {
            
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: placeHolderColor])
        }
    }
    
    // MARK: - Setting padding
    var padding = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)

    @IBInspectable var left: CGFloat = 10.0 {
        didSet {
            adjustPadding()
        }
    }

    @IBInspectable var right: CGFloat = 10.0 {
        didSet {
            adjustPadding()
        }
    }

    @IBInspectable var top: CGFloat = 0 {
        didSet {
            adjustPadding()
        }
    }

    @IBInspectable var bottom: CGFloat = 0 {
        didSet {
            adjustPadding()
        }
    }

    func adjustPadding() {
         padding = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)

    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        
        return bounds.inset(by: padding)
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        
        if(self.tag == 35385){
            if action == #selector(UIResponderStandardEditActions.paste(_:)) || action == #selector(UIResponderStandardEditActions.cut(_:)) || action == #selector(UIResponderStandardEditActions.copy(_:)) || action == #selector(UIResponderStandardEditActions.select(_:)) || action == #selector(UIResponderStandardEditActions.selectAll(_:)) {
                
                return true
            }
            else {
                return false
            }
        }else{
            if action == #selector(UIResponderStandardEditActions.paste(_:)) || action == #selector(UIResponderStandardEditActions.cut(_:)) || action == #selector(UIResponderStandardEditActions.copy(_:)) || action == #selector(UIResponderStandardEditActions.select(_:)) || action == #selector(UIResponderStandardEditActions.selectAll(_:)) {
                
                return true
            }
            else {
                
                return false
            }

        }
            
        
    }
    
    func setTextField_Placeholder(PlaceHolderTitle: String)  {
        self.attributedPlaceholder = NSAttributedString(string: PlaceHolderTitle, attributes: [NSAttributedString.Key.foregroundColor: AppConstants.Colors.Text, NSAttributedString.Key.font: AppConstants.Fonts.MarkerFeltThin_18!])
        self.font = AppConstants.Fonts.MarkerFeltThin_18
        self.textColor = AppConstants.Colors.Text

    }
}

