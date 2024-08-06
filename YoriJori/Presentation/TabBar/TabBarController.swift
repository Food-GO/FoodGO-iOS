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
        let recommendTabBarItem = UITabBarItem(title: "", image: UIImage(named: "tab_food_unselected"), selectedImage: UIImage(named: "tab_food_selected")?.withRenderingMode(.alwaysOriginal))
        recommendTab.tabBarItem = recommendTabBarItem
        
        let reportTab = UINavigationController(rootViewController: ReportViewController())
        let reportTabBarItem = UITabBarItem(title: "", image: UIImage(named: "tab_report_unselected"), selectedImage: UIImage(named: "tab_report_selected")?.withRenderingMode(.alwaysOriginal))
        reportTab.tabBarItem = reportTabBarItem
        
        let homeTab = UINavigationController(rootViewController: HomeViewController())
        let homeTabBarItem = UITabBarItem(title: "", image: UIImage(named: "tab_home_unselected"), selectedImage: UIImage(named: "tab_home_selected")?.withRenderingMode(.alwaysOriginal))
        homeTab.tabBarItem = homeTabBarItem
        
        let communityTab = UINavigationController(rootViewController: CommunityViewController())
        let communityTabBarItem = UITabBarItem(title: "", image: UIImage(named: "tab_community_unselected"), selectedImage: UIImage(named: "tab_community_selected")?.withRenderingMode(.alwaysOriginal))
        communityTab.tabBarItem = communityTabBarItem
        
        let myprofileTab = UINavigationController(rootViewController: MyProfileViewController())
        let myprofileTabBarItem = UITabBarItem(title: "", image: UIImage(named: "tab_profile_unselected"), selectedImage: UIImage(named: "tab_profile_selected")?.withRenderingMode(.alwaysOriginal))
        myprofileTab.tabBarItem = myprofileTabBarItem
        
        self.viewControllers = [recommendTab, reportTab, homeTab, communityTab, myprofileTab]
        self.selectedIndex = 2
    }
    
    private func setUpTabBar() {
        UITabBar.appearance().unselectedItemTintColor = .lightGray
        UITabBar.appearance().tintColor = DesignSystemColor.mainColor
        UITabBar.appearance().backgroundColor = .white
        
    }
    
}
