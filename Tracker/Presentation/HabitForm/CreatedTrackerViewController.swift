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
    var delegate: CreatedTrackerViewControllerDelegate?
    
    init(delegate: CreatedTrackerViewControllerDelegate?) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let buttonOne: UIButton = {
        let button = ButtonForTextField(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitle("Привычка", for: .normal)
        
        return button
    }()
    
    private let buttonTwo: UIButton = {
        let button = ButtonForTextField(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitle("Нерегулярные событие", for: .normal)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(buttonOne)
        view.addSubview(buttonTwo)
        
        addConstraints()
        buttonOne.addTarget(self, action: #selector(habitDidTapButton), for: .touchUpInside)
    }
}

//MARK: For methods
private extension CreatedTrackerViewController {
    @objc func habitDidTapButton() {
        dismiss(animated: true)
        delegate?.didTapAddButton()
    }
    
    func addConstraints() {
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
