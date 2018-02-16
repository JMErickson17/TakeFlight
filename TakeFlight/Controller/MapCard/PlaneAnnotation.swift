//
//  PlaneAnnotation.swift
//  TakeFlight
//
//  Created by Justin Erickson on 2/16/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import UIKit
import MapKit

class PlaneAnnotation: MKPointAnnotation {
    
    let reuseIdentifier: String
    let image: UIImage?
    
    init(reuseIdentifier: String, image: UIImage) {
        self.reuseIdentifier = reuseIdentifier
        self.image = image
        super.init()
    }
}
