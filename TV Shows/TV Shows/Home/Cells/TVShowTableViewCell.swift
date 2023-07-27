//
//  TVShowTableViewCell.swift
//  TV Shows
//
//  Created by Infinum Academy 3 on 25.7.23.
//

import UIKit

final class TVShowTableViewCell: UITableViewCell {
    
    // MARK: - Private UI

    @IBOutlet private weak var titleLabel: UILabel!
    
    // MARK: - Configure

    func configure(with item: Show) {
        titleLabel.text = item.title
    }
}

