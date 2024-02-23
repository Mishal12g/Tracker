//
//  ScheduleCell.swift
//  Tracker
//
//  Created by mihail on 26.01.2024.
//

import UIKit

protocol ScheduleCellDelegate: AnyObject {
    func didAddDay(day: Weekday)
    func didRemoveDay(day: Weekday)
}


final class ScheduleCell: UITableViewCell {
    //MARK: - static properties
    static let identity = "ScheduleCell"
    
    //MARK: - public properties
    weak var delegate: ScheduleCellDelegate?
    
    //MARK: - privates properties
    private var selectedDay: Weekday?
    
    //MARK: - views
    private let switchButton: UISwitch = {
        let switchButton = UISwitch()
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        switchButton.isEnabled = true
        switchButton.onTintColor = .ypBlue
        
        return switchButton
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraints()
        textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        switchButton.addTarget(self, action: #selector(didTapSwitch(_:)), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapSwitch(_ sender: UISwitch) {
        let index = tag
        let selectDay = Weekday.allCases[index]
        
        if sender.isOn {
            delegate?.didAddDay(day: selectDay)
        } else {
            delegate?.didRemoveDay(day: selectDay)
        }
    }
}

extension ScheduleCell {
    func config(_ selectDay: Weekday) {
        selectedDay = selectDay
    }
}

//MARK: - setup constraints
private extension ScheduleCell {
    func setConstraints() {
        contentView.addSubview(switchButton)
        
        NSLayoutConstraint.activate([
            switchButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            switchButton.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
