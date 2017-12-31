//
//  DurationFilterVCDelegate.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/31/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import Foundation

protocol DurationFilterVCDelegate: class {
    func durationFilterVC(_ durationFilterVC: DurationFilterVC, didUpdateMaxDurationTo maxDuration: Hour)
}
