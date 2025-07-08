//
//  ConsoleLog.swift
//  CSC
//
//  Created by Nitesh on 06/04/20.
//  Copyright © 2020 ITC Infotech India Ltd. All rights reserved.
//

import Foundation

class ConsoleLog {
    
    public static let shared = ConsoleLog()
    
    private init() {}
        
    func log<T>(_ msg:T) {
        
        #if DEBUG
            print("LOG ##", msg)
        #endif
    }
}
