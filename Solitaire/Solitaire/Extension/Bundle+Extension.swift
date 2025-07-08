//
//  Bundle+Extension.swift
//  CSC
//
//  Created by Adavan on 30/04/20.
//  Copyright © 2020 ITC Infotech India Ltd. All rights reserved.
//

import Foundation


extension Bundle {
    func decode<T: Decodable>(_ type: T.Type, from file: String, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) -> T? {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            ConsoleLog.shared.log("Failed to locate \(file) in bundle.")
            return nil
        }

        guard let data = try? Data(contentsOf: url) else {
            ConsoleLog.shared.log("Failed to load \(file) from bundle.")
             return nil
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        decoder.keyDecodingStrategy = keyDecodingStrategy

        do {
            return try decoder.decode(T.self, from: data)
        } catch DecodingError.keyNotFound(let key, let context) {
            ConsoleLog.shared.log("Failed to decode \(file) from bundle due to missing key '\(key.stringValue)' not found – \(context.debugDescription)")
        } catch DecodingError.typeMismatch(_, let context) {
            ConsoleLog.shared.log("Failed to decode \(file) from bundle due to type mismatch – \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            ConsoleLog.shared.log("Failed to decode \(file) from bundle due to missing \(type) value – \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(_) {
            ConsoleLog.shared.log("Failed to decode \(file) from bundle because it appears to be invalid JSON")
        } catch {
            ConsoleLog.shared.log("Failed to decode \(file) from bundle: \(error.localizedDescription)")
        }
        return nil
    }
    
}


extension Bundle {
    
    var versionNumber: String? {
        
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    var buildNumber: String? {
        
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
