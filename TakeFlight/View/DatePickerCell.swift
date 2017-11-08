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
    
    private var selectedView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        view.clipsToBounds = true
        view.isHidden = true
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
            selectedView.heightAnchor.constraint(equalToConstant: contentView.frame.width - 10),
            selectedView.widthAnchor.constraint(equalToConstant: contentView.frame.width - 10),
            selectedView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            selectedView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        selectedView.layer.cornerRadius = (contentView.frame.width - 10) / 2
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
        self.selectedView.isHidden = !isSelected
    }
    
    private func handleCellState(_ cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            dateLabel.layer.opacity = 1
        } else {
            dateLabel.layer.opacity = 0.5
        }
    }
}
