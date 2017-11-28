//
//  UITableView+TopCell.swift
//  TakeFlight
//
//  Created by Justin Erickson on 11/27/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit

extension UITableView {
    
    var topCell: UITableViewCell? {
        return self.visibleCells.first
    }
    
    func scrollToRow(at indexPath: IndexPath, at position: UITableViewScrollPosition, withDuration duration: TimeInterval, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: {
            self.scrollToRow(at: indexPath, at: position, animated: false)
            self.layoutIfNeeded()
        }) { finished in
            if finished, let completion = completion {
                completion()
            }
        }
    }
}
