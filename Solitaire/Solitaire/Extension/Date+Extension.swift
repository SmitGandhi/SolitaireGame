//
//  Date+Extension.swift
//  CSC
//
//  Created by Nitesh on 22/05/20.
//  Copyright © 2020 ITC Infotech India Ltd. All rights reserved.
//

import Foundation

extension Date{
    
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    
}

extension DateFormatter {
    static let standardKeyFormat: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        df.locale = Locale(identifier: "en_US_POSIX")
        return df
    }()
    
    static let fullDateTime: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        df.locale = Locale(identifier: "en_US_POSIX")
        return df
    }()
}
