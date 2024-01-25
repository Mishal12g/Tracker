//
//  ViewController.swift
//  Tracker
//
//  Created by mihail on 25.01.2024.
//

import UIKit

protocol CategoriesListViewControllerDelegate {
    func selectedCategory(_ category: TrackerCategory)
}

class CategoriesListViewController: UIViewController {
    var delegate: CategoriesListViewControllerDelegate?
    
    private var categories = CategoriesStorageService.shared.categories
    private var categoriesListObserver: NSObjectProtocol?
    
    lazy private var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.identity)
        table.rowHeight = 75
        table.layer.cornerRadius = 16
        table.separatorStyle = .singleLine
        
        return table
    }()
    
    private let titleLable: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Категория"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        
        return label
    }()
    
    private let emptyImageView: UIImageView = {
        guard let image = UIImage(named: "il_error_1") else { return UIImageView()}
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Привычки и события можно объединить по смыслу"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 2
        
        return label
    }()
    
    private let button: Button = {
        let button = Button(type: .system)
        button.setStyle(color: .black, tintColor: .white, title: "Добавить категорию")
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commonSetup()
    }
}

//MARK: - For methods
private extension CategoriesListViewController {
    func updatesTableView() {
        self.categories = CategoriesStorageService.shared.categories
        tableView.reloadData()
    }
    
    func commonSetup() {
        view.backgroundColor = .white
        setupConstraints()
        
        hideEmptyError(!categories.isEmpty ? true : false)
        
        categoriesListObserver = NotificationCenter.default.addObserver(forName: CategoriesStorageService.didChangeNotification,
                                                                        object: nil,
                                                                        queue: .main) { [weak self]_ in
            guard let self = self else { return }
            self.updatesTableView()
        }
    }
    
    func hideEmptyError(_ isHidden: Bool) {
        emptyLabel.isHidden = isHidden
        emptyImageView.isHidden = isHidden
    }
}

//MARK: - setup constraints
extension CategoriesListViewController {
    func setupConstraints() {
        view.addSubview(titleLable)
        view.addSubview(tableView)
        view.addSubview(emptyImageView)
        view.addSubview(emptyLabel)
        view.addSubview(button)
        
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

//MARK: - tableView dataSource
extension CategoriesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.identity, for: indexPath) as? CategoryCell else { return UITableViewCell()}
        
        cell.textLabel?.text = categories[indexPath.row].title
        cell.backgroundColor = .ypWhite
        
        if indexPath.item == 0 {
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        } else if indexPath.item == categories.count - 1 {
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
        
        return cell
    }
}

//MARK: - tableView delegate
extension CategoriesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CategoryCell else { return }
        cell.doneImage.isHidden = false
        delegate?.selectedCategory(categories[indexPath.item]) 
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CategoryCell else { return }
        cell.doneImage.isHidden = true
    }
}
