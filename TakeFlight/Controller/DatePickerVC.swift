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
    
    var delegate: SearchVCDelegate?
    
    private var calendarView: JTAppleCalendarView = {
        let calendar = JTAppleCalendarView()
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.backgroundColor = UIColor.white
        calendar.scrollDirection = .horizontal
        calendar.isPagingEnabled = true
        calendar.minimumLineSpacing = 0
        calendar.minimumInteritemSpacing = 0
        return calendar
    }()
    
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
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        view.clipsToBounds = true
    }
    
    
    func setupCalendar() {
        guard delegate != nil else { return dismissViewContoller() }
        
        calendarView.calendarDelegate = self
        calendarView.calendarDataSource = self
        view.addSubview(calendarView)
        NSLayoutConstraint.activate([
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendarView.topAnchor.constraint(equalTo: view.topAnchor),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            calendarView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        calendarView.register(UINib(nibName: Constants.MONTH_SECTION_HEADER_VIEW, bundle: nil), forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: Constants.MONTH_SECTION_HEADER_VIEW)
        calendarView.register(DatePickerCell.self, forCellWithReuseIdentifier: Constants.DATE_PICKER_CELL)
        
        switch delegate!.selectedSearchType {
        case .oneWay:
            calendarView.allowsMultipleSelection = false
            calendarView.isRangeSelectionUsed = false
            
            if let departureDate = delegate!.departureDate {
                calendarView.selectDates([departureDate], triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
            }
            
        case .roundTrip:
            calendarView.allowsMultipleSelection = true
            calendarView.isRangeSelectionUsed = true
            
            if let departureDate = delegate!.departureDate, let returnDate = delegate!.returnDate {
                guard departureDate < returnDate else { clearAllDates(); break }
                calendarView.selectDates(from: departureDate, to: returnDate, triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
            }
        }
    }
    
    // MARK: Convenience
    
    @objc func dismissViewContoller() {
        delegate?.dismissDatePicker()
    }
    
    private func clearAllDates() {
        guard delegate != nil else { return }
        calendarView.deselectAllDates()
        delegate!.clearDates()
        calendarView.reloadData()
    }
}

// MARK: - JTAppleCalendarViewDelegate

extension DatePickerVC: JTAppleCalendarViewDelegate {

    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        if let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: Constants.DATE_PICKER_CELL, for: indexPath) as? DatePickerCell {
            cell.configureCell(withCellState: cellState)
            return cell
        }
        return JTAppleCell()
    }

    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        if let cell = cell as? DatePickerCell {
            cell.configureCell(withCellState: cellState)
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        guard delegate != nil else { return }
        
        if let firstVisibleDate = visibleDates.indates.first?.date,
            let lastVisibleDate = visibleDates.outdates.last?.date {
            let visibleDateRange = DateRange(startDate: firstVisibleDate, endDate: lastVisibleDate)
            print(visibleDateRange)
            
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
        return date >= Date()
    }

    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard delegate != nil else { return }
        
        if let cell = cell as? DatePickerCell {
            if delegate!.selectedSearchType == .oneWay {
                delegate!.departureDate = date
                cell.configureCell(withCellState: cellState)
            } else {
                switch delegate!.datesSelected {
                case .none:
                    delegate!.departureDate = date
                    cell.configureCell(withCellState: cellState)
                case .departure:
                    guard date > delegate!.departureDate! else { clearAllDates(); break }
                    delegate?.returnDate = date
                    calendar.selectDates(from: delegate!.departureDate!, to: delegate!.returnDate!, triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
                case .departureAndReturn:
                    clearAllDates()
                }
            }
        }
        calendar.reloadData()
    }
    
    func calendar(_ calendar: JTAppleCalendarView, shouldDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        clearAllDates()
        return true
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        if let cell = cell as? DatePickerCell {
            
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
        if let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "MonthSectionHeaderView", for: indexPath) as? MonthSectionHeaderView {
            header.configureHeader(withDate: range.start, delegate: self)
            return header
        }
        return JTAppleCollectionReusableView()
    }
    
    func sizeOfDecorationView(indexPath: IndexPath) -> CGRect {
        let headerViewRect = CGRect(x: 0, y: 0, width: calendarView.frame.width, height: 55)
        return headerViewRect
    }

    func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
        return MonthSize(defaultSize: 50)
    }
}

// MARK: - JTAppleCalendarViewDataSource

extension DatePickerVC: JTAppleCalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let sixMonths: TimeInterval = 15552000

        let startDate = Date()
        let endDate = Date().addingTimeInterval(sixMonths)
        
        let parameters = ConfigurationParameters(
            startDate: startDate,
            endDate: endDate)
        return parameters
    }
}
