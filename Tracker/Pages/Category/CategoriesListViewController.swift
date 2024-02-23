//
//  ViewController.swift
//  Tracker
//
//  Created by mihail on 25.01.2024.
//

import UIKit

final class CategoriesListViewController: UIViewController {
    //MARK: - public properties
    weak var isEnabledDelegate: HabitFormViewControllerProtocol?
    
    //MARK: - privates properties
    private var viewModel: CategoryViewModelProtocol
    
    //MARK: UI
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 75
        tableView.layer.cornerRadius = 16
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.identity)
        
        return tableView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Категория"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var emptyImageView: UIImageView = {
        guard let image = UIImage(named: "il_error_1") else {
            return UIImageView()
        }
        let imageView = UIImageView(image: image)
        
        return imageView
    }()
    
    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Привычки и события можно объединить по смыслу"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 2
        
        return label
    }()
    
    private lazy var button: Button = {
        let button = Button(type: .system)
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
        
        return button
    }()
    
    //MARK: - overrides methods
    override func viewDidLoad() {
        super.viewDidLoad()
        commonSetup()
    }
    
    init(viewModel: CategoryViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        viewModel.categoriesBinding = { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadData()
            self.hideEmptyError()
        }
    }
    
    func hideEmptyError() {
        emptyLabel.isHidden = !viewModel.categories.isEmpty
        emptyImageView.isHidden = !viewModel.categories.isEmpty
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
        viewModel.didSelected(at: indexPath)
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
