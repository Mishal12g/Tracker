//
//  OnboardingOneViewController.swift
//  Tracker
//
//  Created by mihail on 21.02.2024.
//

import UIKit

class OnboardingOneViewController: UIViewController {
    //MARK: - privates properties
    private let onboardingImageView = UIImageView()
    private let label = UILabel()
    
    //MARK: - overrides methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setConstraints()
    }
    
    //MARK: Privates methods
    private func setUI() {
        [onboardingImageView,
         label].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        //ImageView
        guard let image = UIImage(named: "OnboardingOne") else { return }
        onboardingImageView.image = image
        
        //label
        label.text = "Отслеживайте только то, что хотите"
        label.numberOfLines = 3
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            onboardingImageView.topAnchor.constraint(equalTo: view.topAnchor),
            onboardingImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            onboardingImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            onboardingImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -304),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
}
