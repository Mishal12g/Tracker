//
//  TrackerSelectionViewController.swift
//  Tracker
//
//  Created by mihail on 22.01.2024.
//

import UIKit

protocol CreatedTrackerViewControllerDelegate: AnyObject {
    func didTapAddTrackerButton()
    func didTapAddNotRegularEvent()
}

final class CreatedTrackerViewController: UIViewController {
    //MARK: public properties
    weak var delegate: CreatedTrackerViewControllerDelegate?
    
    //MARK: - Init Methods
    init(delegate: CreatedTrackerViewControllerDelegate?) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - privates properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("created.tracker", comment: "")
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        return label
    }()

    private lazy var buttonOne: Button = {
        let button = Button(type: .system)
        button.setStyle(
            color: .label,
            tintColor: .systemBackground,
            title: NSLocalizedString("created.tracker.habit", comment: "")
        )
        
        button.addTarget(self, action: #selector(habitDidTapButton), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var buttonTwo: UIButton = {
        let button = Button(type: .system)
        button.setStyle(
            color: .label,
            tintColor: .systemBackground,
            title: NSLocalizedString("created.tracker.not.regular.event", comment: "")
        )

        button.addTarget(self, action: #selector(NotRegularEventTapButton), for: .touchUpInside)
        
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
        view.backgroundColor = .ypBackground
        addConstraints()
    }
    
    //MARK: action methods
    @objc func habitDidTapButton() {
        dismiss(animated: true)
        delegate?.didTapAddTrackerButton()
    }
    
    @objc func NotRegularEventTapButton() {
        dismiss(animated: true)
        delegate?.didTapAddNotRegularEvent()
    }
}

//MARK: setup constraint
private extension CreatedTrackerViewController {
    func addConstraints() {
        [buttonOne,
         buttonTwo,
         titleLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            titleLabel.widthAnchor.constraint(equalToConstant: view.bounds.width),
            
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
