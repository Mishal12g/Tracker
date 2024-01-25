//
//  TableViewCell.swift
//  Tracker
//
//  Created by mihail on 25.01.2024.
//

import UIKit

class CategoryCell: UITableViewCell {
    static let identity = "CategoryCell"
    
    let doneImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "done")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addSubview(doneImage)
        
        NSLayoutConstraint.activate([
            doneImage.heightAnchor.constraint(equalToConstant: 24),
            doneImage.widthAnchor.constraint(equalToConstant: 24),
            doneImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            doneImage.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
