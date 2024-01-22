//
//  HabitFormViewController.swift
//  Tracker
//
//  Created by mihail on 22.01.2024.
//

import UIKit

final class HabitFormViewController: UIViewController {
    static let identity = "HabitFormViewControllerCell"
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.styleTwoButtons(height: 150)
        
        return tableView
    }()
    
    private let textField: UITextField = {
        let textField = TextField()
        textField.placeholder = "Введите название трекера"
        textField.addPadding(.both(16))
        
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: HabitFormViewController.identity)
        view.backgroundColor = .white
        view.addSubview(textField)
        view.addSubview(tableView)
        addContraints()
    }
}

//MARK: - For methods

private extension HabitFormViewController {
    func addContraints() {
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 75),
            
            tableView.heightAnchor.constraint(equalToConstant: 150),
            tableView.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
        ])
    }
}

extension HabitFormViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HabitFormViewController.identity , for: indexPath)
        cell.style(indexPath.row)
        
        return cell
    }
}

extension HabitFormViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
