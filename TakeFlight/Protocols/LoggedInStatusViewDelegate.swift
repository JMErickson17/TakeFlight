//
//  LoggedInStatusViewDelegate.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/19/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import Foundation

protocol LoggedInStatusViewDelegate: class {
    func loggedInStatusView(_ loggedInStatusView: LoggedInStatusView, loginButtonWasTapped: Bool)
    func loggedInStatusView(_ loggedInStatusView: LoggedInStatusView, signupButtonWasTapped: Bool)
}
