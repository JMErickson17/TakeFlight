//
//  DestinationCollectionCellDelegate.swift
//  TakeFlight
//
//  Created by Justin Erickson on 2/17/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import Foundation

protocol DestinationCollectionCellManagerDelegate: class {
    func destinationCollectionCellManager(_ destinationCollectionCellManager: DestinationCollectionCellManager, didSelectDestination destination: Destination)
}
