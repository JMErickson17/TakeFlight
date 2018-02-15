//
//  DestinationsVC.swift
//  TakeFlight
//
//  Created by Justin Erickson on 2/15/18.
//  Copyright © 2018 Justin Erickson. All rights reserved.
//

import UIKit

class DestinationsVC: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    var destinationService: DestinationService!
    var destinations: [Destination]? {
        didSet {
            if let _ = tableView {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }
    
    // MARK: Setup
    
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: DestinationCell.reuseIdentifier,
                                      bundle: Bundle.main), forCellReuseIdentifier: DestinationCell.reuseIdentifier)
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

// MARK:- UITableViewDelegate, UITableViewDataSource

extension DestinationsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: DestinationCell.reuseIdentifier, for: indexPath) as? DestinationCell {
            guard let destinations = destinations else { return UITableViewCell() }
            let destination = destinations[indexPath.row]
            cell.tag = indexPath.row
            image(for: destination, completion: { image in
                guard cell.tag == indexPath.row else { return }
                cell.configureCell(with: destination, image: image)
            })
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return destinations?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }
}
