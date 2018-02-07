//
//  PassengerOption.swift
//  TakeFlight
//
//  Created by Justin Erickson on 2/6/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import Foundation

enum PassengerOption {
    case adultPassengers(Int)
    case childPassengers(Int)
    case infantPassengers(Int)
    
    var value: Int {
        switch self {
        case .adultPassengers(let value):
            return value
        case .childPassengers(let value):
            return value
        case .infantPassengers(let value):
            return value
            
        }
    }
}
