//
//  String+AlphanumericCharacters.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/1/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import Foundation

extension String {
    
    var alphanumericCharacters: String {
        return self.trimmingCharacters(in: CharacterSet(charactersIn: "0123456789.").inverted)
    }
}
