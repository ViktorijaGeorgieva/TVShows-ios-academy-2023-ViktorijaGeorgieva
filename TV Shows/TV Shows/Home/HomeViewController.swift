//
//  HomeViewController.swift
//  TV Shows
//
//  Created by Infinum Academy 3 on 20.7.23.
//

import UIKit

class HomeViewController : UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    
    var userResponse: UserResponse?
    var authInfo: AuthInfo?
    
    //MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let authInfo = authInfo {
            print(authInfo.accessToken)
        }
        navigationController?.setNavigationBarHidden(true, animated: true)
        title = "Shows"
    }
}
