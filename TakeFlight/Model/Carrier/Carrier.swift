//
//  Airline.swift
//  TakeFlight
//
//  Created by Justin Erickson on 1/3/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import Foundation

struct Carrier: Codable {
    var name: String
    var code: String
    
    var dictionaryRepresentation: [String: Any] {
        return [
            "name": name,
            "code": code
        ]
    }
    
    init(name: String, code: String) {
        self.name = name
        self.code = code
    }
    
    init?(documentData data: JSONRepresentable) {
        guard let name = data["name"] as? String else { return nil }
        guard let code = data["code"] as? String else { return nil }
        self.init(name: name, code: code)
    }
}

// MARK: Carrier+Hashable

extension Carrier: Hashable {
    var hashValue: Int {
        return name.hashValue ^ code.hashValue
    }
    
    static func ==(lhs: Carrier, rhs: Carrier) -> Bool {
        return lhs.name == rhs.name && lhs.code == rhs.code
    }
}


