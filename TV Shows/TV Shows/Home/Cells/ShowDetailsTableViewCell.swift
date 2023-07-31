//
//  ShowDetailsTableViewCell.swift
//  TV Shows
//
//  Created by Infinum Academy 3 on 28.7.23.
//

import UIKit

final class ShowDetailsTableViewCell: UITableViewCell {
    
    // MARK: - Private UI
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var ratingView: RatingView!
    
    // MARK: - Lifecycle methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ratingView.configure(withStyle: .large)
        ratingView.isEnabled = false
    }
    
    // MARK: - Configure

    func configure(with item: ShowResponse) {
        titleLabel.text = item.show.title
        descriptionLabel.text = item.show.description
        ratingView.rating = Int(item.show.averageRating!)
    }
}
