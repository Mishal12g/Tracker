//
//  Button.swift
//  Tracker
//
//  Created by mihail on 22.01.2024.
//

import UIKit

final class ButtonForTextField: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.tintColor = .white
        self.backgroundColor = .black
        self.layer.cornerRadius = 16
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setColor(color: UIColor) {
        self.backgroundColor = color
    }
}
