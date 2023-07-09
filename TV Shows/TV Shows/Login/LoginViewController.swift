//
//  LoginViewController.swift
//  TV Shows
//
//  Created by Infinum Academy 3 on 9.7.23.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    
    var numberOfTaps: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Do any additional setup after loading the view.
        
    }
    
    @IBAction func buttonActionHandler(_ sender: Any) {
        numberOfTaps += 1
        label.text = String(numberOfTaps)
    }
}
