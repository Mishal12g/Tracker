//
//  ColorCell.swift
//  Tracker
//
//  Created by mihail on 22.01.2024.
//

import UIKit

class ColorCell: UICollectionViewCell {
    static let identity = "ColorCell"
    
    let selectedView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.red.withAlphaComponent(0)
        view.layer.borderWidth = 4
        view.layer.cornerRadius = 16
        view.isHidden = true
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(selectedView)
        
        NSLayoutConstraint.activate([
            selectedView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -7),
            selectedView.topAnchor.constraint(equalTo: topAnchor, constant: -7),
            selectedView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 7),
            selectedView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 7),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setColor(_ color: UIColor) {
        selectedView.layer.borderColor = color.withAlphaComponent(0.5).cgColor
    }
}
