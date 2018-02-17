//
//  DestinationsCollectionCellManager.swift
//  TakeFlight
//
//  Created by Justin Erickson on 2/17/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import UIKit

class DestinationCollectionCellManager: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: Properties
    
    weak var delegate: DestinationCollectionCellManagerDelegate?
    
    private let destinations: [Destination]
    private let destinationService: DestinationService
    
    // MARK: View Life Cycle
    
    init(destinations: [Destination], destinationService: DestinationService) {
        self.destinations = destinations
        self.destinationService = destinationService
    }
    
    // MARK: Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(indexPath: indexPath) as DestinationCollectionViewCell
        cell.tag = indexPath.item
        let destination = destinations[indexPath.item]
        destinationService.image(for: destination) { image, error in
            DispatchQueue.main.async {
                guard cell.tag == indexPath.item else { return }
                cell.configureCell(with: image, title: destination.city, subtitle: destination.state)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destination = destinations[indexPath.item]
        delegate?.destinationCollectionCellManager(self, didSelectDestination: destination)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return destinations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 200)
    }
}
