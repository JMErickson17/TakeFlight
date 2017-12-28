//
//  SortFilterVCDelegate.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/27/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import Foundation

protocol SortFilterVCDelegate: class {
    
    var sortFilterOptions: SortFilterOptions? { get set }
}
