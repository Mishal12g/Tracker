//
//  ViewController.swift
//  Tracker
//
//  Created by mihail on 25.01.2024.
//

import UIKit

protocol CategoriesListViewControllerDelegate: AnyObject {
    func selectedCategory(_ category: TrackerCategory)
}

final class CategoriesListViewController: UIViewController {
    //MARK: public properties
    weak var delegate: CategoriesListViewControllerDelegate?
    weak var isEnabledDelegate: HabitFormViewControllerProtocol?
    
    //MARK: privates properties
    private lazy var categoryStore = TrackerCategoryStore(delegate: self)
    private lazy var categories: [TrackerCategory] = {
        let categoroies = categoryStore.objects()
        
        return categoroies
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.identity)
        table.rowHeight = 75
        table.layer.cornerRadius = 16
        
        return table
    }()
    
    private let titleLable: UILabel = {
        let label = UILabel()
        label.text = "Категория"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        
        return label
    }()
    
    private let emptyImageView: UIImageView = {
        guard let image = UIImage(named: "il_error_1") else { return UIImageView()}
        let imageView = UIImageView(image: image)
        
        return imageView
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Привычки и события можно объединить по смыслу"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 2
        
        return label
    }()
    
    private lazy var button: Button = {
        let button = Button(type: .system)
        button.setStyle(color: .black, tintColor: .white, title: "Добавить категорию")
        button.addTarget(self, action: #selector(didTapCreateNewCategory), for: .touchUpInside)
        
        return button
    }()
    
    //MARK: - overrides methods
    override func viewDidLoad() {
        super.viewDidLoad()
        commonSetup()
    }
}

//MARK: - privates methods
private extension CategoriesListViewController {
    @objc func didTapCreateNewCategory() {
        let vc = CategoryFormViewController()
        
        present(vc, animated: true)
    }
    
    func commonSetup() {
        view.backgroundColor = .white
        setupConstraints()
        hideEmptyError()
    }
    
    func hideEmptyError() {
        emptyLabel.isHidden = !categories.isEmpty
        emptyImageView.isHidden = !categories.isEmpty
    }
}

//MARK: - tableView dataSource
extension CategoriesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.identity, for: indexPath) as? CategoryCell else { return UITableViewCell()}
        
        cell.textLabel?.text = categories[indexPath.row].title
        cell.backgroundColor = .ypWhite
        
        let isTopCell = indexPath.row == 0
        let isBottomCell = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
        
        if isTopCell, categories.count == 1 {
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
extension CategoriesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CategoryCell else { return }
        cell.hideButton(false)
        delegate?.selectedCategory(categories[indexPath.item])
        isEnabledDelegate?.isEnabled()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CategoryCell else { return }
        cell.hideButton(true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        }
    }
}

extension CategoriesListViewController: StoreDelegate {
    func didUpdate() {
        self.categories = categoryStore.objects()
        hideEmptyError()
        tableView.reloadData()
    }
}

//MARK: - setup constraints
private extension CategoriesListViewController {
    func setupConstraints() {
        [titleLable,
         tableView,
         emptyImageView,
         emptyLabel,
         button].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLable.bottomAnchor, constant: 38),
            tableView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -38),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            titleLable.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            titleLable.widthAnchor.constraint(equalToConstant: view.bounds.width),
            
            emptyImageView.heightAnchor.constraint(equalToConstant: 80),
            emptyImageView.widthAnchor.constraint(equalToConstant: 80),
            emptyImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            emptyLabel.topAnchor.constraint(equalTo: emptyImageView.bottomAnchor, constant: 8),
            emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}
