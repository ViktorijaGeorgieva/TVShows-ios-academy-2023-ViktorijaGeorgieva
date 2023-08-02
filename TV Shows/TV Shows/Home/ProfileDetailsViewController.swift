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

final class ProfileDetailsViewController: UIViewController {
    
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
            print("\(UserDefaults.standard)")
            NotificationCenter.default.post(name: .didLogout, object: nil)
        })
    }
    
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
            profileImageView.kf.setImage(with: URL(string: user.imageUrl!), placeholder: UIImage(named: "ic-profile-placeholder"))
        }
        email.text = user.email
    }
}
