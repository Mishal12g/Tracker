//
//  TwoButtonsDataSourceTableView.swift
//  Tracker
//
//  Created by mihail on 25.01.2024.
//

import UIKit

final class TwoButtonsDataSourceTableView: NSObject, UITableViewDataSource {
    //MARK: - public properties
    var textOne: String?
    var textTwo: String?
    var countButtons = 2
    
    //MARK: - privates properties
    private let words = [NSLocalizedString("category.title.table.view", comment: ""), NSLocalizedString("schedule.title.table.view", comment: "")]
    
    //MARK: UITableViewDataSurce
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countButtons
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "TwoButtonsCell", for: indexPath)
        
        cell = UITableViewCell(style: .subtitle,
                               reuseIdentifier: "TwoButtonsCell")
        
        
        cell.textLabel?.text = words[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        cell.backgroundColor = .ypWhite
        cell.accessoryType = .disclosureIndicator
        cell.detailTextLabel?.text = indexPath.row == 0 ? textOne : textTwo
        cell.detailTextLabel?.textColor = .ypGray1
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        
        return cell
    }
}
