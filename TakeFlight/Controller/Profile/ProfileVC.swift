//
//  ProfileVC.swift
//  TakeFlight
//
//  Created by Justin Erickson on 12/17/17.
//  Copyright © 2017 Justin Erickson. All rights reserved.
//

import UIKit
import FirebaseAuth
import RSKImageCropper

class ProfileVC: UIViewController {
    
    private struct Constants {
        static let toLoginVC = "ToLoginVC"
        static let toSignupVC = "ToSignupVC"
    }
    
    // MARK: Properties
    
    @IBOutlet weak var profileImageView: ProfileImageView!
    @IBOutlet weak var userStatusView: LoggedInStatusView!
    
    private var userPropertiesDidChangeListener: NSObjectProtocol?
    
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
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateViewForCurrentUser()
        addUserPropertiesDidChangeListener()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        removeUserPropertiesDidChangeListener()
    }
    
    // MARK: Setup
    
    private func setupView() {
        userStatusView.delegate = self
        profileImageView.addGestureRecognizer(editProfileImageRecognizer)
        profileImageView.layer.shadowColor = UIColor.black.cgColor
        profileImageView.layer.shadowOffset = CGSize.zero
        profileImageView.layer.shadowRadius = 10
    }
    
    // MARK: Convenience
    
    private func addUserPropertiesDidChangeListener() {
        userPropertiesDidChangeListener = NotificationCenter.default.addObserver(forName: .userPropertiesDidChange, object: nil, queue: nil, using: { _ in
            self.updateViewForCurrentUser()
        })
    }
    
    private func removeUserPropertiesDidChangeListener() {
        if let userPropertiesDidChangeListener = userPropertiesDidChangeListener {
            NotificationCenter.default.removeObserver(userPropertiesDidChangeListener)
        }
    }
    
    private func updateViewForCurrentUser() {
        self.setProfileImage()
        self.updateLoggedInStatusView()
    }
    
    private func updateLoggedInStatusView() {
        if let _ = UserDataService.instance.currentUser {
            if userStatusView.loggedInViewIsVisible {
                userStatusView.configureViewForCurrentUser(animated: false)
            } else {
                userStatusView.configureViewForCurrentUser(animated: true)
            }
        } else {
            if userStatusView.loggedInViewIsVisible {
                userStatusView.configureViewForCurrentUser(animated: true)
            } else {
                userStatusView.configureViewForCurrentUser(animated: false)
            }
        }
    }
    
    private func setProfileImage() {
        DispatchQueue.main.async {
            if let profileImage = UserDataService.instance.currentUser?.profileImage {
                self.profileImageView.image = profileImage
            } else {
                self.profileImageView.image = #imageLiteral(resourceName: "DefaultProfileImage")
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
        UserDataService.instance.saveToCurrentUser(profileImage: profileImage) { error in
            if let error = error, let navigationController = self.navigationController {
                let notification = DropDownNotification(text: error.localizedDescription)
                notification.presentNotification(onNavigationController: navigationController, forDuration: 3)
                return
            }
            self.profileImageView.image = profileImage
        }
    }
}

// MARK:- LoggedInStatusViewDelegate

extension ProfileVC: LoggedInStatusViewDelegate {
    
    func loggedInStatusView(_ loggedInStatusView: LoggedInStatusView, loginButtonWasTapped: Bool) {
        performSegue(withIdentifier: Constants.toLoginVC, sender: nil)
    }
    
    func loggedInStatusView(_ loggedInStatusView: LoggedInStatusView, signupButtonWasTapped: Bool) {
        performSegue(withIdentifier: Constants.toSignupVC, sender: nil)
    }
}

// MARK:- UIImagePickerControllerDelegate, UINavigationControllerDelegate

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
        self.handleSave(profileImage: croppedImage)
    }
}
