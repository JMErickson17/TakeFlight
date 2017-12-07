//
//  Dismissable.swift
//  TakeFlight
//
//  Created by Justin Erickson on 10/26/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import Foundation

protocol DatePickerVCDelegate: class {
    func datePickerVC(_ datePickerVC: DatePickerVC, shouldDismissViewController: Bool)
    func datePickerVC(_ datePickerVC: DatePickerVC, shouldMoveTooltip: Bool, forSelectedState selectedState: SelectedState)
}
