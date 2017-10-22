//
//  DatePickerCell.swift
//  TakeFlight
//
//  Created by Justin Erickson on 10/15/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit
import JTAppleCalendar

class DatePickerCell: JTAppleCell {
    
    // MARK: Properties
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var selectedView: UIView!
    
    
    // MARK: View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectedView.isHidden = true
        self.selectedView.layer.cornerRadius = (selectedView.frame.height / 2)
    }
    
    // MARK: Convienence
    
    func configureCell(withDate date: String, isSelected: Bool, cellState: CellState) {
        self.dateLabel.text = date
        handleCellSelected(isSelected: isSelected)
        handleCellState(cellState)
    }
    
    func handleCellSelected(isSelected: Bool) {
        self.selectedView.isHidden = !isSelected
    }
    
    func handleCellState(_ cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            dateLabel.layer.opacity = 1
        } else {
            dateLabel.layer.opacity = 0.5
        }
    }
}
