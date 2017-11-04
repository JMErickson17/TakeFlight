//
//  DatePickerVC.swift
//  TakeFlight
//
//  Created by Justin Erickson on 10/15/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit
import JTAppleCalendar

class DatePickerVC: UIViewController, DatePickerVCDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    var delegate: SearchVCDelegate?
    
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
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(DatePickerVC.dismissViewContoller))
        backgroundView.addGestureRecognizer(dismissTap)
    }
    
    func setupCalendar() {
        calendarView.calendarDelegate = self
        calendarView.calendarDataSource = self
        
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        calendarView.allowsMultipleSelection = true
        calendarView.isRangeSelectionUsed = true
        
        if let delegate = delegate, let departureDate = delegate.departureDate, let returnDate = delegate.returnDate {
            calendarView.selectDates(from: departureDate, to: returnDate, triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
        }
    }
    
    // MARK: Convenience
    
    @objc func dismissViewContoller() {
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
        if let cell = cell as? DatePickerCell {
            cell.handleSelection(forState: cellState)
        }
    }
    
/*
     Configure the cells selected state.
 */
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let cell = cell as? DatePickerCell else { return }
        guard delegate != nil else { return }
        
        switch delegate!.datesSelected {
        case .none:
            delegate!.departureDate = date
            cell.handleSelection(forState: cellState)
            
        case .departure:
            if date < delegate!.departureDate! {
                calendar.deselectAllDates()
                break
            }
            
            delegate!.returnDate = date
            calendar.selectDates(from: delegate!.departureDate!, to: delegate!.returnDate!, triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
            
        case .departureAndReturn:
            calendar.deselectAllDates()
            delegate!.clearDates()
        }
        calendar.reloadData()
    }
    
/*
     Configure the cells deselected state.
 */
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        if let cell = cell as? DatePickerCell {
            cell.handleSelection(forState: cellState)
        }
    }
    
/*
     Configure the MonthSectionHeaderView header.
 */
    func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
        if let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "MonthHeader", for: indexPath) as? MonthSectionHeaderView {
            // TODO: Change header to xib file
            
            header.configureHeader(withDate: range.start, delegate: self)
            header.heightAnchor.constraint(equalToConstant: 55)
            return header
        }
        return JTAppleCollectionReusableView()
    }
    

    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        guard delegate != nil else { return }
        if let firstVisibleDate = visibleDates.indates.first?.date,
           let lastVisibleDate = visibleDates.outdates.last?.date {
        
            let visibleDateRange = DateRange(startDate: firstVisibleDate, endDate: lastVisibleDate)
            
            switch delegate!.datesSelected {
            case .none:
                break
            case .departure:
                if let departureDate = delegate!.departureDate, visibleDateRange.contains(date: departureDate) {
                    calendar.selectDates([departureDate], triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
                }
            case .departureAndReturn:
                if let departureDate = delegate!.departureDate, let returnDate = delegate!.returnDate {
                    calendar.selectDates(from: departureDate, to: returnDate, triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
                }
            }
            calendar.reloadData()
        }
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        cell?.isUserInteractionEnabled = true
        return true
    }
/*
     Configure the default month size for the calendarView.
 */
    func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
        return MonthSize(defaultSize: 40)
    }
}

// MARK: - JTAppleCalendarViewDataSource

extension DatePickerVC: JTAppleCalendarViewDataSource {
    
/*
     Configure the initial parameters for the calendar.
 */
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let sixMonths: TimeInterval = 15552000
        let startDate = Date()
        let endDate = startDate.addingTimeInterval(sixMonths)
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }
}
