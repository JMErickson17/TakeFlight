//
//  TakeoffLoadingViewDelegate.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/13/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import Foundation

protocol TakeoffLoadingViewDelegate: class {
    func takeoffLoadingView(_ takeoffLoadingView: TakeoffLoadingView, runwayWillAnimateOffScreen: Bool)
}
