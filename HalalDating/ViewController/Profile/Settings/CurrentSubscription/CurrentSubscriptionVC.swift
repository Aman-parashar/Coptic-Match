//
//  CurrentSubscriptionVC.swift
//  HalalDating
//
//  Created by Maulik Vora on 29/11/21.
//

import UIKit
import Alamofire

class CurrentSubscriptionVC: UIViewController {

    //MARK: - @IBOutlet
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var lblPlanName: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblPaymentMode: UILabel!
    @IBOutlet weak var lblPurchaseDate: UILabel!
    @IBOutlet weak var lblExpiryDate: UILabel!
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view5: UIView!
    
    @IBOutlet weak var lblTitle1: UILabel!
    @IBOutlet weak var lblTitle2: UILabel!
    @IBOutlet weak var lblTitle3: UILabel!
    @IBOutlet weak var lblTitle4: UILabel!
    @IBOutlet weak var lblTitle5: UILabel!
    
    
    
    //MARK: - func
    override func viewDidLoad() {
        super.viewDidLoad()
        setLanguageUI()
        setHeaderView()
        mySubscriptionAPI()
    }
    func setLanguageUI() {
        
        if Helper.shared.strLanguage == "ar"  {
            headerView.semanticContentAttribute = .forceRightToLeft
            headerView.lblTitle.semanticContentAttribute = .forceRightToLeft
            view1.semanticContentAttribute = .forceRightToLeft
            view2.semanticContentAttribute = .forceRightToLeft
            view3.semanticContentAttribute = .forceRightToLeft
            view4.semanticContentAttribute = .forceRightToLeft
            view5.semanticContentAttribute = .forceRightToLeft
            
            lblTitle1.semanticContentAttribute = .forceRightToLeft
            lblTitle2.semanticContentAttribute = .forceRightToLeft
            lblTitle3.semanticContentAttribute = .forceRightToLeft
            lblTitle4.semanticContentAttribute = .forceRightToLeft
            lblTitle5.semanticContentAttribute = .forceRightToLeft
            
            lblPlanName.semanticContentAttribute = .forceRightToLeft
            lblStatus.semanticContentAttribute = .forceRightToLeft
            lblExpiryDate.semanticContentAttribute = .forceRightToLeft
            lblPaymentMode.semanticContentAttribute = .forceRightToLeft
            lblPurchaseDate.semanticContentAttribute = .forceRightToLeft
            
        }
        lblTitle1.text = "Plan name".localizableString(lang: Helper.shared.strLanguage)
        lblTitle2.text = "Status".localizableString(lang: Helper.shared.strLanguage)
        lblTitle3.text = "Payment mode".localizableString(lang: Helper.shared.strLanguage)
        lblTitle4.text = "Date of purchase".localizableString(lang: Helper.shared.strLanguage)
        lblTitle5.text = "Expiry date".localizableString(lang: Helper.shared.strLanguage)
    }
    func setHeaderView(){
        headerView.delegate_HeaderView = self
        headerView.progressBar.isHidden = true
        headerView.imgAppIcon.isHidden = true
        headerView.lblTitle.isHidden = false
        headerView.lblTitle.text = "My Subscription".localizableString(lang: Helper.shared.strLanguage)
    }

  //MARK: - Webservice
    func mySubscriptionAPI() {
        
        if NetworkReachabilityManager()!.isReachable == false
        {
            return
        }
        AppHelper.showLinearProgress()
        
        let userModel = Login_LocalDB.getLoginUserModel()
        
        
        let headers:HTTPHeaders = ["Accept":"application/json",
                                   "Authorization":userModel.data?.api_token ?? ""]
        
        AF.request(my_subscription, method: .post, parameters: [:], encoding: URLEncoding.default, headers: headers).responseJSON { response in
            
            print(response)
            
            if let json = response.value as? [String:Any] {
                
                if json["status"] as? String == "Success" {
                    
                    let arrPlans = json["data"] as? [[String:Any]]
                    
                    if arrPlans?.count ?? 0 > 0 {
                        
                        let dictPlan = arrPlans?.last
                        self.lblPlanName.text = "\((dictPlan?["type"] as? String ?? "").localizableString(lang: Helper.shared.strLanguage)) \((dictPlan?["plan"] as? String ?? "").localizableString(lang: Helper.shared.strLanguage))"
                        
                        if dictPlan?["is_active"] as? Int == 0 {
                            self.lblStatus.text = "Expired".localizableString(lang: Helper.shared.strLanguage)
                        } else {
                            self.lblStatus.text = "Active".localizableString(lang: Helper.shared.strLanguage)
                        }
                        
                        self.lblPaymentMode.text = "Online".localizableString(lang: Helper.shared.strLanguage)
                        
                        self.lblPurchaseDate.text = Helper.shared.changeDateFormat(fromFormat: "yyyy-MM-dd HH:mm:ss", toFormat: "dd/MM/yyyy", date: (dictPlan?["start_date"] as? String)!)
                        self.lblExpiryDate.text = Helper.shared.changeDateFormat(fromFormat: "yyyy-MM-dd HH:mm:ss", toFormat: "dd/MM/yyyy", date: (dictPlan?["expiry_date"] as? String)!)
                    }
                }
            }
            
            AppHelper.hideLinearProgress()
        }
    }

}

extension CurrentSubscriptionVC: HeaderView_Protocol{
    func btnBack() {
        self.navigationController?.popViewController(animated: true)
    }
}
