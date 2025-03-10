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
        mainVC.tabBarItem.title = "날씨"
       
        let searchVC = SearchViewController()
        searchVC.tabBarItem.image = UIImage.searchIcon
        searchVC.tabBarItem.title = "검색"

        let searchNav = UINavigationController(rootViewController: searchVC)
        self.viewControllers = [searchNav, mainVC]
        tabBar.tintColor = UIColor.appBlack
        
        addBorderToTabBar()
    }
    
    private func addBorderToTabBar() {
        let borderView = UIView()
        borderView.backgroundColor = UIColor.lightGray
        
        tabBar.addSubview(borderView)
        
        borderView.snp.makeConstraints {
            $0.top.equalTo(tabBar.snp.top)
            $0.left.equalTo(tabBar.snp.left)
            $0.right.equalTo(tabBar.snp.right)
            $0.height.equalTo(0.5)
        }
    }
}
