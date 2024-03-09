import UIKit

final class TabBarController: UITabBarController {
    //MARK: overrides methods
    override func viewDidLoad() {
        tabbarAppearance()
        
        let statisticVC = StatisticViewController()
        
        let trackersVC = TrackersViewController()
        trackersVC.delegate = statisticVC
        
        let navTrackersListVC = UINavigationController(rootViewController: trackersVC)
        navTrackersListVC.tabBarItem = UITabBarItem(title: NSLocalizedString("tabbar.trackers.title", comment: ""), image: UIImage(named: "tracker"), selectedImage: nil)
        
        let navStatisticVC = UINavigationController(rootViewController: statisticVC )
        statisticVC.tabBarItem = UITabBarItem(title: NSLocalizedString("tabbar.statistic.title", comment: ""), image: UIImage(named: "statistic"), selectedImage: nil)
        
        self.viewControllers = [navTrackersListVC, navStatisticVC]
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
