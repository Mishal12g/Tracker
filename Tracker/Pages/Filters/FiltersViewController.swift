//
//  FiltersViewController.swift
//  Tracker
//
//  Created by mihail on 05.03.2024.
//

import UIKit
//TODO: - Delegate под вопросом
protocol FiltersViewControllerDelegate: AnyObject {
    func allTrackersUpdate()
    func todayTrackersUpdate()
    func completedTrackersUpdate()
    func notCompletedTrackersUpdate()
}

final class FiltersViewController: UIViewController {
    weak var delegate: FiltersViewControllerDelegate?
    private let trackerStore = TrackerStore()
    private var filterTitle: String {
        get {
            UserDefaults.standard.string(forKey: "Filters") ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "Filters")
        }
    }
    
    //MARK: - UI
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 75
        tableView.layer.cornerRadius = 16
        tableView.separatorColor = .label.withAlphaComponent(0.3)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FilterCell.self, forCellReuseIdentifier: FilterCell.identity)
        
        return tableView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("filters", comment: "")
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        
        return label
    }()
    
    //MARK: - overrides methods
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = ["filters": FiltersList.allTrackers.rawValue]
        UserDefaults.standard.register(defaults: defaults)
        commonSetup()
    }
}

//MARK: - privates methods
private extension FiltersViewController {
    @objc func didTapCreateNewCategory() {
        let vc = CategoryFormViewController()
        
        present(vc, animated: true)
    }
    
    func commonSetup() {
        view.backgroundColor = .ypBackground
        setupConstraints()
    }
}

//MARK: - tableView dataSource
extension FiltersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return FiltersList.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FilterCell.identity, for: indexPath) as? FilterCell else { return UITableViewCell()}
        
        cell.textLabel?.text = FiltersList.allCases[indexPath.row].title
        cell.backgroundColor = .ypWhite
        
        if filterTitle == FiltersList.allCases[indexPath.item].rawValue {
            cell.hideButton(false)
        } else {
            cell.hideButton(true)
        }
        
        let isTopCell = indexPath.row == 0
        let isBottomCell = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
        
        if isTopCell, FiltersList.allCases.count == 1 {
            cell.layer.cornerRadius = 16
        } else if isTopCell {
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else if isBottomCell {
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            cell.layer.cornerRadius = 0
        }
        
        return cell
    }
}

//MARK: - tableView delegate
extension FiltersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let cell = tableView.cellForRow(at: indexPath) as? FilterCell
        else { return }
        cell.hideButton(false)
        
        tableView.reloadData()
        
        switch FiltersList.allCases[indexPath.item] {
        case .allTrackers:
            filterTitle = FiltersList.allTrackers.rawValue
            delegate?.allTrackersUpdate()
        case .todayTrackers:
            filterTitle = FiltersList.todayTrackers.rawValue
            delegate?.todayTrackersUpdate()
        case .completedTrackers:
            filterTitle = FiltersList.completedTrackers.rawValue
            delegate?.completedTrackersUpdate()
        case .notCompletedTrackers:
            filterTitle = FiltersList.notCompletedTrackers.rawValue
            delegate?.notCompletedTrackersUpdate()
        }
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? FilterCell else { return }
        cell.hideButton(true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.separatorInset = UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: 0,
                right: tableView.bounds.width
            )
        } else {
            cell.separatorInset = UIEdgeInsets(
                top: 0,
                left: 15,
                bottom: 0,
                right: 15
            )
        }
    }
}

//MARK: - setup constraints
private extension FiltersViewController {
    func setupConstraints() {
        [titleLabel,
         tableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            titleLabel.widthAnchor.constraint(equalToConstant: view.bounds.width)
        ])
    }
}

enum FiltersList: String, CaseIterable {
    case allTrackers = "filters.all"
    case todayTrackers = "filters.today"
    case completedTrackers = "filters.completed"
    case notCompletedTrackers = "filters.not.completed"
    
    var title: String {
        switch self {
        case .allTrackers:
            NSLocalizedString(FiltersList.allTrackers.rawValue, comment: "")
        case .todayTrackers:
            NSLocalizedString(FiltersList.todayTrackers.rawValue, comment: "")
        case .completedTrackers:
            NSLocalizedString(FiltersList.completedTrackers.rawValue, comment: "")
        case .notCompletedTrackers:
            NSLocalizedString(FiltersList.notCompletedTrackers.rawValue, comment: "")
        }
    }
}
