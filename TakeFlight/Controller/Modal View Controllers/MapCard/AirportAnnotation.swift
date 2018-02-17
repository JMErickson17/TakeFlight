//
//  AirportAnnotation.swift
//  TakeFlight
//
//  Created by Justin Erickson on 2/16/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import UIKit
import MapKit

class AirportAnnotation: NSObject, MKAnnotation {
    
    var title: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
}
