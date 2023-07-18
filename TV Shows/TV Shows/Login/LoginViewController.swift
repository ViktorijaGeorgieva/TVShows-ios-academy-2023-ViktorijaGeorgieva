//
//  LoginViewController.swift
//  TV Shows
//
//  Created by Infinum Academy 3 on 9.7.23.
//

import UIKit

final class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var rememberMeCheckboxButton: UIButton!
    @IBOutlet private weak var showPasswordButton: UIButton!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    
    // MARK: - Properties
    
    private var rememberMeIsSelected: Bool = false
    
    // MARK: -Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: -Actions
    
    @IBAction private func rememberMeCheckboxStateChanged(_ sender: UIButton) {
        if rememberMeIsSelected {
            rememberMeCheckboxButton.setImage(UIImage(named: "ic-checkbox-selected.pdf"), for: UIControl.State.normal)
            rememberMeIsSelected = false
        } else {
            rememberMeCheckboxButton.setImage(UIImage(named: "ic-checkbox-unselected.pdf"), for: UIControl.State.normal)
            rememberMeIsSelected = true
        }
    }
    
    @IBAction private func showPasswordStateChanged(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
        if passwordTextField.isSecureTextEntry {
            showPasswordButton.setImage(UIImage(named: "ic-visible.pdf"), for: UIControl.State.normal)
        } else {
            showPasswordButton.setImage(UIImage(named: "ic-invisible.pdf"), for: UIControl.State.normal)
        }
    }
    
    //MARK: -Utility methods
    
}
