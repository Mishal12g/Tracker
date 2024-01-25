//
//  TrackerCell.swift
//  Tracker
//
//  Created by mihail on 17.01.2024.
//

import UIKit

class TrackerCell: UICollectionViewCell {
    //MARK: static properties
    static let identity = "TrackerCell"
    
    //MARK: public properties
    let view: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .ypGreen
        
        return view
    }()
    
    let emojiView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 24 / 2
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)
        
        return view
    }()
    
    let emojiLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "🥲"
        
        return label
    }()
    
    let trackerNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
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
    
    //MARK: overrides methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        addContraints()
        view.layer.cornerRadius = 16
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: setup constraints
private extension TrackerCell {
    func addContraints() {
        contentView.addSubview(view)
        view.addSubview(emojiView)
        view.addSubview(emojiLabel)
        view.addSubview(trackerNameLabel)
        contentView.addSubview(countDaysLabel)
        contentView.addSubview(addButton)
       
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 90),
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            emojiView.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            emojiView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            emojiView.heightAnchor.constraint(equalToConstant: 24),
            emojiView.widthAnchor.constraint(equalToConstant: 24),
            
            emojiLabel.centerXAnchor.constraint(equalTo: emojiView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiView.centerYAnchor),
            
            trackerNameLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12),
            trackerNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            trackerNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            
            countDaysLabel.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 16),
            countDaysLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            countDaysLabel.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -12),
            
            addButton.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 8),
            addButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            addButton.heightAnchor.constraint(equalToConstant: 34),
            addButton.widthAnchor.constraint(equalToConstant: 34),
        ])
    }
}
