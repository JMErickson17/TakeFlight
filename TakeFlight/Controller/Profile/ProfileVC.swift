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
    
    private var authListener: NSObjectProtocol?
    private var userPropertiesDidChangeListener: NSObjectProtocol?
    
    private lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        return imagePicker
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

        removeuserPropertiesDidChangeListener()
    }
    
    // MARK: Setup
    
    private func setupView() {
        userStatusView.delegate = self
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleEditProfileImage)))
    }
    
    // MARK: Convenience
    
    private func addAuthListener() {
        authListener = NotificationCenter.default.addObserver(forName: .authStatusDidChange, object: nil, queue: nil, using: { _ in
            self.updateViewForCurrentUser()
        })
    }
    
    private func removeAuthListener() {
        if let authListener = authListener {
            NotificationCenter.default.removeObserver(authListener)
        }
    }
    
    private func addUserPropertiesDidChangeListener() {
        userPropertiesDidChangeListener = NotificationCenter.default.addObserver(forName: .userPropertiesDidChange, object: nil, queue: nil, using: { _ in
            self.updateViewForCurrentUser()
        })
    }
    
    private func removeuserPropertiesDidChangeListener() {
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
        if let profileImage = UserDataService.instance.currentUser?.profileImage {
            self.profileImageView.image = profileImage
        } else {
            self.profileImageView.image = #imageLiteral(resourceName: "DefaultProfileImage")
        }
        
    }
    
    @objc private func handleEditProfileImage() {
        present(imagePicker, animated: true, completion: nil)
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
