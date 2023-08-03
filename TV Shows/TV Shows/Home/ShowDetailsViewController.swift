//
//  ShowDetailsViewController.swift
//  TV Shows
//
//  Created by Infinum Academy 3 on 27.7.23.
//

import UIKit
import MBProgressHUD
import Alamofire

final class ShowDetailsViewController: UIViewController{
    
    // MARK: - Public Properties
    
    var id: String = ""
    var authInfo: AuthInfo?
    
    // MARK: - Outlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Private Properties
    
    private var reviews: [Review] = []
    private var showDetails: ShowResponse?
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        getShowDetails(id: id, authInfo: authInfo)
        getReviews(id: id, authInfo: authInfo)
        setupTableView()
    }
    
    // MARK: - Actions
    
    @IBAction func writeAReviewButtonPressed(_ sender: UIButton) {
        guard let writeReviewViewController = UIStoryboard(name: "WriteReview", bundle: nil).instantiateViewController(withIdentifier: "WriteReviewViewController") as? WriteReviewViewController else {
            return
        }
        guard let showId = showDetails?.show.id else {
            return
        }
        writeReviewViewController.showId = Int(showId)
        writeReviewViewController.authInfo = authInfo
        writeReviewViewController.delegate = self
        let navigationController = UINavigationController(rootViewController:
                                                            writeReviewViewController)
        present(navigationController, animated: true)
    }
    
    // MARK: - Utility methods
    
    private func getShowDetails(id: String, authInfo: AuthInfo?) {
        guard let authInfo = authInfo else { return }
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
                    tableView.reloadData()
                case .failure(let error):
                    print("Failure: \(error)")
                }}
    }
    
    private func getReviews(id: String, authInfo: AuthInfo?) {
        guard let authInfo = authInfo else { return }
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
                    self.reviews.append(contentsOf: reviewsResponse.reviews)
                    tableView.reloadData()
                case .failure(let error):
                    print("Failure: \(error)")
                }
            }
    }
}

extension ShowDetailsViewController: UITableViewDataSource {
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ShowDetailsTableViewCell.self), for: indexPath) as! ShowDetailsTableViewCell
            if let showDetails = showDetails {
                cell.configure(with: showDetails)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ReviewsTableViewCell.self), for: indexPath) as! ReviewsTableViewCell
            cell.configure(with: reviews[indexPath.row-1])
            return cell
        }
    }
}

extension ShowDetailsViewController: WriteReviewDelegate {
    func didAddReview(review: Review) {
        reviews.append(review)
        tableView.reloadData()
    }
}

// MARK: - Private

private extension ShowDetailsViewController {
    func setupTableView() {
        tableView.estimatedRowHeight = 140
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
    }
}
