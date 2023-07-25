//
//  HomeViewController.swift
//  TV Shows
//
//  Created by Infinum Academy 3 on 20.7.23.
//

import UIKit
import MBProgressHUD
import Alamofire

final class HomeViewController : UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    
    var userResponse: UserResponse?
    var authInfo: AuthInfo?
    private var shows: [Show] = []
    
    //MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let authInfo = authInfo {
            print(authInfo.accessToken)
        }
        navigationController?.setNavigationBarHidden(true, animated: true)
        title = "Shows"
        getShows()
    }
    
    //MARK: - Utility methods
    
    private func getShows() {
        MBProgressHUD.showAdded(to: view, animated: true)
        AF
            .request(
              "https://tv-shows.infinum.academy/shows",
              method: .get,
              parameters: ["page": "1", "items": "100"],
              headers: HTTPHeaders(authInfo!.headers)
            )
            .validate()
            .responseDecodable(of: ShowsResponse.self) { [weak self] response in
                guard let self = self else { return }
                MBProgressHUD.hide(for: self.view, animated: true)
                switch response.result {
                case .success(let showsResponse):
                    shows = showsResponse.shows
                    tableView.reloadData()
                    print(shows[0].title)
                case .failure(let error):
                    print("Failure: \(error)")
                }}
    }
}
