//
//  MyFlightsView.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/18/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit

@IBDesignable
class MyFlightsView: UIView, UIScrollViewDelegate {
    
    // MARK: Properties
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.isScrollEnabled = true
        scrollView.isPagingEnabled = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
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
    
    private lazy var upcomingTicketScrollView: TicketScrollView = {
        let scrollView = TicketScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var pastTicketScrollView: TicketScrollView = {
        let scrollView = TicketScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var defaultTicket: TicketView = {
        let ticketView = TicketView()
        ticketView.translatesAutoresizingMaskIntoConstraints = false
        ticketView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        ticketView.widthAnchor.constraint(equalToConstant: bounds.width).isActive = true
        return ticketView
    }()
    
    private lazy var defaultTicket2: TicketView = {
        let ticketView = TicketView()
        ticketView.translatesAutoresizingMaskIntoConstraints = false
        ticketView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        ticketView.widthAnchor.constraint(equalToConstant: bounds.width).isActive = true
        return ticketView
    }()
    
    // MARK: Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    // MARK: Setup
    
    private func setupView() {
        self.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalToConstant: bounds.width)
        ])

        contentView.addSubview(upcomingTicketScrollView)
        upcomingTicketScrollView.title = "Upcoming"
        upcomingTicketScrollView.tickets = fiveFakeTickets()
        NSLayoutConstraint.activate([
            upcomingTicketScrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            upcomingTicketScrollView.topAnchor.constraint(equalTo: contentView.topAnchor),
            upcomingTicketScrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            upcomingTicketScrollView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        
        contentView.addSubview(pastTicketScrollView)
        pastTicketScrollView.title = "Past"
        pastTicketScrollView.tickets = fiveFakeTickets()
        NSLayoutConstraint.activate([
            pastTicketScrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            pastTicketScrollView.topAnchor.constraint(equalTo: upcomingTicketScrollView.bottomAnchor, constant: 8),
            pastTicketScrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            pastTicketScrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            pastTicketScrollView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        updateScrollViewContentSize()
    }
    
    func updateScrollViewContentSize() {
        upcomingTicketScrollView.updateScrollViewContentSize()
        pastTicketScrollView.updateScrollViewContentSize()
        scrollView.contentSize = contentView.bounds.size
    }
    
    func fiveFakeTickets() -> [TicketView] {
        var tickets = [TicketView]()
        for _ in 1...5 {
            let ticket = TicketView()
            tickets.append(ticket)
        }
        return tickets
    }
    
    
    
    
    override func prepareForInterfaceBuilder() {
        setupView()
    }
    
    
    
    
    
    
    
    
    
    
    
}
