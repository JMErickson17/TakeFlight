//
//  MaxStops.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/29/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import Foundation

enum MaxStops: Int {
    case nonStop = 0
    case one
    case two
    case three
    case four
    case five
    case six
    
    var description: String {
        switch self {
        case .nonStop: return "Non-Stop"
        case .one: return "One"
        case .two: return "Two"
        case .three: return "Three"
        case .four: return "Four"
        case .five: return "Five"
        case .six: return "Six"
        }
    }
}
