//
//  UITableView+ReusableCells.swift
//  TakeFlight
//
//  Created by Justin Erickson on 2/17/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import UIKit

extension UITableView {
    func registerReusableCell<T: UITableViewCell>(_: T.Type) {
        if let nib = T.nib {
            self.register(nib, forCellReuseIdentifier: T.reuseIdentifier)
        } else {
            self.register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
        }
    }
    
    func deqeueReusableCell<T: UITableViewCell>(indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
}
