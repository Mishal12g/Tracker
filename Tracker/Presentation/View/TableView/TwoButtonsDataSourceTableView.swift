//
//  TwoButtonsDataSourceTableView.swift
//  Tracker
//
//  Created by mihail on 25.01.2024.
//

import UIKit

final class TwoButtonsDataSourceTableView: NSObject, UITableViewDataSource {
    private let words = ["Категория", "Расписание"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TwoButtonsCell", for: indexPath)
        
        cell.textLabel?.text = words[indexPath.row]
        cell.backgroundColor = .ypWhite
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
}
