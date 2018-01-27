//
//  ProfileVC.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/17/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit
import Firebase
import RxSwift
import RxCocoa
import RSKImageCropper

class ProfileVC: UIViewController {
    
    private struct Constants {
        static let toLoginVC = "ToLoginVC"
        static let toSignupVC = "ToSignupVC"
        static let loginToSaveFlightsMessage = "Login or create an account\n to save flights."
        static let noSavedFlightsMessage = "You don't currently have any saved flights!\n Find flights using the search tab."
        static let noPurchasedFlightsMessage = "Your past and upcoming flights will appear here.\n Find flights using the search tab."
    }
    
    private enum SegmentType: Int {
        case savedFlights = 0
        case purchasedFlights = 1
    }
    
    private enum SectionType: String {
        case upcomingFlights = "Upcoming Flights"
        case pastFlights = "Past Flights"
        case savedFlights = "Saved Flights"
    }
    
    private struct Section {
        var type: SectionType
        var items: [FlightData]
    }
    
    private struct Segment {
        var type: SegmentType
        var sections: [Section]
    }
    
    // MARK: Properties
    
    @IBOutlet weak var profileImageView: ProfileImageView!
    @IBOutlet weak var userStatusView: LoggedInStatusView!
    @IBOutlet weak var myFlightsTableView: UITableView!
    @IBOutlet weak var myFlightsSegmentControl: UISegmentedControl!
    
    private var tableData: [Segment]!
    private var disposeBag = DisposeBag()
    
    private var savedFlights = [FlightData]() {
        didSet {
            if !savedFlights.isEmpty { myFlightsStatusLabel.isHidden = true }
            tableData[SegmentType.savedFlights.rawValue].sections[0].items = savedFlights
            myFlightsTableView.reloadData()
        }
    }
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var userService: UserService = appDelegate.firebaseUserService!
    
    private lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        return imagePicker
    }()
    
    private lazy var editProfileImageRecognizer: UILongPressGestureRecognizer = {
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleEditProfileImage))
        recognizer.minimumPressDuration = 0.5
        recognizer.numberOfTouchesRequired = 1
        return recognizer
    }()
    
    private lazy var editProfileImageAlertController: UIAlertController = {
        let controller = UIAlertController(title: "Edit Profile Photo", message: nil, preferredStyle: .actionSheet)
        controller.addAction(UIAlertAction(title: "Choose from Library", style: .default, handler: handleChooseImageFromLibrary))
        controller.addAction(UIAlertAction(title: "Remove Current Photo", style: .destructive, handler: handleRemoveProfileImage))
        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        return controller
    }()
    
    private lazy var myFlightsStatusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupView()
        bindUserService()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: Setup
    
    private func setupView() {
        userStatusView.delegate = self
        profileImageView.addGestureRecognizer(editProfileImageRecognizer)
        profileImageView.layer.shadowColor = UIColor.black.cgColor
        profileImageView.layer.shadowOffset = CGSize.zero
        profileImageView.layer.shadowRadius = 10
        myFlightsSegmentControl.addTarget(self, action: #selector(myFlightSegmentControlDidChange(_:)), for: .valueChanged)
    }
    
    private func bindUserService() {
        userService.currentUser.asObservable().subscribe(onNext: { currentUser in
            self.updateView(for: currentUser)
        }).disposed(by: disposeBag)
        
        userService.savedFlights.asObservable().subscribe(onNext: { savedFlights in
            self.savedFlights = savedFlights
        }).disposed(by: disposeBag)
        
        userService.profileImage.asObservable().bind(to: profileImageView.rx.image).disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        myFlightsTableView.delegate = self
        myFlightsTableView.dataSource = self
        
        myFlightsTableView.addSubview(myFlightsStatusLabel)
        NSLayoutConstraint.activate([
            myFlightsStatusLabel.centerXAnchor.constraint(equalTo: myFlightsTableView.centerXAnchor),
            myFlightsStatusLabel.centerYAnchor.constraint(equalTo: myFlightsTableView.centerYAnchor)
        ])
        
        tableData = [
            Segment(type: .savedFlights, sections: [
                Section(type: .savedFlights, items: [])
            ]),
            Segment(type: .purchasedFlights, sections: [
                Section(type: .upcomingFlights, items: []),
                Section(type: .pastFlights, items: [])
            ])
        ]
    }
    
    // MARK: Convenience
    
    private func updateView(for currentUser: User?) {
        self.updateLoggedInStatusView(for: currentUser)

        if let _ = currentUser {
            self.myFlightsStatusLabel.text = myFlightsSegmentControl.selectedSegmentIndex == 0 ? Constants.noSavedFlightsMessage : Constants.noPurchasedFlightsMessage
            self.myFlightsStatusLabel.isHidden = myFlightsSegmentControl.selectedSegmentIndex == 0 ? !savedFlights.isEmpty : false
        } else {
            self.myFlightsStatusLabel.text = Constants.loginToSaveFlightsMessage
            myFlightsStatusLabel.isHidden = false
        }
    }
    
    private func updateLoggedInStatusView(for currentUser: User?) {
        if let currentUser = currentUser {
            if userStatusView.loggedInViewIsVisible {
                userStatusView.configureView(for: currentUser, animated: false)
            } else {
                userStatusView.configureView(for: currentUser, animated: true)
            }
        } else {
            if userStatusView.loggedInViewIsVisible {
                userStatusView.configureView(for: nil, animated: true)
            } else {
                userStatusView.configureView(for: nil, animated: false)
            }
        }
    }
    
    @objc private func handleEditProfileImage(_ recognizer: UILongPressGestureRecognizer) {
        if recognizer.state == .began {
            present(editProfileImageAlertController, animated: true, completion: nil)
        }
    }
    
    private func handleChooseImageFromLibrary(_ action: UIAlertAction) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func handleRemoveProfileImage(_ action: UIAlertAction) {
        print("Remove Photo")
    }
    
    private func handleSave(profileImage: UIImage) {
        userService.saveToCurrentUser(profileImage: profileImage) { error in
            if let error = error, let navigationController = self.navigationController {
                let notification = DropDownNotification(text: error.localizedDescription)
                notification.presentNotification(onNavigationController: navigationController, forDuration: 3)
                return
            }
        }
    }
    
    @objc private func myFlightSegmentControlDidChange(_ sender: UISegmentedControl) {
        guard userService.currentUser.value != nil else { return }
        switch sender.selectedSegmentIndex {
        case 0:
            myFlightsStatusLabel.text = Constants.noSavedFlightsMessage
            myFlightsStatusLabel.isHidden = !savedFlights.isEmpty
        case 1:
            myFlightsStatusLabel.text = Constants.noPurchasedFlightsMessage
            myFlightsStatusLabel.isHidden = false
        default: break
        }
        self.myFlightsTableView.reloadData()
    }
}

