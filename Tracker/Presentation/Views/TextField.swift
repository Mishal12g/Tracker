//
//  TextField.swift
//  Tracker
//
//  Created by mihail on 22.01.2024.
//

import UIKit

final class TextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .systemGray4
        self.font = UIFont.systemFont(ofSize: 24)
        self.layer.cornerRadius = 16
        self.addPadding(.both(10))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
