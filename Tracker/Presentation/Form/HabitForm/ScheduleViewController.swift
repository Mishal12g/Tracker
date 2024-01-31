//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by mihail on 26.01.2024.
//

import UIKit

protocol ScheduleViewControllerDelegate: AnyObject {
    func setSchedule(_ weekdays: Set<Weekday>)
}

final class ScheduleViewController: UIViewController {
    //MARK: - public properties
    weak var delegate: ScheduleViewControllerDelegate?
    weak var isEnabledDelegate: HabitFormViewControllerProtocol?
    
    //MARK: - privates properties
    private var selectedDays = Set<Weekday>()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Расписание"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        return label
    }()
    
    lazy private var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.register(ScheduleCell.self, forCellReuseIdentifier: ScheduleCell.identity)
        table.rowHeight = 75
        table.layer.cornerRadius = 16
        table.allowsSelection = false
        
        return table
    }()
    
    lazy private var doneButton: Button = {
        let button = Button(type: .system)
        button.setStyle(color: .black, tintColor: .white, title: "Готово")
        button.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        
        return button
    }()
    
    //MARK: - overrides methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setConstraint()
    }
    
    //MARK: - action methods
    @objc func didTapDoneButton() {
        delegate?.setSchedule(selectedDays)
        isEnabledDelegate?.isEnabled()
        dismiss(animated: true)
    }
}

//MARK: - ScheduleCellDelegate
extension ScheduleViewController: ScheduleCellDelegate {
    func didAddDay(day: Weekday) {
        selectedDays.insert(day)
    }
    
    func didRemoveDay(day: Weekday) {
        selectedDays.remove(day)
    }
}

//MARK: - UITableViewDataSource
extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Weekday.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleCell.identity, for: indexPath) as? ScheduleCell else { return UITableViewCell()}
        cell.delegate = self
        cell.tag = indexPath.row
        cell.textLabel?.text = Weekday.allCases[indexPath.row].title
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        cell.backgroundColor = .ypWhite
        
        return cell
    }
}

//MARK: - UITableViewDelegate
extension ScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        }
        
        let isTopCell = indexPath.row == 0
        let isBottomCell = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
        
        if isTopCell {
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else if isBottomCell {
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            cell.layer.cornerRadius = 0
        }
    }
}

//MARK: - setup contstraint
private extension ScheduleViewController {
    func setConstraint() {
        view.addSubview(tableView)
        view.addSubview(doneButton)
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            titleLabel.widthAnchor.constraint(equalToConstant: view.bounds.width),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            tableView.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -47),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
