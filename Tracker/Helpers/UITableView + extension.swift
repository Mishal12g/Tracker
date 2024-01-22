//
//  UITableView + extension.swift
//  Tracker
//
//  Created by mihail on 22.01.2024.
//

import UIKit

extension UITableView {
    func styleTwoButtons(height: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 16
        self.isScrollEnabled = false
        self.rowHeight = height / CGFloat(2)
    }
}
