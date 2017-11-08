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
    
    private var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
       //self.selectedView.isHidden = true
        //self.selectedView.layer.cornerRadius = (selectedView.frame.height / 2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
    }
    
    
    
    // MARK: Convienence
    
    func configureCell(withDate date: String, isSelected: Bool, cellState: CellState) {
        self.dateLabel.text = date
        handleSelectedView(isSelected: isSelected)
        handleCellState(cellState)
    }
    
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
    
    private func handleSelectedView(isSelected: Bool) {
        //self.selectedView.isHidden = !isSelected
    }
    
    private func handleCellState(_ cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            dateLabel.layer.opacity = 1
        } else {
            dateLabel.layer.opacity = 0.5
        }
    }
}
