//
//  TrackerCell.swift
//  Tracker
//
//  Created by mihail on 17.01.2024.
//

import UIKit

protocol TrackerCellDelegate: AnyObject {
    func completeTracker(id: UUID)
    func uncompleteTracker(id: UUID)
}

final class TrackerCell: UICollectionViewCell {
    //MARK: - static properties
    static let identity = "TrackerCell"
    
    //MARK: - privates properties
    private var isCompletedToday: Bool = false
    private(set) var trackerID: UUID?
    
    //MARK: - public properties
    weak var delegate: TrackerCellDelegate?
    
    private let view: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .ypGreen
        
        return view
    }()
    
    private let emojiView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 24 / 2
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)
        
        return view
    }()
    
    private let emojiLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()
    
    private let trackerNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        
        return label
    }()
    
    private lazy var countDaysLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0 дней."
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .label
        
        return label
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        button.layer.cornerRadius = 34 / 2
        
        return button
    }()
    
    //MARK: overrides methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        addContraints()
        view.layer.cornerRadius = 16
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - helpers
    func config(with tracker: Tracker,
                isCompletedToday: Bool,
                completedDays: Int) {
        self.isCompletedToday = isCompletedToday
        self.trackerID = tracker.id
        let tasksString = String.localizedStringWithFormat(
            NSLocalizedString(
                "numberOfDays",
                comment: "Number of remaining days"),
                completedDays
        )
        countDaysLabel.text = tasksString
        emojiLabel.text = tracker.emoji
        trackerNameLabel.text = tracker.name
        view.backgroundColor = tracker.color
        
        let image = UIImage(named: !isCompletedToday ? "add_icon" : "done_two")
        
        if isCompletedToday {
            addButton.backgroundColor = view.backgroundColor?.withAlphaComponent(0.5)
            addButton.tintColor = .systemBackground
        }       else {
            addButton.tintColor = .systemBackground
            addButton.backgroundColor = view.backgroundColor
        }
        addButton.setImage(image, for: .normal)
    }
    
    //MARK: action methods
    @objc func didTapAddButton() {
        guard let trackerID = trackerID else { return }
        if isCompletedToday {
            delegate?.uncompleteTracker(id: trackerID)
        } else {
            delegate?.completeTracker(id: trackerID)
        }
    }
}

//MARK: setup constraints
private extension TrackerCell {
    func addContraints() {
        contentView.addSubview(view)
        view.addSubview(emojiView)
        view.addSubview(emojiLabel)
        view.addSubview(trackerNameLabel)
        contentView.addSubview(countDaysLabel)
        contentView.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 90),
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            emojiView.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            emojiView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            emojiView.heightAnchor.constraint(equalToConstant: 24),
            emojiView.widthAnchor.constraint(equalToConstant: 24),
            
            emojiLabel.centerXAnchor.constraint(equalTo: emojiView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiView.centerYAnchor),
            
            trackerNameLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12),
            trackerNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            trackerNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            
            countDaysLabel.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 16),
            countDaysLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            countDaysLabel.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -12),
            
            addButton.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 8),
            addButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            addButton.heightAnchor.constraint(equalToConstant: 34),
            addButton.widthAnchor.constraint(equalToConstant: 34),
        ])
    }
}
