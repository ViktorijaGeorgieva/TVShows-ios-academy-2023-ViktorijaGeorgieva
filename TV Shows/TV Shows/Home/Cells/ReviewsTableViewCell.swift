//
//  ReviewsTableViewCell.swift
//  TV Shows
//
//  Created by Infinum Academy 3 on 28.7.23.
//

import UIKit

final class ReviewsTableViewCell: UITableViewCell {
    
    // MARK: - Private UI
    
    @IBOutlet private weak var userEmail: UILabel!
    @IBOutlet private weak var ratingView: RatingView!
    @IBOutlet private weak var review: UILabel!
    
    // MARK: - Lifecycle methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ratingView.configure(withStyle: .small)
        ratingView.isEnabled = false
    }
    
    // MARK: - Configure

    func configure(with item: Review) {
        userEmail.text = item.user.email
        review.text = item.comment
        ratingView.rating = Int(item.rating)
    }
}

