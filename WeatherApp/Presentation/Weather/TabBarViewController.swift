//
//  TabBarViewController.swift
//  WeatherApp
//
//  Created by 정유진 on 11/18/24.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()

    }
    
    private func setupTabBar() {
        
        let mainVC = WeatherViewController()
        mainVC.tabBarItem.image = UIImage.weatherIcon
       
        let searchVC = SearchViewController()
        searchVC.tabBarItem.image = UIImage.searchIcon
        
        let mainNav = UINavigationController(rootViewController: mainVC)
        let searchNav = UINavigationController(rootViewController: searchVC)
        
        self.viewControllers = [mainNav, searchNav]
    }
}
