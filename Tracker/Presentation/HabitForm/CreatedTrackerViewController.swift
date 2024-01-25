//
//  TrackerSelectionViewController.swift
//  Tracker
//
//  Created by mihail on 22.01.2024.
//

import UIKit

protocol CreatedTrackerViewControllerDelegate {
    func didTapAddButton()
}

final class CreatedTrackerViewController: UIViewController {
    //MARK: public properties
    var delegate: CreatedTrackerViewControllerDelegate?
    
    //MARK: - Init Methods
    init(delegate: CreatedTrackerViewControllerDelegate?) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - privates properties
    lazy private var buttonOne: UIButton = {
        let button = ButtonForTextField(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitle("Привычка", for: .normal)
        button.addTarget(self, action: #selector(habitDidTapButton), for: .touchUpInside)
        
        return button
    }()
    
    private let buttonTwo: UIButton = {
        let button = ButtonForTextField(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitle("Нерегулярные событие", for: .normal)
        
        return button
    }()
    
    //MARK: overrides methods
    override func viewDidLoad() {
        super.viewDidLoad()
        common()
    }
}

//MARK: private methods
private extension CreatedTrackerViewController {
    func common() {
        view.backgroundColor = .white
        addConstraints()
    }
    
    //MARK: action methods
    @objc func habitDidTapButton() {
        dismiss(animated: true)
        delegate?.didTapAddButton()
    }
}

//MARK: setup constraint
private extension CreatedTrackerViewController {
    func addConstraints() {
        view.addSubview(buttonOne)
        view.addSubview(buttonTwo)
        
        NSLayoutConstraint.activate([
            buttonOne.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonOne.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            buttonOne.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonOne.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            buttonOne.heightAnchor.constraint(equalToConstant: 60),
            
            buttonTwo.topAnchor.constraint(equalTo: buttonOne.bottomAnchor, constant: 16),
            buttonTwo.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonTwo.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            buttonTwo.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}
