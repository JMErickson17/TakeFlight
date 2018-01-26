//
//  KeyManager.swift
//  TakeFlight
//
//  Created by Justin Erickson on 1/26/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import Foundation

struct KeyManager {
    static func valueForAPIKey(_ key: String) -> String {
        if let filePath = Bundle.main.path(forResource: "APIKeys", ofType: "plist") {
            let plist = NSDictionary(contentsOfFile: filePath)
            if let apiKey = plist?.object(forKey: key) as? String {
                return apiKey
            }
        }
        fatalError("Could not load API key: \(key)")
    }
}