// MARK:- ProfileVC+UITableViewDelegate, UITableViewDataSource

extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MyFlightCell", for: indexPath) as? MyFlightCell {
            let flightData = tableData[myFlightsSegmentControl.selectedSegmentIndex].sections[indexPath.section].items[indexPath.row]
            cell.configureCell(with: flightData)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let flightData = tableData[myFlightsSegmentControl.selectedSegmentIndex].sections[indexPath.section].items[indexPath.row]
        let flightDetailsVC = FlightDetailsVCFactory.makeFlightDetailsVC(with: flightData)
        flightDetailsVC.flightIsSaved = true
        navigationController?.pushViewController(flightDetailsVC, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableData[myFlightsSegmentControl.selectedSegmentIndex].sections[section].type.rawValue
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as? UITableViewHeaderFooterView
        header?.textLabel?.textColor = .white
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData[myFlightsSegmentControl.selectedSegmentIndex].sections[section].items.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableData[myFlightsSegmentControl.selectedSegmentIndex].sections.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
}

// MARK:- ProfileVC+LoggedInStatusViewDelegate

extension ProfileVC: LoggedInStatusViewDelegate {
    func loggedInStatusViewLoginButtonWasTapped(_ loggedInStatusView: LoggedInStatusView) {
        performSegue(withIdentifier: Constants.toLoginVC, sender: nil)
    }
    
    func loggedInStatusViewSignupButtonWasTapped(_ loggedInStatusView: LoggedInStatusView) {
        performSegue(withIdentifier: Constants.toSignupVC, sender: nil)
    }
}

// MARK:- ProfileVC+UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension ProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate, RSKImageCropViewControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.dismiss(animated: true, completion: {
                let cropImageVC = RSKImageCropViewController(image: image, cropMode: RSKImageCropMode.circle)
                cropImageVC.delegate = self
                self.navigationController?.pushViewController(cropImageVC, animated: true)
            })
            
        }
    }
    
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        self.navigationController?.popViewController(animated: true)
        let resizedImage = UIImage.resize(image: croppedImage, to: CGSize(width: 300, height: 300))
        self.handleSave(profileImage: resizedImage)
    }
}


