//
//  TabBarController.swift
//  YoriJori
//
//  Created by 김강현 on 7/20/24.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        self.setUpTabBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let recommendTab = UINavigationController(rootViewController: RecommendFoodViewController())
        let recommendTabBarItem = UITabBarItem(title: "음식 추천", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house"))
        recommendTab.tabBarItem = recommendTabBarItem
        
        let reportTab = UINavigationController(rootViewController: ReportViewController())
        let reportTabBarItem = UITabBarItem(title: "리포트", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house"))
        reportTab.tabBarItem = reportTabBarItem
        
        let homeTab = UINavigationController(rootViewController: HomeViewController())
        let homeTabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house"))
        homeTab.tabBarItem = homeTabBarItem
        
        let communityTab = UINavigationController(rootViewController: CommunityViewController())
        let communityTabBarItem = UITabBarItem(title: "커뮤니티", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house"))
        communityTab.tabBarItem = communityTabBarItem
        
        let myprofileTab = UINavigationController(rootViewController: MyProfileViewController())
        let myprofileTabBarItem = UITabBarItem(title: "내 정보", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house"))
        myprofileTab.tabBarItem = myprofileTabBarItem
        
        self.viewControllers = [recommendTab, reportTab, homeTab, communityTab, myprofileTab]
        self.selectedIndex = 0
    }
    
    private func setUpTabBar() {
        UITabBar.appearance().unselectedItemTintColor = .lightGray
        UITabBar.appearance().tintColor = DesignSystemColor.mainColor
        UITabBar.appearance().backgroundColor = .white
        
    }
    
}
