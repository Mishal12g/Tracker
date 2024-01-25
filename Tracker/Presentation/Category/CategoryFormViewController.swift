//
//  FormCategoryViewController.swift
//  Tracker
//
//  Created by mihail on 25.01.2024.
//

import UIKit

final class CategoryFormViewController: UIViewController {
    private let titleLable: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
    }
}

//MARK: - setup constraints
extension CategoryFormViewController {
    func setupConstraints() {
        view.addSubview(titleLable)
        
        NSLayoutConstraint.activate([
            titleLable.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            titleLable.widthAnchor.constraint(equalToConstant: view.bounds.width),
        ])
    }
}
