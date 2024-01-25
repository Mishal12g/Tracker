////
////  TwoButtons.swift
////  Tracker
////
////  Created by mihail on 24.01.2024.
////
//
//import UIKit
//
//final class TwoButtons: UIView, ButtonStackTitleDelegate {
//    func didTap() {
//        print("dsa")
//    }
//    
//    private let divider: UIView = {
//       let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .systemGray4
//        
//        return view
//    }()
//    
//    lazy private var buttonOne: ButtonStackTitle = {
//        let button = ButtonStackTitle(titleOne: "Категория", titleTwo: "Важное", titleTwoIsHidden: false, delegate: self)
//        
//        return button
//    }()
//    
//    lazy private var buttonTwo: ButtonStackTitle = {
//        let button = ButtonStackTitle(titleOne: "Расписание", titleTwo: nil, delegate: self)
//        
//        return button
//    }()
//    
//    init() {
//        super.init(frame: .zero)
//        addSubview()
//        setConstraints()
//        translatesAutoresizingMaskIntoConstraints = false
//        backgroundColor  = .ypWhite
//        layer.masksToBounds = true
//        layer.cornerRadius = 16
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func addSubview() {
//        addSubview(divider)
//        addSubview(buttonOne)
//        addSubview(buttonTwo)
//    }
//}
//
////MARK: add constraints
//extension TwoButtons {
//    func setConstraints() {
//        let height: CGFloat = 150
//        NSLayoutConstraint.activate([
//            self.heightAnchor.constraint(equalToConstant: height),
//            
//            divider.centerYAnchor.constraint(equalTo: centerYAnchor),
//            divider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
//            divider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
//            divider.heightAnchor.constraint(equalToConstant: 0.5),
//            
//            buttonOne.topAnchor.constraint(equalTo: topAnchor),
//            buttonOne.heightAnchor.constraint(equalToConstant: height / 2),
//            buttonOne.leadingAnchor.constraint(equalTo: leadingAnchor),
//            buttonOne.trailingAnchor.constraint(equalTo: trailingAnchor),
//            
//            buttonTwo.topAnchor.constraint(equalTo: divider.bottomAnchor),
//            buttonTwo.heightAnchor.constraint(equalToConstant: height / 2),
//            buttonTwo.leadingAnchor.constraint(equalTo: leadingAnchor),
//            buttonTwo.trailingAnchor.constraint(equalTo: trailingAnchor),
//        ])
//    }
//}
