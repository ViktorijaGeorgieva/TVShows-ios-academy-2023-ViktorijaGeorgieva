//
//  LoginViewController.swift
//  TV Shows
//
//  Created by Infinum Academy 3 on 9.7.23.
//

import UIKit

final class LoginViewController: UIViewController {
    @IBOutlet private weak var numberOfTapsLabel: UILabel!
    @IBOutlet private weak var incrementButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var numberOfTaps: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        animateSpinner()
        
    }
    
    @IBAction private func incrementButtonPressed() {
        numberOfTaps += 1
        numberOfTapsLabel.text = String(numberOfTaps)
        animateSpinner()
    }
    
    private func setUpUI() {
        view.backgroundColor = .systemMint
        incrementButton.backgroundColor = .yellow
        incrementButton.layer.cornerRadius = 15
        numberOfTapsLabel.font = UIFont.systemFont(ofSize: 30)
    }
    
    private func animateSpinner() {
        if activityIndicator.isAnimating {
            activityIndicator.stopAnimating()
            incrementButton.setTitle("Start", for:  .normal)
        } else {
            activityIndicator.startAnimating()
            incrementButton.setTitle("Stop", for: .normal)
        }
    }
}
