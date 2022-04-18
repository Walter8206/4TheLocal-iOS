//
//  HomeTabCViewController.swift
//  4TheLocal
//
//  Created by Mahamudul on 24/7/21.
//

import UIKit

class HomeTabC: UITabBarController {
    
    static let identifire = "HomeTabC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBar.appearance().tintColor = UIColor.red
        self.tabBar.unselectedItemTintColor = UIColor.black
    }
}
