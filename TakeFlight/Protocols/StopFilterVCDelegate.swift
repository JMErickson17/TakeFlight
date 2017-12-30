//
//  StopFilterVCDelegate.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/29/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import Foundation

protocol StopFilterVCDelegate: class {
    func stopFilterVC(_ stopFilterVC: StopFilterVC, didUpdateMaxStopsTo maxStops: MaxStops)
}
