//
//  ButtonStackTitle.swift
//  Tracker
//
//  Created by mihail on 24.01.2024.
//

import UIKit

protocol ButtonStackTitleDelegate {
    func didTap()
}

final class ButtonStackTitle: UIView {
    private var colorAnimation = UIColor()
    private var colorButton = UIColor()
    
    var delegate: ButtonStackTitleDelegate?
    
    private let viewImage: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "chevrone")!
        image.tintColor = .black
        
        return image
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "one"
        label.font = UIFont.systemFont(ofSize: 17)
        
        return label
    }()
    
    private let labelTwo: UILabel = {
        let label = UILabel()
        label.text = "two"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .ypGray1
        return label
    }()
    
    private let stackH: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        
        return stack
    }()
    
    private let stackV: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        
        return stack
    }()
    
    init(titleOne: String,
         titleTwo: String?,
         titleOneIsHidden: Bool = false,
         titleTwoIsHidden: Bool = true,
         colorButton: UIColor = .ypWhite,
         colorAnimation: UIColor = .ypGray1
    ) {
        super.init(frame: .zero)
        commonSetup(titleOne: titleOne,
                    titleTwo: titleTwo,
                    titleOneIsHidden: titleOneIsHidden,
                    titleTwoIsHidden: titleTwoIsHidden,
                    colorButton: colorButton,
                    colorAnimation: colorAnimation)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: For methods
private extension ButtonStackTitle {
    func commonSetup(titleOne: String,
                     titleTwo: String?,
                     titleOneIsHidden: Bool,
                     titleTwoIsHidden: Bool,
                     colorButton: UIColor,
                     colorAnimation: UIColor) {
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = colorButton
        label.text = titleOne
        label.isHidden = titleOneIsHidden
        
        labelTwo.text = titleTwo
        labelTwo.isHidden = titleTwoIsHidden
        self.colorAnimation = colorAnimation
        self.colorButton = colorButton
        setConstraints()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        addGestureRecognizer(tapGesture)
        
        let pressGesture = UILongPressGestureRecognizer(target: self, action: #selector(viewPressed(_:)))
        addGestureRecognizer(pressGesture)
    }
    
    //MARK: - Actions
    @objc func viewTapped() {
        animateTap()
    }
    
    @objc private func viewPressed(_ gesture: UILongPressGestureRecognizer) {
        animatePressed(gesture)
    }
    
    //MARK: - Actuon animation
    func animateTap() {
        UIView.animate(withDuration: 0.2, animations: {
            self.backgroundColor = self.colorAnimation.withAlphaComponent(0.5)
        }, completion:{ isCompleted in
            if isCompleted {
                self.backgroundColor = self.colorButton
            }
        })
    }
    
    func animatePressed(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            // Начало нажатия
            UIView.animate(withDuration: 0.2) {
                self.backgroundColor = self.colorAnimation.withAlphaComponent(0.2)
            }
        } else if gesture.state == .ended || gesture.state == .cancelled {
            // Завершение или отмена нажатия
            UIView.animate(withDuration: 0.2) {
                self.backgroundColor = self.colorButton
            }
        }
    }
}

//MARK: - setup constraints
private extension ButtonStackTitle {
    func setConstraints() {
        addSubview(stackV)
        stackV.addArrangedSubview(label)
        stackV.addArrangedSubview(labelTwo)
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 75),
            widthAnchor.constraint(equalToConstant: 300),
            
            stackV.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            stackV.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            stackV.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackV.trailingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 15),
            
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 12),
            imageView.widthAnchor.constraint(equalToConstant: 7),
            
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
        ])
    }
}

