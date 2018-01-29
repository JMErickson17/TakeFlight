//
//  DropDownNotification.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/19/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit
import Spring

class DropDownNotification {
    
    // MARK: Properties
    
    lazy var notificationView: NotificationView = {
        let notificationView = NotificationView()
        notificationView.isUserInteractionEnabled = true
        return notificationView
    }()
    
    private lazy var dismissGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer()
        gesture.minimumNumberOfTouches = 1
        gesture.delaysTouchesBegan = false
        return gesture
    }()
    
    // MARK: Lifecycle
    
    init(text: String) {
        notificationView.text = text
    }
    
    // MARK: Convenience
    
    func presentNotification<T>(onViewController viewController: T, forDuration duration: TimeInterval, completion: (() -> Void)? = nil) where T: UIViewController, T: DropDownNotificationDismissable {
        notificationView.frame = CGRect(x: 0, y: -75, width: viewController.view.bounds.width * 0.90, height: 75)
        notificationView.center.x = viewController.view.bounds.midX
        viewController.view.addSubview(notificationView)
        
        dismissGesture.addTarget(viewController, action: #selector(viewController.dismissGestureBegan(gesture:)))
        dismissGesture.delegate = viewController
        notificationView.addGestureRecognizer(dismissGesture)
        
        UIView.animate(withDuration: 0.7, delay: 0, options: [.curveEaseInOut, .allowUserInteraction], animations: {
            self.notificationView.transform = CGAffineTransform(translationX: 0, y: 100)
        }) { finished in
            if finished {
                DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: {
                    UIView.animate(withDuration: 0.7, delay: 0, options: [.curveEaseInOut, .allowUserInteraction], animations: {
                        self.notificationView.transform = CGAffineTransform(translationX: 0, y: -100)
                    }, completion: { finished in
                        if finished {
                            self.notificationView.removeFromSuperview()
                            completion?()
                        }
                    })
                })
            }
        }
    }
}
