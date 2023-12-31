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
    
    // MARK: - Public properties
    
    var userResponse: UserResponse?
    var authInfo: AuthInfo?
    var currentPage = 1
    let itemsPerPage = 20
    
    // MARK: - Outlets
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var profileDetailsButton: UIButton!
    
    // MARK: - Private properties
    
    private var shows: [Show] = []
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        getShows()
        setupTableView()
        setUpProfileDetailsButton()
        logoutNotification()
    }
    
    // MARK: - Utility methods
    
    private func getShows() {
        guard let authInfo = authInfo else {
            return
        }
        MBProgressHUD.showAdded(to: view, animated: true)
        AF
            .request(
                "https://tv-shows.infinum.academy/shows",
                method: .get,
                parameters: ["page": "\(currentPage)", "items": "\(itemsPerPage)"],
                headers: HTTPHeaders(authInfo.headers)
            )
            .validate()
            .responseDecodable(of: ShowsResponse.self) { [weak self] response in
                guard let self = self else { return }
                MBProgressHUD.hide(for: self.view, animated: true)
                switch response.result {
                case .success(let showsResponse):
                    self.shows.append(contentsOf: showsResponse.shows)
                    tableView.reloadData()
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
    
    private func navigateToShowDetails(selectedShow: Show) {
        if let showDetailsViewController = UIStoryboard(name: "ShowDetails", bundle: nil).instantiateViewController(withIdentifier: "ShowDetailsViewController") as? ShowDetailsViewController {
            showDetailsViewController.id = selectedShow.id
            showDetailsViewController.authInfo = authInfo
            navigationController?.pushViewController(showDetailsViewController, animated: true)
        }
    }
    
    private func setUpNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func setUpProfileDetailsButton() {
        profileDetailsButton.addTarget(self, action: #selector(profileDetailsActionHandler), for: .touchUpInside)
        let profileButtonItem = UIBarButtonItem(customView: profileDetailsButton)
        navigationItem.rightBarButtonItem = profileButtonItem
    }
    
    private func logoutNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleLogoutNotification), name: .didLogout, object: nil)
    }
    
    @objc private func profileDetailsActionHandler() {
        guard let profileDetailsViewController = UIStoryboard(name: "ProfileDetails", bundle: nil).instantiateViewController(withIdentifier: "ProfileDetailsViewController") as? ProfileDetailsViewController else {
            return
        }
        profileDetailsViewController.authInfo = authInfo
        let navigationController = UINavigationController(rootViewController: profileDetailsViewController)
        present(navigationController, animated: true)
    }
    
    @objc private func handleLogoutNotification() {
        guard let loginViewController = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else {
            return
        }
        navigationController?.setViewControllers([loginViewController], animated:
                                                    true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .didLogout, object: nil)
    }
}

extension HomeViewController: UITableViewDelegate {
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == shows.count - 1 {
            currentPage += 1
            getShows()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let show = shows[indexPath.row]
        navigateToShowDetails(selectedShow: show)
    }
}

extension HomeViewController: UITableViewDataSource {
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: TVShowTableViewCell.self),
            for: indexPath
        ) as! TVShowTableViewCell
        cell.configure(with: shows[indexPath.row])
        return cell
    }
}

// MARK: - Private

private extension HomeViewController {
    func setupTableView() {
        tableView.estimatedRowHeight = 110
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
    }
}
