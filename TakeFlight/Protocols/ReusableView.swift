//
//  ReusableView.swift
//  TakeFlight
//
//  Created by Justin Erickson on 1/30/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import UIKit

protocol ReusableView: class {
    static var reuseIdentifier: String { get }
    static var nib: UINib? { get }
}

extension ReusableView where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib? {
        return nil
    }
}

extension UITableViewCell: ReusableView {}
extension UICollectionViewCell: ReusableView {}
extension MonthSectionHeaderView: ReusableView {}
