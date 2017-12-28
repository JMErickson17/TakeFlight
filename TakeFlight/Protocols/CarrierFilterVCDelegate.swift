//
//  CarrierFilterVCDelegate.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/28/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import Foundation

protocol CarrierFilterVCDelegate: class {
    func carrierFilterVC(_ carrierFilterVC: CarrierFilterVC, setFilteredCarriersTo carriers: [FilterableCarrier])
}
