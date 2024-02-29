import UIKit

final class TabBarController: UITabBarController {
    //MARK: overrides methods
    override func viewDidLoad() {
        tabbarAppearance()
        
        let trackersListVC = UINavigationController(rootViewController: TrackersViewController())
        trackersListVC.tabBarItem = UITabBarItem(title: NSLocalizedString("tabbar.trackers.title", comment: ""), image: UIImage(named: "tracker"), selectedImage: nil)
        
        let statisticVC = UINavigationController(rootViewController: StatisticViewController())
        statisticVC.tabBarItem = UITabBarItem(title: NSLocalizedString("tabbar.statistic.title", comment: ""), image: UIImage(named: "statistic"), selectedImage: nil)
        
        self.viewControllers = [trackersListVC, statisticVC]
    }
}

private extension TabBarController {
    func tabbarAppearance() {
        tabBar.backgroundColor = .ypBackground
        let topLine = UIView(frame: CGRect(x: 0, y: 0, width: tabBar.frame.width, height: 1))
        topLine.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        tabBar.addSubview(topLine)
    }
}
