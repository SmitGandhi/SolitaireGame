//
//  String+Extension.swift
//  CSC
//
//  Created by Nitesh on 06/04/20.
//  Copyright © 2020 ITC Infotech India Ltd. All rights reserved.
//

import UIKit

extension String {
    
    // MARK:- Localization
    var toLocal: String {
        
        get {
            
            return NSLocalizedString(self, comment: "")
        }
    }
    
    func height(withConstrainedWidth width:CGFloat, font:UIFont) -> CGFloat {
        
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height:CGFloat, font:UIFont) -> CGFloat {
        
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    //MARK:- To check text field or String is blank or not
    var isBlank: Bool {
        
        get {
            
            let trimmed = trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            return trimmed.isEmpty
        }
    }
    
    //MARK:- Validate Email
    var isEmail: Bool {
        
        do {
            
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
        }
        catch {
            
            return false
        }
    }
    
    //MARK:- validate alphanumeric
    var isAlphanumeric: Bool {
        
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
    //MARK:- validate Password
    var isValidPassword: Bool {
        
        do {
            
            let regex = try NSRegularExpression(pattern: "^[a-zA-Z_0-9\\-_,;.:#+*?=!§$%&/()@]+$", options: .caseInsensitive)
            
            if(regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil) {
                
                if(self.count >= 6 && self.count <= 20) {
                    
                    return true
                }
                else {
                    
                    return false
                }
            }
            else {
                
                return false
            }
        }
        catch {
            
            return false
        }
    }
    
    //MARK:- validate receipt code
    var isValidReceiptCode: Bool {
        
        if(self.count >= 1 && self.count <= 30) {
            
            return true
        }
        else {
            
            return false
        }
    }
    
    //MARK:- validate special character
    var isSpecialCharacterExits: Bool {
        
        do {
            
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z0-9].*", options: .caseInsensitive)
            
            if(regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil) {
                
                return true
            }
            else {
                
                return false
            }
        }
        catch {
            
            return false
        }
    }
    
    //MARK:- validate zipcode
    var isValidZipcode : Bool {
        
        let postalcodeRegex = "^[0-9]{5}(-[0-9]{4})?$"
        let pinPredicate = NSPredicate(format: "SELF MATCHES %@", postalcodeRegex)
        let bool = pinPredicate.evaluate(with: self) as Bool
        return bool
    }
    
    //MARK:- validate zipcode
    var isValidPhoneNumber : Bool {
        
        let postalcodeRegex = "^[1-9]\\d{1,14}$"
        let pinPredicate = NSPredicate(format: "SELF MATCHES %@", postalcodeRegex)
        let bool = pinPredicate.evaluate(with: self) as Bool
        return bool
    }
    
    func formatStringfromDate(date : Date) -> String {
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = self
        return dateformatter.string(from: date)
    }
    
    func formatDatefromStrng(date : String) -> Date? {
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = self
        return dateformatter.date(from: date)
    }
    
    func trim() -> String {
        
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var yearDateFromToMonth:String {
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        let yearFormatDate = dateformatter.date(from: self)
        dateformatter.dateFormat = "M/d/yyyy"
        
        return dateformatter.string(from: yearFormatDate ?? Date())
    }
    
//    func returnTitleAndMessageFromErrorString(alertTitle: Bool) -> (String, String) {
//        
//        var tupple = (title: "Title", body: "Body")
//        
//        let msg = self.components(separatedBy: "@@")
//        
//        if msg.count == 0 {
//            
//            tupple.title = AppConstants.AppStrings.CommonStrings.ERROR_T
//            tupple.body = ""
//        }
//        else if msg.count == 1 {
//            
//            tupple.title = AppConstants.AppStrings.CommonStrings.ERROR_T
//            tupple.body = msg.first ?? ""
//        }
//        else if msg.count == 2 {
//            
//            tupple.title = msg.last ?? ""
//            tupple.body = msg.first ?? ""
//        }
//        
//        if alertTitle {
//            
//            tupple.title = AppConstants.AppStrings.CommonStrings.ALERT_T
//        }
//        
//        return tupple
//    }
}

extension Array where Element: Equatable {
    
    func indexes(of element: Element) -> [Int] {
        
        return self.enumerated().filter({ element == $0.element }).map({ $0.offset })
    }
}
