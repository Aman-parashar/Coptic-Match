//
//  TabBarVC.swift
//  Melo
//
//  Created by Maulik Vora on 06/02/21.
//

import UIKit

class TabBarVC: UITabBarController, UITabBarControllerDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //let vc_Home = HomeVC(nibName: "HomeVC", bundle: nil)
        //let vc_Exclusive = ExclusiveVC(nibName: "ExclusiveVC", bundle: nil)
        //let controllers = [vc_Home, vc_Exclusive]
        
        //--
        //viewControllers = controllers
    }

   
/*
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 0{
            let vc = HomeVC(nibName: "HomeVC", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        }else if item.tag == 1{
            let vc = ExclusiveVC(nibName: "ExclusiveVC", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
 */
}
