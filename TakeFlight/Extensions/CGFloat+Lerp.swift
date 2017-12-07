//
//  CGFloat+Lerp.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/6/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit

extension CGFloat {
    
    static func lerp(min: CGFloat, max: CGFloat, norm: CGFloat) -> CGFloat {
        return (max - min) * norm + min
    }
}
