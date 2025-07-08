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
