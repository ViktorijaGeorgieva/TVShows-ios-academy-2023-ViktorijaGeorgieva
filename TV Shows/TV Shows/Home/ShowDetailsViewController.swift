//
//  ShowDetailsViewController.swift
//  TV Shows
//
//  Created by Infinum Academy 3 on 27.7.23.
//

import UIKit
import MBProgressHUD
import Alamofire

final class ShowDetailsViewController: UIViewController {
    
    // MARK: - Outlets
    
    // MARK: - Private Properties
    
    private var reviews: [ReviewsResponse] = []
    private var showDetails: ShowResponse?
    
    // MARK: - Public Properties
    
    var id: String = ""
    var authInfo: AuthInfo?
    
    //MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        getShowDetails(id: id, authInfo: authInfo!)
        getReviews(id: id, authInfo: authInfo!)
    }
    
    //MARK: - Utility methods
    
    private func getShowDetails(id: String, authInfo: AuthInfo) {
        MBProgressHUD.showAdded(to: view, animated: true)
        AF
            .request(
                "https://tv-shows.infinum.academy/shows/\(id)",
                method: .get,
                headers: HTTPHeaders(authInfo.headers)
            )
            .validate()
            .responseDecodable(of: ShowResponse.self) { [weak self] response in
                guard let self = self else { return }
                MBProgressHUD.hide(for: self.view, animated: true)
                switch response.result {
                case .success(let showResponse):
                    showDetails = showResponse
                    print(showDetails)
                    //                    tableView.reloadData()
                case .failure(let error):
                    print("Failure: \(error)")
                }}
    }
    
    private func getReviews(id: String, authInfo: AuthInfo) {
        MBProgressHUD.showAdded(to: view, animated: true)
        AF
            .request(
                "https://tv-shows.infinum.academy/shows/\(id)/reviews",
                method: .get,
                headers: HTTPHeaders(authInfo.headers)
            )
            .validate()
            .responseDecodable(of: ReviewsResponse.self) { [weak self] response in
                guard let self = self else { return }
                MBProgressHUD.hide(for: self.view, animated: true)
                switch response.result {
                case .success(let reviewsResponse):
                    print("\(reviewsResponse)")
                    //tableView.reloadData()
                case .failure(let error):
                    print("Failure: \(error)")
                }
            }
    }
    
}
