//
//  AdminAppovalVC.swift
//  HalalDating
//
//  Created by Vinit Shrivastav on 13/11/25.
//

import UIKit

class AdminAppovalVC: UIViewController {
    
    @IBOutlet weak var lblMessage: UILabel!
    var message: String?
    var isBackToHome: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        lblMessage?.text = message
        
    }
    
    @IBAction func btnBackTapped(_ sender: Any) {
        
        if isBackToHome {
            self.navigationController?.popToRootViewController(animated: true)
            return
        } else {
            //self.navigationController?.popViewController(animated: true)
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
