//
//  FormCategoryViewController.swift
//  Tracker
//
//  Created by mihail on 25.01.2024.
//

import UIKit

final class CategoryFormViewController: UIViewController {
    private let categoryStore = TrackerCategoryStore()
    
    //MARK: - Privates properties
    private let titleLable: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("category.form.title", comment: "")
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var button: Button = {
        let button = Button(type: .system)
        button.setStyle(color: .gray, tintColor: .white, title: NSLocalizedString("category.form.button", comment: ""))
        button.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        button.isEnabled = false
        
        return button
    }()
    
    private lazy var textField: TextField = {
        let textField = TextField(placeholder: NSLocalizedString("category.form..textfield", comment: ""))
        textField.delegate = self
        textField.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        textField.becomeFirstResponder()
        
        return textField
    }()
    
    //MARK: - Overrides methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBackground
        setupConstraints()
        hideKeyBoard()
    }
    
    //MARK: - Actions methods
    @objc func didTapDoneButton() {
        guard let text = textField.text else { return }
        let category = TrackerCategory(id: UUID(), title: text, trackers: [])
        categoryStore.addCategory(category: category)
        dismiss(animated: true)
    }
    
    @objc func editingChanged(_ sender: TextField) {
        if let text = sender.text, !text.isEmpty {
            button.isEnabled = true
            button.backgroundColor = .label
            button.tintColor = .systemBackground
        } else {
            button.isEnabled = false
            button.tintColor = .white
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
        [button,
         textField,
         titleLable].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
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
