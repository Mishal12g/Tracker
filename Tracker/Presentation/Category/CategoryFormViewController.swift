//
//  FormCategoryViewController.swift
//  Tracker
//
//  Created by mihail on 25.01.2024.
//

import UIKit

final class CategoryFormViewController: UIViewController {
    //MARK: - Privates properties
    private let titleLable: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Новая категория"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        
        return label
    }()
    
    lazy private var button: Button = {
        let button = Button(type: .system)
        button.setStyle(color: .gray, tintColor: .white, title: "Готово")
        button.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        button.isEnabled = false
        
        return button
    }()
    
    lazy private var textField: TextField = {
        let textField = TextField(placeholder: "Введите название категории")
        textField.delegate = self
        textField.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        textField.becomeFirstResponder()
        
        return textField
    }()
    
    //MARK: - Overrides methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
        hideKeyBoard()
    }
    
    //MARK: - Actions methods
    @objc func didTapDoneButton() {
        guard let text = textField.text else { return }
        let category = TrackerCategory(title: text, trackers: [])
        CategoriesStorageService.shared.addCategory(category)
        dismiss(animated: true)
    }
    
    @objc func editingChanged(_ sender: TextField) {
        if let text = sender.text, !text.isEmpty {
            button.isEnabled = true
            button.backgroundColor = .black
        } else {
            button.isEnabled = false
            button.backgroundColor = .gray
        }
    }
    
    @objc func hideKeyboard() {
        textField.resignFirstResponder()
    }
}

//MARK: - UITableViewDelegate
extension CategoryFormViewController: UITextFieldDelegate {
    private func hideKeyBoard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - setup constraints
private extension CategoryFormViewController {
    func setupConstraints() {
        view.addSubview(titleLable)
        view.addSubview(textField)
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            titleLable.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            titleLable.widthAnchor.constraint(equalToConstant: view.bounds.width),
            
            textField.topAnchor.constraint(equalTo: titleLable.bottomAnchor, constant: 38),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}
