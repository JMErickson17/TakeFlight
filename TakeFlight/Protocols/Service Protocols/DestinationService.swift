//
//  DestinationService.swift
//  TakeFlight
//
//  Created by Justin Erickson on 1/30/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import UIKit

protocol DestinationService {
    var destinations: [Destination] { get }
    
    func getDestinations(completion: @escaping ([Destination]?, Error?) -> Void)
    func create(destination: Destination, completion: @escaping ErrorCompletionHandler)
    func image(for destination: Destination, completion: @escaping (UIImage?, Error?) -> Void)
    
    func create(destination: Destination, with image: UIImage)
}
