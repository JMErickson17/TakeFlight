//
//  TypeAliases.swift
//  TakeFlight
//
//  Created by Justin Erickson on 1/16/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import Foundation

typealias JSONRepresentable = [String: Any]
typealias Hour = Int
typealias CarrierData = (carrier: Carrier, isInCurrentSearch: Bool, isFiltered: Bool)

// MARK: Completion Handlers

typealias ErrorCompletionHandler = (Error?) -> Void
