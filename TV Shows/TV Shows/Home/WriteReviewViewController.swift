//
//  WriteReviewViewController.swift
//  TV Shows
//
//  Created by Infinum Academy 3 on 29.7.23.
//

import UIKit
import MBProgressHUD
import Alamofire

final class WriteReviewViewController: UIViewController {
    
    // MARK: - Public properties
    
    var showId: Int?
    var rating: Int?
    var comment: String?
    var authInfo: AuthInfo?
    weak var delegate: WriteReviewDelegate?
    
    // MARK: - Outlets
    
    @IBOutlet private weak var ratingView: RatingView!
    @IBOutlet private weak var commentTextField: UITextField!
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closeButton()
    }
    
    // MARK: - Actions
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        guard let showId = showId, let comment = commentTextField.text, let authInfo = authInfo else {
            return
        }
        MBProgressHUD.showAdded(to: view, animated: true)
        let parameters: [String: Any] = [
            "show_id": showId,
            "rating": ratingView.rating,
            "comment": comment
        ]
        AF
            .request(
                "https://tv-shows.infinum.academy/reviews",
                method: .post,
                parameters: parameters,
                headers: HTTPHeaders(authInfo.headers)
            )
            .validate()
            .responseDecodable(of: ReviewResponse.self) { [weak self] response in
                guard let self = self else { return }
                MBProgressHUD.hide(for: self.view, animated: true)
                switch response.result {
                case .success(let reviewResponse):
                    self.dismiss(animated: true, completion: {
                        self.delegate?.didAddReview(review: reviewResponse.review)
                    })
                case .failure(let error):
                    self.showAlert()
                }
            }
    }
    
    // MARK: - Utility methods
    
    @objc private func closeButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Error", message: "Failed to add review", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func closeButton() {
        let closeButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeButtonPressed))
        closeButton.tintColor = UIColor(red: 82/255.0, green: 54/255.0, blue: 140/255.0, alpha: 1)
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.title = "Write a Review"
    }
    
}

protocol WriteReviewDelegate: AnyObject {
    func didAddReview(review: Review)
}
