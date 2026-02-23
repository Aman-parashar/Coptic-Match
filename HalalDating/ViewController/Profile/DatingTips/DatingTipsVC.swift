//
//  DatingTipsVC.swift
//  HalalDating
//
//  Created by Apple on 22/02/24.
//

import UIKit

class DatingTipsVC: UIViewController {

    // MARK: - Variable
    
    
    // MARK: - IBOutlet
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }


    // MARK: - Function
    func setupUI() {
        
        self.tabBarController?.tabBar.isHidden = true
    }
    // MARK: - IBAction

    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
