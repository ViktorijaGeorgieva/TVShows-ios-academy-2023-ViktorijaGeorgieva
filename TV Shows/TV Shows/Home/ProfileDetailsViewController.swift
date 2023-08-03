//
//  ProfileDetailsViewController.swift
//  TV Shows
//
//  Created by Infinum Academy 3 on 1.8.23.
//

import UIKit
import MBProgressHUD
import Alamofire
import Kingfisher

final class ProfileDetailsViewController: UIViewController, UINavigationControllerDelegate {
    
    // MARK: - Public properties
    
    var authInfo: AuthInfo?
    
    // MARK: - Outlets
    
    @IBOutlet private weak var email: UILabel!
    @IBOutlet private weak var profileImageView: UIImageView!
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        getUserInfo()
    }
    
    // MARK: - Actions
    
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: {
            UserDefaults.standard.removeObject(forKey: "AuthInfo")
            NotificationCenter.default.post(name: .didLogout, object: nil)
        })
    }
    
    
    @IBAction func changeProfilePhotoPressed(_ sender: UIButton) {
        openPhotoGallery()
    }
}

extension ProfileDetailsViewController: UIImagePickerControllerDelegate, UINavigationBarDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            storeImage(selectedImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Private

private extension ProfileDetailsViewController {
    
    // MARK: - Utility methods
    
    @objc private func closeButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    private func setUpNavigationBar() {
        let closeButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeButtonPressed))
        closeButton.tintColor = UIColor(red: 82/255.0, green: 54/255.0, blue: 140/255.0, alpha: 1)
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.title = "My Account"
    }
    
    private func getUserInfo() {
        guard let authInfo = authInfo else {
            return
        }
        MBProgressHUD.showAdded(to: view, animated: true)
        AF
            .request(
                "https://tv-shows.infinum.academy/users/me", method: .get, headers: HTTPHeaders(authInfo.headers)
            )
            .validate()
            .responseDecodable(of: UserResponse.self) { [weak self] response in
                guard let self = self else { return }
                MBProgressHUD.hide(for: self.view, animated: true)
                switch response.result {
                case .success(let userResponse):
                    self.updateUI(with: userResponse.user)
                case .failure(let error):
                    print("Failure: \(error)")
                }}
    }
    
    private func updateUI(with user: User) {
        if user.imageUrl == nil {
            profileImageView.image = UIImage(named: "ic-profile-placeholder")
        } else {
            guard let imageUrl = user.imageUrl else { return }
            profileImageView.kf.setImage(with: URL(string: imageUrl), placeholder: UIImage(named: "ic-profile-placeholder"))
        }
        email.text = user.email
    }
    
    private func openPhotoGallery() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    private func storeImage(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.9) else { return }
        let requestData = MultipartFormData()
        guard let authInfo = authInfo else {
            return
        }
        MBProgressHUD.showAdded(to: view, animated: true)
        requestData.append(imageData, withName: "image", fileName: "image.jpg", mimeType: "image/jpg")
        AF
            .upload(multipartFormData: requestData, to: "https://tv-shows.infinum.academy/users", method: .put, headers: HTTPHeaders(authInfo.headers))
            .validate()
            .responseDecodable(of: UserResponse.self) { [weak self]
                dataResponse in
                guard let self = self else { return }
                MBProgressHUD.hide(for: self.view, animated: true)
                switch dataResponse.result {
                case .success(let userResponse):
                    profileImageView.kf.setImage(with: URL(string: userResponse.user.imageUrl!), placeholder: UIImage(named: "ic-profile-placeholder"))
                case .failure(let error):
                    print("Image upload failed: \(error)")
                }
            }
    }
}
