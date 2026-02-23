//
//  Info3VC.swift
//  HalalDating
//
//  Created by Apple on 02/02/24.
//

import UIKit

class Info3VC: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var btnNext: UIButton!
    
    
    //MARK: - Veriable
    var userModel = UserModel()
    
    
    //MARK: - func
    override func viewDidLoad() {
        super.viewDidLoad()

        setLanguageUI()
    }

    
    func setLanguageUI() {
        
    }

    //MARK: - @IBAction
    @IBAction func btnNext(_ sender: Any) {
        //--
        let vc = NameVC(nibName: "NameVC", bundle: nil)
        vc.userModel = userModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}
