//
//  TicketScrollView.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/18/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit

@IBDesignable
class TicketScrollView: UIView {
    
    // MARK: Properties
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var tickets = [TicketView]() {
        didSet {
            setTickets(to: tickets)
            updateScrollViewContentSize()
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        label.textColor = .white
        return label
    }()

    private lazy var ticketScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.isPagingEnabled = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 1.0
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var ticketStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = ticketInset
//        stackView.isLayoutMarginsRelativeArrangement = true
//        stackView.layoutMargins = UIEdgeInsets(top: 0,
//                                               left: ticketInset,
//                                               bottom: 0,
//                                               right: ticketInset)
        
        return stackView
    }()
    
    private var ticketWidth: CGFloat {
        return UIScreen.main.bounds.width * 0.90
    }
    
    private var ticketInset: CGFloat {
        return UIScreen.main.bounds.width * 0.10
    }
    
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
        self.backgroundColor = .clear
        
        self.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8)
        ])
        
        self.addSubview(ticketScrollView)
        NSLayoutConstraint.activate([
            ticketScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            ticketScrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            ticketScrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            ticketScrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
//        ticketScrollView.addSubview(contentView)
//        NSLayoutConstraint.activate([
//            contentView.leadingAnchor.constraint(equalTo: ticketScrollView.leadingAnchor),
//            contentView.topAnchor.constraint(equalTo: ticketScrollView.topAnchor),
//            contentView.bottomAnchor.constraint(equalTo: ticketScrollView.bottomAnchor),
//        ])
        
        ticketScrollView.addSubview(ticketStackView)
        NSLayoutConstraint.activate([
            ticketStackView.leadingAnchor.constraint(equalTo: ticketScrollView.leadingAnchor),
            ticketStackView.topAnchor.constraint(equalTo: ticketScrollView.topAnchor),
            ticketStackView.trailingAnchor.constraint(equalTo: ticketScrollView.trailingAnchor),
            ticketStackView.bottomAnchor.constraint(equalTo: ticketScrollView.bottomAnchor),
            ticketStackView.heightAnchor.constraint(equalTo: ticketScrollView.heightAnchor)
        ])
        
        updateScrollViewContentSize()
    }
    
    func updateScrollViewContentSize() {
        ticketScrollView.contentSize = ticketStackView.frame.size
        self.layoutSubviews()
    }
    
    private func removeAllTickets() {
        ticketStackView.arrangedSubviews.forEach { ticket in
            ticketStackView.removeArrangedSubview(ticket)
            ticket.removeFromSuperview()
        }
    }
    
    private func setTickets(to tickets: [TicketView]) {
        removeAllTickets()
        
        tickets.forEach { ticket in
            ticket.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                ticket.heightAnchor.constraint(equalToConstant: 150),
                ticket.widthAnchor.constraint(equalToConstant: ticketWidth)
            ])
            
            ticketStackView.addArrangedSubview(ticket)
        }
    }
}
