//
//  UITabBarController+SelectTab.swift
//  TakeFlight
//
//  Created by Justin Erickson on 1/31/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import UIKit

extension UITabBarController {
    
    func selectTab(_ tab: Int, animated: Bool, completion: (() -> Void)?) {
        guard self.selectedIndex != tab else { return }
        
        guard animated == true else {
            self.selectedIndex = tab
            return
        }
        
        guard let fromView = self.selectedViewController?.view else { return }
        guard let toView = self.viewControllers?[tab].view else { return }
        
        UIView.transition(from: fromView, to: toView, duration: 0.5, options: .transitionFlipFromRight) { finished in
            self.selectedIndex = tab
            if finished {
                completion?()
            }
        }
    }
}
