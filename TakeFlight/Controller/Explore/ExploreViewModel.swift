//
//  ExploreViewModel.swift
//  TakeFlight
//
//  Created by Justin Erickson on 1/30/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ExploreViewModel {
    
    // MARK: Properties
    
    private(set) var popularDestinations = [Destination]()
    
    private let destinationService: DestinationService!
    
    // MARK: Lifecycle
    
    init(destinationService: DestinationService) {
        self.destinationService = destinationService
        popularDestinations = destinationService.destinations
    }
    
    // MARK: Convenience
    
    func image(for destination: Destination, completion: @escaping (UIImage?) -> Void) {
        destinationService.image(for: destination) { image, error in
            if let error = error { print(error); return completion(nil) }
            guard let image = image else { return completion(nil) }
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
}
