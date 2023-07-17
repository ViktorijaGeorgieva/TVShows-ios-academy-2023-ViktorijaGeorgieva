//
//  LoginViewController.swift
//  TV Shows
//
//  Created by Infinum Academy 3 on 9.7.23.
//

import UIKit

final class LoginViewController: UIViewController {
    @IBOutlet private weak var rememberMeCheckboxButton: UIButton!
    @IBOutlet private weak var showPasswordButton: UIButton!
    
    @IBOutlet private weak var passwordTextField: UITextField!
    private var rememberMeIsSelected: Bool = false
    private var showPasswordIsSelected: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
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
        if showPasswordIsSelected {
            passwordTextField.text = "1nf1num@/10st34m"
            showPasswordIsSelected = false
            showPasswordButton.setImage(UIImage(named: "ic-invisible.pdf"), for: UIControl.State.normal)
        } else {
            passwordTextField.text = "• • • • • • • • • • • • "
            showPasswordIsSelected = true
            showPasswordButton.setImage(UIImage(named: "ic-visible.pdf"), for: UIControl.State.normal)
        }
    }
}
