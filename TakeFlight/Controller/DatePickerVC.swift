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
    @IBOutlet weak var collectionView: JTAppleCalendarView!
    
    private let formatter = DateFormatter()
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.calendarDelegate = self
        collectionView.calendarDataSource = self
        
        setupView()
    }
    
    // MARK: Setup
    
    func setupView() {
        
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(DatePickerVC.closeDatePicker))
        backgroundView.addGestureRecognizer(dismissTap)
    }
    
    // MARK: Convenience
    
    @objc func closeDatePicker() {
        dismiss(animated: true, completion: nil)
    }

}

// MARK: - JTAppleCalendarView

extension DatePickerVC: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        if let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: Constants.DATE_PICKER_CELL, for: indexPath) as? DatePickerCell {
            cell.configureCell(withDate: cellState.text)
            return cell
        }
        return JTAppleCell()
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2017 01 01")!
        let endDate = formatter.date(from: "2018 01 01")!
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }
}
