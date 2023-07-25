//
//  LoginViewController.swift
//  TV Shows
//
//  Created by Infinum Academy 3 on 9.7.23.
//

import UIKit
import MBProgressHUD
import Alamofire

final class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var rememberMeCheckboxButton: UIButton!
    @IBOutlet private weak var showPasswordButton: UIButton!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    
    // MARK: - Properties
    
    private var currentUserResponse: UserResponse?
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    // MARK: - Actions
    
    @IBAction private func rememberMeCheckboxStateChanged(_ sender: UIButton) {
        rememberMeCheckboxButton.isSelected.toggle()
    }
    
    @IBAction private func showPasswordStateChanged(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
        if passwordTextField.isSecureTextEntry {
            showPasswordButton.setImage(UIImage(named: "ic-visible.pdf"), for: UIControl.State.normal)
        } else {
            showPasswordButton.setImage(UIImage(named: "ic-invisible.pdf"), for: UIControl.State.normal)
        }
    }
    
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            return
        }
        
        MBProgressHUD.showAdded(to: view, animated: true)
        
        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]
        
        AF
            .request("https://tv-shows.infinum.academy/users/sign_in",
                   method: .post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default
            )
            .validate()
            .responseDecodable(of: UserResponse.self) { [weak self] response in
                guard let self = self else { return }
                MBProgressHUD.hide(for: self.view, animated: true)
                switch response.result {
                case .success(let userResponse):
                    let headers = response.response?.headers.dictionary ?? [:]
                    self.handleLoginSuccess(for: userResponse.user, headers: headers)
//                    navigateToHomeViewController()
                case .failure(let error):
                    print("Failure: \(error)")
                    showAlert(title: "Login failed", message: "Please enter valid email and password!")
                }
            }
    }
    
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            return
        }

        MBProgressHUD.showAdded(to: view, animated: true)

        let parameters: [String: String] = [
            "email": email,
            "password": password,
            "password_confirmation": password
        ]

        AF
            .request("https://tv-shows.infinum.academy/users",
                   method: .post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default
            )
            .validate()
            .responseDecodable(of: UserResponse.self) { [weak self] response in
                guard let self = self else { return }
                MBProgressHUD.hide(for: self.view, animated: true)
                switch response.result {
                case .success(let userResponse):
                    self.handleRegisterSuccess(userResponse: userResponse)
//                    navigateToHomeViewController()
                case .failure(let error):
                    print("Failure: \(error)")
                    showAlert(title: "Register failed", message: "Please enter email and password!")
                }
            }
    }
    
    //MARK: - Utility methods
    
    private func setUpUI() {
        rememberMeCheckboxButton.setImage(UIImage(named: "ic-checkbox-selected.pdf"), for: UIControl.State.selected)
        rememberMeCheckboxButton.setImage(UIImage(named: "ic-checkbox-unselected.pdf"), for: UIControl.State.normal)
    }
    
//    private func navigateToHomeViewController() {
//        if let viewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
//            navigationController?.pushViewController(viewController, animated: true)
//        }
//    }
    
    private func handleLoginSuccess(for user: User, headers: [String: String]) {
//        currentUserResponse = userResponse
//        print(userResponse.user.email)
//        print(userResponse.user.id)
//        print(userResponse.user.imageUrl)
        guard let authInfo = try? AuthInfo(headers: headers) else {
            return
        }
        if let viewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
            viewController.authInfo = authInfo
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    private func handleRegisterSuccess(userResponse: UserResponse){
        currentUserResponse = userResponse
//        print(userResponse.user.email)
//        print(userResponse.user.id)
//        print(userResponse.user.imageUrl)
        if let viewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
            viewController.userResponse = userResponse
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    private func showAlert(title: String, message: String) {
            let alertController = UIAlertController(
                title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            present(alertController, animated: true)
        }
}
