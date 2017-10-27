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
    
/**
     Configure the current cell
 */
    func configureCell(withDate date: String, isSelected: Bool, cellState: CellState) {
        self.dateLabel.text = date
        handleSelectedView(isSelected: isSelected)
        handleCellState(cellState)
    }
    
/**
     Configure the view of the cells selected state based on its position in the range of selected dates.
 */
    func handleSelection(forState state: CellState) {
        switch state.selectedPosition() {
        case .full, .left, .right:
            self.handleSelectedView(isSelected: true)
        case .middle:
            self.handleSelectedView(isSelected: true)
        default:
            self.handleSelectedView(isSelected: false)
        }
    }
    
/**
     Configure the cells selected views
 */
    private func handleSelectedView(isSelected: Bool) {
        self.selectedView.isHidden = !isSelected
    }
    
/**
     Configure the view of the cell based on its current cellState
 */
    private func handleCellState(_ cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            dateLabel.layer.opacity = 1
        } else {
            dateLabel.layer.opacity = 0.5
        }
    }
}
