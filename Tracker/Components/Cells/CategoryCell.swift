//
//  TableViewCell.swift
//  Tracker
//
//  Created by mihail on 25.01.2024.
//

import UIKit

final class CategoryCell: UITableViewCell {
    //MARK: - static properties
    static let identity = "CategoryCell"
    
    //MARK: - public properties
    private let doneImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "done")?.withRenderingMode(.alwaysTemplate)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        
        return imageView
    }()
    
    //MARK: - override methods
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
    
    //MARK: - public methods
    func hideButton(_ isHidden: Bool) {
        doneImage.isHidden = isHidden
    }
}
