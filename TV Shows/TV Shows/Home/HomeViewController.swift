//
//  HomeViewController.swift
//  TV Shows
//
//  Created by Infinum Academy 3 on 20.7.23.
//

import UIKit

class HomeViewController : UIViewController {
    
    //MARK: - Properties
    
    var userResponse: UserResponse?
    var authInfo: AuthInfo?
    
    //MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(authInfo?.accessToken)
    }
}
