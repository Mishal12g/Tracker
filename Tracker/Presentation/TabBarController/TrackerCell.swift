//
//  TrackerCell.swift
//  Tracker
//
//  Created by mihail on 17.01.2024.
//

import UIKit

class TrackerCell: UICollectionViewCell {
    static let identity = "TrackerCell"
    
    let view: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .ypGreen
        
        return view
    }()
    
    let emojiLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .systemGray
        label.text = "🥲"
        
        return label
    }()
    
    let trackerNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Полить цветы"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        
        return label
    }()
    
    let countDaysLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0 дней"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black
        
        return label
    }()
    
    let addButton: UIButton = {
        let image = UIImage(named: "add_icon")
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        button.tintColor = .ypGreen
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(view)
        view.addSubview(emojiLabel)
        view.addSubview(trackerNameLabel)
        contentView.addSubview(countDaysLabel)
        contentView.addSubview(addButton)
        
        addContraints()
        view.layer.cornerRadius = 16
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TrackerCell {
    func addContraints() {
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 90),
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            emojiLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            
            trackerNameLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12),
            trackerNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            trackerNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 12),
            
            countDaysLabel.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 16),
            countDaysLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            
            addButton.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 8),
            addButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            addButton.heightAnchor.constraint(equalToConstant: 34),
            addButton.widthAnchor.constraint(equalToConstant: 34),
        ])
    }
}
