//
//  CarrierImages.swift
//  TakeFlight
//
//  Created by Justin Erickson on 2/21/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import UIKit

struct CarrierImages {
    
    private let carrierImages: [String: UIImage] = [
        "AS": #imageLiteral(resourceName: "AlaskaAirlinesLogo"),
        "B6": #imageLiteral(resourceName: "JetBlueAirlinesLogo"),
        "F9": #imageLiteral(resourceName: "FrontierAirlinesLogo"),
        "NK": #imageLiteral(resourceName: "SpiritAirlinesLogo"),
        "SY": #imageLiteral(resourceName: "SunCountryAirlinesLogo"),
        "UA": #imageLiteral(resourceName: "UnitedAirlinesLogo"),
        "DL": #imageLiteral(resourceName: "DeltaAirlinesLogo"),
        "WN": #imageLiteral(resourceName: "SouthwestAirlinesLogo"),
        "AA": #imageLiteral(resourceName: "AmericanAirlinesLogo"),
        "VX": #imageLiteral(resourceName: "VirginAirlinesLogo"),
        "VS": #imageLiteral(resourceName: "VirginAirlinesLogo")
    ]
    
    subscript(_ code: String) -> UIImage? {
        return carrierImages[code]
    }
    
    func image(for carrier: Carrier) -> UIImage? {
        return carrierImages[carrier.code]
    }
}
