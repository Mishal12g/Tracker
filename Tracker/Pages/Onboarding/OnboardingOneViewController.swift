//
//  OnboardingOneViewController.swift
//  Tracker
//
//  Created by mihail on 21.02.2024.
//

import UIKit

class OnboardingViewController: UIViewController {
    //MARK: - privates properties
    private let onboardingImageView = UIImageView()
    private let label = UILabel()
    private let image: UIImage
    private let text: String
    
    //MARK: - overrides methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setConstraints()
    }
        
    init(image: UIImage, text: String) {
        self.image = image
        self.text = text
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Privates methods
    private func setUI() {
        [onboardingImageView,
         label].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        //ImageView
        onboardingImageView.image = image
        
        //label
        label.text = text
        label.numberOfLines = 3
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = .black
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
