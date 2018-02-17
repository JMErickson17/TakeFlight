//
//  DestinationCollectionCell
//  TakeFlight
//
//  Created by Justin Erickson on 2/17/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import UIKit

class DestinationCollectionCell: UITableViewCell {
    
    // MARK: Properties
    
    var contentManager: DestinationCollectionCellManager? {
        didSet {
            if let contentManager = contentManager {
                collectionView.delegate = contentManager
                collectionView.dataSource = contentManager
            }
        }
    }
    
    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 200, height: 200)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: self.frame, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.registerCell(DestinationCollectionViewCell.self)
        collectionView.backgroundColor = .white
        return collectionView
    }()

    // MARK: View Life Cycle
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupCollectionView()
    }
    
    // MARK: Setup

    private func setupCollectionView() {
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
