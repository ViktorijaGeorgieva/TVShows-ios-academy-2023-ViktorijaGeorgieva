//
//  LoginViewController.swift
//  TV Shows
//
//  Created by Infinum Academy 3 on 9.7.23.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var numberOfTaps: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Do any additional setup after loading the view.
        view.backgroundColor = .systemMint
        button.backgroundColor = .yellow
        button.layer.cornerRadius = 15
        label.font = UIFont.systemFont(ofSize: 30)
        activityIndicator.startAnimating()
        
    }
    
    @IBAction func buttonActionHandler(_ sender: Any) {
        numberOfTaps += 1
        label.text = String(numberOfTaps)
        if activityIndicator.isAnimating {
            activityIndicator.stopAnimating()
            button.setTitle("Start", for:  .normal)
        } else {
            activityIndicator.startAnimating()
            button.setTitle("Stop", for: .normal)
        }
    }
}
