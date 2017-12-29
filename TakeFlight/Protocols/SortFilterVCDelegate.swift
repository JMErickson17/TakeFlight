//
//  SortFilterVCDelegate.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/27/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import Foundation

protocol SortFilterVCDelegate: class {
    func sortFilterVC(_ sortFilterVC: SortFilterVC, sortOptionDidChangeTo option: SortOptions.Option)
    func sortFilterVC(_ sortFilterVC: SortFilterVC, filterOptionsDidChange options: FilterOptions?)
}
