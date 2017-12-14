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
    
    private let centerTooltipLocation: CGFloat = 0.50
    private let departureTooltipLocation: CGFloat = 0.25
    private let returnTooltipLocation: CGFloat = 0.75
    
    private lazy var tooltipView: TooltipView = {
        let view = TooltipView()
        view.isOpaque = false
        view.tooltipLocation = 0.25
        view.contentMode = .redraw
        return view
    }()
    
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
        
        setupCalendar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupView()
    }
    
    // MARK: Setup
    
    func setupView() {
        tooltipView.frame = view.bounds
        view.addSubview(tooltipView)
        
        tooltipView.addSubview(calendarView)
        NSLayoutConstraint.activate([
            calendarView.leadingAnchor.constraint(equalTo: tooltipView.leadingAnchor, constant: 3),
            calendarView.topAnchor.constraint(equalTo: tooltipView.topAnchor, constant: 3),
            calendarView.trailingAnchor.constraint(equalTo: tooltipView.trailingAnchor, constant: -3),
            calendarView.bottomAnchor.constraint(equalTo: tooltipView.bottomAnchor, constant: -3)
        ])
    }
    
    func setupCalendar() {
        guard delegate != nil else { return datePickerVC(self, shouldDismissViewController: true) }
        
        calendarView.calendarDelegate = self
        calendarView.calendarDataSource = self
        
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
    
    @objc func datePickerVC(_ datePickerVC: DatePickerVC, shouldDismissViewController: Bool) {
        if shouldDismissViewController {
            delegate?.searchVC(delegate as! SearchVC, shouldDismissDatePicker: true)
        }
    }
    
    private func clearAllDates() {
        if let delegate = delegate as? SearchVC {
            delegate.searchVC(delegate, shouldClearDates: true)
            calendarView.deselectAllDates()
            calendarView.reloadData()
        }
    }
    
    func datePickerVC(_ datePickerVC: DatePickerVC, shouldMoveTooltip: Bool, forSelectedState selectedState: SelectedState) {
        if shouldMoveTooltip {
            switch selectedState {
            case.none:
                tooltipView.animateTooltip(to: departureTooltipLocation, withDuration: 1.0)
            case .departure:
                tooltipView.animateTooltip(to: returnTooltipLocation, withDuration: 1.0)
            case .departureAndReturn:
                tooltipView.animateTooltip(to: centerTooltipLocation, withDuration: 1.0)
            }
        }
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
        let datesSelected = delegate!.datesSelected
        
        if let cell = cell as? DatePickerCell {
            if delegate!.selectedSearchType == .oneWay {
                delegate!.departureDate = date
                cell.configureCell(withCellState: cellState)
            } else {
                switch datesSelected {
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
        if let delegate = delegate {
            if delegate.datesSelected != .none {
                clearAllDates()
            }
        }
        return true
    }
    
    func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
        if let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: Constants.MONTH_SECTION_HEADER_VIEW, for: indexPath) as? MonthSectionHeaderView {
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
