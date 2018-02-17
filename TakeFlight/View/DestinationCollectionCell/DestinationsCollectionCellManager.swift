//
//  DestinationsCollectionCellManager.swift
//  TakeFlight
//
//  Created by Justin Erickson on 2/17/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import UIKit

class DestinationCollectionCellManager: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private let destinations: [Destination]
    private let destinationService: DestinationService
    
    init(destinations: [Destination], destinationService: DestinationService) {
        self.destinations = destinations
        self.destinationService = destinationService
    }
    
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return destinations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
