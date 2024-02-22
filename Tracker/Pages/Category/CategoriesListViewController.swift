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
    //MARK: - public properties
    weak var delegate: CategoriesListViewControllerDelegate?
    weak var isEnabledDelegate: HabitFormViewControllerProtocol?
    
    //MARK: - privates properties
    private let viewModel = CategoryViewModel()
    
    //MARK: UI
    private let tableView = UITableView()
    private let titleLabel = UILabel()
    private let emptyImageView = UIImageView()
    private let emptyLabel = UILabel()
    private let button = Button(type: .system)
    
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
        
        viewModel.categoriesBinding = { _ in
            self.tableView.reloadData()
            self.hideEmptyError()
        }
    }
    
    func hideEmptyError() {
        emptyLabel.isHidden = !viewModel.categories.isEmpty
        emptyImageView.isHidden = !viewModel.categories.isEmpty
    }
    
    func setUI() {
        //tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.identity)
        tableView.rowHeight = 75
        tableView.layer.cornerRadius = 16
        
        //titleLabel
        titleLabel.text = "Категория"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textAlignment = .center
        
        //emptyImageView
        guard let image = UIImage(named: "il_error_1") else { return }
        emptyImageView.image = image
        
        //emptyLabel
        emptyLabel.text = "Привычки и события можно объединить по смыслу"
        emptyLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        emptyLabel.textAlignment = .center
        emptyLabel.numberOfLines = 2
        
        //button
        button.setStyle(
            color: .black,
            tintColor: .white,
            title: "Добавить категорию"
        )
        button.addTarget(
            self,
            action: #selector(didTapCreateNewCategory),
            for: .touchUpInside
        )
    }
}

//MARK: - tableView dataSource
extension CategoriesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.identity, for: indexPath) as? CategoryCell else { return UITableViewCell()}
        
        cell.textLabel?.text = viewModel.categories[indexPath.row].title
        cell.backgroundColor = .ypWhite
        
        let isTopCell = indexPath.row == 0
        let isBottomCell = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
        
        if isTopCell, viewModel.categories.count == 1 {
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
        delegate?.selectedCategory(viewModel.categories[indexPath.item])
        isEnabledDelegate?.isEnabled()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CategoryCell else { return }
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
private extension CategoriesListViewController {
    func setupConstraints() {
        [titleLabel,
         tableView,
         emptyImageView,
         emptyLabel,
         button].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            tableView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -38),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            titleLabel.widthAnchor.constraint(equalToConstant: view.bounds.width),
            
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
