//
//  EmojiCell.swift
//  Tracker
//
//  Created by mihail on 23.01.2024.
//

import UIKit

final class EmojiCell: UICollectionViewCell {
    //MARK: - static properties
    static let identity = "EmojiCell"
    
    //MARK: - public properties
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    //MARK: - overrides methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
