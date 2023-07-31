//
//  TVShowTableViewCell.swift
//  TV Shows
//
//  Created by Infinum Academy 3 on 25.7.23.
//

import UIKit
import Kingfisher

final class TVShowTableViewCell: UITableViewCell {
    
    // MARK: - Private UI

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var showImageView: UIImageView!
    
    // MARK: - Configure

    func configure(with item: Show) {
        titleLabel.text = item.title
        if let imageUrlString = item.imageUrl, let imageUrl = URL(string: imageUrlString) {
            showImageView.kf.setImage(with: imageUrl, placeholder: UIImage(named: "ic-show-placeholder-vertical"))
        } else {
            showImageView.image = UIImage(named: "ic-show-placeholder-vertical")
        }
    }
}

