//
//  SortFilterVCDelegate.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/27/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import Foundation

protocol SortFilterVCDelegate: class {
    func sortFilterVC(_ sortFilterVC: SortFilterVC, sortOptionDidChangeTo option: SortOption)
    func sortFilterVC(_ sortFilterVC: SortFilterVC, carrierDataDidChangeTo carrierData: [CarrierData])
    func sortFilterVC(_ sortFilterVC: SortFilterVC, maxStopsDidChangeTo stops: MaxStops)
    func sortFilterVC(_ sortFilterVC: SortFilterVC, maxDurationDidChangeTo duration: Hour)
    func sortFilterVC(_ sortFilterVC: SortFilterVC, didUpdate option: PassengerOption)
    func sortFilterVCDidResetSortAndFilter(_ sortFilterVC: SortFilterVC)
}
