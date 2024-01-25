import UIKit

class TabBarController: UITabBarController {
    //MARK: overrides methods
    override func viewDidLoad() {
        tabbarAppearance()
        
        let trackersListVC = UINavigationController(rootViewController: TrackersViewController())
        trackersListVC.tabBarItem = UITabBarItem(title: "Трекеры", image: UIImage(named: "tracker"), selectedImage: nil)
        
        let statisticVC = StatisticViewController()
        statisticVC.tabBarItem = UITabBarItem(title: "Статистика", image: UIImage(named: "statistic"), selectedImage: nil)
        
        self.viewControllers = [trackersListVC, statisticVC]
    }
}

private extension TabBarController {
    func tabbarAppearance() {
        tabBar.backgroundColor = .white
        let topLine = UIView(frame: CGRect(x: 0, y: 0, width: tabBar.frame.width, height: 1))
        topLine.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        tabBar.addSubview(topLine)
    }
}
