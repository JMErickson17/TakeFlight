//
//  UIViewController+DropDownNotificationDismissable.swift
//  TakeFlight
//
//  Created by Justin Erickson on 1/27/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import UIKit

extension UIViewController: DropDownNotificationDismissable {
    
    @objc func dismissGestureBegan(gesture: UIPanGestureRecognizer) {
        guard let gestureView = gesture.view else { return }
        
        switch gesture.state {
        case .began, .changed:
            let translation = gesture.translation(in: view)
            if gestureView.center.y < 1 {
                gestureView.center = CGPoint(x: gestureView.center.x, y: gestureView.center.y + translation.y)
            } else {
                gestureView.center = CGPoint(x: gestureView.center.x, y: 0)
            }
            gesture.setTranslation(CGPoint.zero, in: view)
        case .ended:
            UIView.animate(withDuration: 0.7, delay: 0, options: [.curveEaseInOut, .allowUserInteraction], animations: {
                gestureView.transform = CGAffineTransform(translationX: 0, y: -100)
            }) { finished in
                if finished {
                    gestureView.removeFromSuperview()
                }
            }
        default:
            break
        }
    }
}

