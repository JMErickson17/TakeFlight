//
//  BookingDetailsCardView.swift
//  TakeFlight
//
//  Created by Justin Erickson on 1/26/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import UIKit

class BookingDetailsCardView: UIView {
    
    // MARK: Properties
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var bookingCodeLabel: UILabel!
    @IBOutlet weak var refundableLabel: UILabel!
    @IBOutlet weak var adultCountLabel: UILabel!
    @IBOutlet weak var childCountLabel: UILabel!
    @IBOutlet weak var infantCountLabel: UILabel!
    @IBOutlet weak var latestTicketingTimeLabel: UILabel!
    @IBOutlet weak var clickToCopyLabel: UILabel!
    
    private var bookingCode: String?
    
    // MARK: Lifecycle
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    // MARK: Setup
    
    private func setupView() {
        Bundle.main.loadNibNamed("BookingDetailsCardView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.layer.cornerRadius = 5
        contentView.clipsToBounds = true
        clickToCopyLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(copyBookingCodeToClipboard)))
    }

    
    func configureView(withBookingCode bookingCode: String, refundable: String, latestTicketingTime: String, adultCount: Int, childCount: Int, infantCount: Int) {
        self.bookingCodeLabel.text = bookingCode
        self.bookingCode = bookingCode
        self.refundableLabel.text = refundable
        self.latestTicketingTimeLabel.text = latestTicketingTime
        self.adultCountLabel.text = String(adultCount)
        self.childCountLabel.text = String(childCount)
        self.infantCountLabel.text = String(infantCount)
    }
    
    @objc func copyBookingCodeToClipboard() {
        if let bookingCode = bookingCode {
            UIPasteboard.general.string = bookingCode
            clickToCopyLabel.text = "Copied!"
        }
    }
}
