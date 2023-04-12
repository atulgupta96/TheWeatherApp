//
//  File.swift
//  Vawsum
//
//  Created by Atul Gupta on 24/02/23.
//  Copyright © 2023 Vawsum. All rights reserved.
//

import Foundation

struct RawJSONOverHTTP {
    
    static func data<T: Codable>(_ from: T?) -> Data? {
        guard let encoded = try? JSONEncoder().encode(from) else {
            return nil
        }
        return encoded
    }
    
    static func jsonFrom(data: Data?) -> NSString? {
        guard let properData = data else {
            return nil
        }
        return NSString(data: properData, encoding: String.Encoding.utf8.rawValue)
    }
}
