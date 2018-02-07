//
//  RefineVCDelegate.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/27/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import Foundation

protocol RefineVCDelegate: class {
    func refineVC(_ refineVC: RefineVC, sortOptionDidChangeTo option: SortOption)
    func refineVC(_ refineVC: RefineVC, carrierDataDidChangeTo carrierData: [CarrierData])
    func refineVC(_ refineVC: RefineVC, maxStopsDidChangeTo stops: MaxStops)
    func refineVC(_ refineVC: RefineVC, maxDurationDidChangeTo duration: Hour)
    func refineVC(_ refineVC: RefineVC, didUpdate option: PassengerOption)
    func refineVCDidResetSortAndFilter(_ refineVC: RefineVC)
}
