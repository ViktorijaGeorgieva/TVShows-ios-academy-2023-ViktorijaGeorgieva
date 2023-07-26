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
    
    @IBOutlet private weak var tableView: UITableView!
    
    //MARK: - Private properties
    
    private var shows: [Show] = []

    //MARK: - Public properties
    
    var userResponse: UserResponse?
    var authInfo: AuthInfo?
    
    //MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        title = "Shows"
        getShows()
    }
    
    //MARK: - Utility methods
    
    private func getShows() {
        guard let authInfo = authInfo else {
            return
        }
        MBProgressHUD.showAdded(to: view, animated: true)
        AF
            .request(
              "https://tv-shows.infinum.academy/shows",
              method: .get,
              parameters: ["page": "1", "items": "100"],
              headers: HTTPHeaders(authInfo.headers)
            )
            .validate()
            .responseDecodable(of: ShowsResponse.self) { [weak self] response in
                guard let self = self else { return }
                MBProgressHUD.hide(for: self.view, animated: true)
                switch response.result {
                case .success(let showsResponse):
                    shows = showsResponse.shows
                case .failure(let error):
                    print("Failure: \(error)")
                    showAlert(title: "Request failed", message: "Fetching shows failed")
                }}
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(
            title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}
