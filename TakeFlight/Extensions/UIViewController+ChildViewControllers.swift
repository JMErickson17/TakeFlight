//
//  UIViewController+ChildViewControllers.swift
//  TakeFlight
//
//  Created by Justin Erickson on 2/16/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func add(_ child: UIViewController) {
        addChildViewController(child)
        view.addSubview(child.view)
        child.didMove(toParentViewController: self)
    }
    
    func removeChildViewController() {
        guard let _ = parent else { return }
        
        willMove(toParentViewController: nil)
        removeFromParentViewController()
        view.removeFromSuperview()
    }
}
