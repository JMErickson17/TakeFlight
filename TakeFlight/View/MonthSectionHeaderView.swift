//
//  MonthSectionHeaderView.swift
//  TakeFlight
//
//  Created by Justin Erickson on 10/22/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit
import JTAppleCalendar

class MonthSectionHeaderView: JTAppleCollectionReusableView {

    // MARK: Properties
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    // MARK: Convenience
    
    func configureHeader(withDate date: Date) {
        self.monthLabel.text = date.toMonth()
        self.yearLabel.text = date.toYear()
    }
}
