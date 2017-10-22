//
//  DatePickerVC.swift
//  TakeFlight
//
//  Created by Justin Erickson on 10/15/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit
import JTAppleCalendar

class DatePickerVC: UIViewController {

    // MARK: Properties
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    private let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Calendar.current.locale
        dateFormatter.dateFormat = "yyyy MM dd"
        return dateFormatter
    }()
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupCalendar()
    }
    
    // MARK: Setup
    
    func setupView() {
        
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(DatePickerVC.closeDatePicker))
        backgroundView.addGestureRecognizer(dismissTap)
    }
    
    func setupCalendar() {
        calendarView.calendarDelegate = self
        calendarView.calendarDataSource = self
        
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
    }
    
    // MARK: Convenience
    
    @objc func closeDatePicker() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - JTAppleCalendarViewDelegate

extension DatePickerVC: JTAppleCalendarViewDelegate {
    
/*
     Configure the cell for the item at a specific index path.
 */
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        if let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: Constants.DATE_PICKER_CELL, for: indexPath) as? DatePickerCell {
            cell.configureCell(withDate: cellState.text, isSelected: false, cellState: cellState)
            return cell
        }
        return JTAppleCell()
    }
    
/*
     Implemented to address inconsistencies in the visual appearance as stated by Apple.
 */

    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
    }
    
/*
     Configure the cells selected state.
 */
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        if let cell = cell as? DatePickerCell {
            cell.handleCellSelected(isSelected: true)
        }
    }
    
/*
     Configure the cells deselected state.
 */
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        if let cell = cell as? DatePickerCell {
            cell.handleCellSelected(isSelected: false)
        }
    }
    
/*
     Configure the MonthSectionHeaderView header.
 */
    func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
        if let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "MonthHeader", for: indexPath) as? MonthSectionHeaderView {
            header.configureHeader(withDate: range.start)
            return header
        }
        return JTAppleCollectionReusableView()
    }
    
/*
     Configure the default month size for the calendarView.
 */
    func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
        return MonthSize(defaultSize: 50)
    }
}

// MARK: - JTAppleCalendarViewDataSource

extension DatePickerVC: JTAppleCalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let sixMonths: TimeInterval = 15552000
        let startDate = Date()
        let endDate = startDate.addingTimeInterval(sixMonths)
        print(startDate)
        print(endDate)
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }
}
