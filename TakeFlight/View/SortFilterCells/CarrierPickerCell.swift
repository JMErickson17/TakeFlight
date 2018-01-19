//
//  CarrierPickerCell.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/27/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit

class CarrierPickerCell: UITableViewCell {

    // MARK: Properties
    
    @IBOutlet weak var carrierImage: UIImageView!
    @IBOutlet weak var carrierLabel: UILabel!
    @IBOutlet weak var carrierFilterSwitch: UISwitch!
    
    var carrierData: CarrierData?
    weak var delegate: CarrierPickerCellDelegate?
    
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
    
    // MARK: Actions
    
    @IBAction func filterCarrierSwitchDidChange(_ sender: Any) {
        
        carrierData?.isFiltered = !carrierFilterSwitch.isOn
        if let carrierData = carrierData {
            delegate?.carrierPickerCell(self, didUpdateCarrierData: carrierData)
        }
    }

    // MARK: Convenience
    
    func configureCell(withCarrierData data: CarrierData) {
        self.carrierData = data
        carrierLabel.text = data.carrier.name
        carrierFilterSwitch.isOn = !data.isFiltered
        carrierImage.image = carrierImages[data.carrier.code]
    }
}
