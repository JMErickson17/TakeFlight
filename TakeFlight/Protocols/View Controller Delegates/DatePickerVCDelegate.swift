//
//  Dismissable.swift
//  TakeFlight
//
//  Created by Justin Erickson on 10/26/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import Foundation

protocol DatePickerVCDelegate: class {    
    func datePickerVC(_ datePickerVC: DatePickerVC, didUpdateDepartureDate date: Date)
    func datePickerVC(_ datePickerVC: DatePickerVC, didUpdateReturnDate date: Date)
    func datePickerVC(_ datePickerVC: DatePickerVC, didClearDates: Bool)
    func datePickerVC(_ datePickerVC: DatePickerVC, shouldDismiss: Bool)
}
