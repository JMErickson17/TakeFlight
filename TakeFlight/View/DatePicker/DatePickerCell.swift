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
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var selectedView: SelectedDateView = {
        let view = SelectedDateView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(selectedView)
        contentView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            selectedView.heightAnchor.constraint(equalToConstant: contentView.frame.width),
            selectedView.widthAnchor.constraint(equalToConstant: contentView.frame.width),
            selectedView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            selectedView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    // MARK: Convienence
    
    func configureCell(withCellState cellState: CellState) {
        self.dateLabel.text = cellState.text
        handleSelectedView(isSelected: cellState.isSelected)
        handleCellState(cellState)
        selectedView.drawView(forState: cellState)
    }
    
    private func handleSelectedView(isSelected: Bool) {
        self.selectedView.isHidden = !isSelected
    }
    
    private func handleCellState(_ cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            dateLabel.layer.opacity = 1
        } else {
            dateLabel.layer.opacity = 0.8
        }
        
        if Calendar.current.compare(cellState.date, to: Date(), toGranularity: .day) == .orderedSame {
            dateLabel.textColor = UIColor(named: "StopCountGreen")
            dateLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        } else if Calendar.current.compare(cellState.date, to: Date(), toGranularity: .day) == .orderedAscending {
            dateLabel.textColor = .gray
            dateLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        } else {
            dateLabel.textColor = .black
            dateLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        }
    }
}
