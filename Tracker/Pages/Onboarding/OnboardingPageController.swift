//
//  OnboardingPageControllerViewController.swift
//  Tracker
//
//  Created by mihail on 21.02.2024.
//

import UIKit

class OnboardingPageController: UIPageViewController {
    //MARK: - public properties
    weak var sceneDelegate: SceneDelegate?
    
    //MARK: - privates properties
    private let pageControl = UIPageControl()
    private let doneButton = Button(type: .system)
    
    private lazy var vcOne: OnboardingViewController = {
        let text = "Отслеживайте только то, что хотите"
        guard let image = UIImage(named: "OnboardingOne") else { return OnboardingViewController(image: UIImage(), text: text)}
        
        return OnboardingViewController(
            image: image,
            text: text
        )
    }()
    
    private lazy var vcTwo: OnboardingViewController = {
        let text = "Даже если это не литры воды и йога"
        guard
            let image = UIImage(named: "OnboardingTwo")
        else {
            return OnboardingViewController(image: UIImage(), text: text)
        }
        
        return OnboardingViewController(image: image, text: text)
    }()
    
    private var pages: [UIViewController] {
        [vcOne, vcTwo]
    }
    
    //MARK: - overrides methods
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        setUI()
        setConstraints()
    }
}

//MARK: - for private methods
private extension OnboardingPageController {
    private func setUI() {
        [doneButton,
         pageControl].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        //setViewControllers
        if let first = pages.first {
            setViewControllers(
                [first],
                direction: .forward,
                animated: true
            )
        }
        
        //doneButton
        doneButton.setStyle(
            color: .black,
            tintColor: .white,
            title: "Вот это технологии!"
        )
        doneButton.addTarget(self, action: #selector(onTapDoneButton), for: .touchDown)
        
        //pageControl
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .gray.withAlphaComponent(0.5)
        pageControl.isUserInteractionEnabled = false
    }
    
    @objc func onTapDoneButton() {
        guard let sceneDelegate = sceneDelegate else { return }
        sceneDelegate.transitionWithOnboarding()
    }
}

//MARK: - UIPageViewControllerDataSource
extension OnboardingPageController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController) else { return nil }
        
        let previousIndex = index - 1
        
        guard previousIndex >= 0 else {
            return pages[pages.count - 1]
        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController) else { return nil }
        
        let nextIndex = index + 1
        
        guard nextIndex < pages.count else {
            return pages[0]
        }
        
        return pages[nextIndex]
    }
}

//MARK: - UIPageViewControllerDelegate
extension OnboardingPageController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentControllers = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentControllers) {
            pageControl.currentPage = currentIndex
        }
    }
}

//MARK: - set constraints
extension OnboardingPageController {
    func setConstraints() {
        NSLayoutConstraint.activate([
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -84),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            pageControl.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -24),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
}
