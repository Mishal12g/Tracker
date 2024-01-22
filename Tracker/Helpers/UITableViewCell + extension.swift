//
//  UITableViewCell + extension.swift
//  Tracker
//
//  Created by mihail on 22.01.2024.
//

import UIKit

extension UITableViewCell {
    func style(_ index: Int) {
        self.accessoryType = .disclosureIndicator
        self.backgroundColor = .ypWhite
        self.textLabel?.text = index == 0 ? "Категория" : "Расписание"
    }
}
