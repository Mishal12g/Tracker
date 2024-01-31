//
//  TextField.swift
//  Tracker
//
//  Created by mihail on 22.01.2024.
//

import UIKit

final class TextField: UITextField {
    
    //MARK: - init methods
    init(placeholder: String) {
        super.init(frame: .zero)
        addView(placeholder: placeholder)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - private methods
    private func addView(placeholder: String) {
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: frame.height))
        leftViewMode = .always
        clearButtonMode = .always
        layer.cornerRadius = 10
        backgroundColor = .ypWhite
        self.placeholder = placeholder
        translatesAutoresizingMaskIntoConstraints = false
    }
}

// MARK: - setup constraints
extension TextField {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 75)
        ])
    }
}
