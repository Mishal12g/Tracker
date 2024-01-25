//
//  Button.swift
//  Tracker
//
//  Created by mihail on 24.01.2024.
//

import UIKit

final class Button: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setStyle(type: UIButton.ButtonType = .system,
                  color: UIColor = .white,
                  borderColor: UIColor = .white,
                  tintColor: UIColor = .black,
                  borderWidth: CGFloat = 0,
                  radius: CGFloat = 16,
                  title: String
    ) {
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = color
        layer.borderWidth = borderWidth
        layer.cornerRadius = radius
        layer.borderColor = borderColor.cgColor
        self.tintColor = tintColor
        setTitle(title, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
