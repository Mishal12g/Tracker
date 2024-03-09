//
//  TableView.swift
//  Tracker
//
//  Created by mihail on 25.01.2024.
//

import UIKit

final class TableView: UITableView {
    
    init(dataSource: UITableViewDataSource) {
        super.init(frame: .zero, style: .plain)
        translatesAutoresizingMaskIntoConstraints = false
        separatorColor = .label.withAlphaComponent(0.3)
        layer.cornerRadius = 16
        rowHeight = 150 / 2
        self.dataSource = dataSource
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
