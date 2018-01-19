//
//  SliderCell.swift
//  TakeFlight
//
//  Created by Justin Erickson on 1/18/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import UIKit

class SliderCell: UITableViewCell {

    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
