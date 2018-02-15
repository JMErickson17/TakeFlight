//
//  Array+FirstElements.swift
//  TakeFlight
//
//  Created by Justin Erickson on 2/15/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import Foundation

extension Array {
    func first(_ numberOfElements: Int) -> [Element] {
        if numberOfElements >= self.count {
            return self
        }
        return Array(self[0...numberOfElements])
    }
}
