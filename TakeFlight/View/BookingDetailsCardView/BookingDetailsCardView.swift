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
    @IBOutlet weak var latestTicketingTimeLabel: UILabel!
    
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
    }

    
    func configureView(withBookingCode bookingCode: String, refundable: String, latestTicketingTime: String) {
        self.bookingCodeLabel.text = bookingCode
        self.refundableLabel.text = refundable
        self.latestTicketingTimeLabel.text = latestTicketingTime
    }
}
