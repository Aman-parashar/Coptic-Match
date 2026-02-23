//
//  PremiumMembershipVC.swift
//  HalalDating
//
//  Created by Apple on 28/11/22.
//

import UIKit
import StoreKit
import Alamofire

class PremiumMembershipVC: UIViewController {

    // MARK: - Variable
    var subscriptionModel = SubscriptionModel()
    var remain_time = 0
    var timer_remainTime = Timer()
    var type_subscription = ""
    
    var strSubscriptionType = "Gold"
    var arrBenefits:[String]!
    var arrIcons:[String]!
    var timer:Timer?
    var arrProductIdentifiersGold:Set = ["com.HalalDatingApp.1Month.Gold","com.HalalDatingApp.3Month.Gold","com.HalalDatingApp.6Month.Gold"]
    var arrProductIdentifiersPremium:Set = ["com.LogosDatingApp.1Month.Premium.NonRenew","com.LogosDatingApp.3Month.Premium.NonRenew","com.LogosDatingApp.6Month.Premium.NonRenew"]
    
    var arrProducts:[SKProduct] = []
    var arrProductPrice = ["$24.99","$19.99/mo","$14.99/mo"]
    var arrProductDuration = ["1 month","3 months","6 months"]
    
    
    var strSelectedMonthTime = ""
    var strSelectedAmount = ""
    var strSelectedPlan = ""
    
    var intSelectedPlanIndex = 1
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var lblRemainingTime: UILabel!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var collview: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collviewPlans: UICollectionView!
    @IBOutlet weak var lblTitle1: UILabel!
    @IBOutlet weak var lblTitle2: UILabel!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var lblTerms: UILabel!
    @IBOutlet weak var lblAnd: UILabel!
    @IBOutlet weak var lblPrivacy: UILabel!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var viewBottom: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setLanguageUI()
        setupUI()
        startTimer()
        self.fetchProducts()
        
    }
    

    // MARK: - Function
    func setLanguageUI() {
        
        if Helper.shared.strLanguage == "ar"  {
            viewHeader.semanticContentAttribute = .forceRightToLeft
            collview.semanticContentAttribute = .forceRightToLeft
            viewBottom.semanticContentAttribute = .forceRightToLeft
            imgBack.semanticContentAttribute = .forceRightToLeft
            lblTitle2.semanticContentAttribute = .forceRightToLeft
        }
        //btnContinue.setTitle("Continue".localizableString(lang: Helper.shared.strLanguage), for: .normal)
        lblTerms.text = "Terms".localizableString(lang: Helper.shared.strLanguage)
        lblAnd.text = "and".localizableString(lang: Helper.shared.strLanguage)
        lblPrivacy.text = "Privacy Policy".localizableString(lang: Helper.shared.strLanguage)
        lblTitle1.text = "Recurring billing, cancel anytime".localizableString(lang: Helper.shared.strLanguage)
        //lblTitle2.text = "By tapping Continue, your payment will be charged to your account, and your subscription will automatically renew for the same package length at the same price until you cancel in your Account Settings at least 24 hour prior to the auto-renewal may be turned off by going to the user's Account Settings after purchase. By tapping Continue, you agree to our".localizableString(lang: Helper.shared.strLanguage)
    }
    func setupUI() {
        //for apple review
        let userModel = Login_LocalDB.getLoginUserModel()
        if userModel.data?.id == 25 {
            lblTitle2.isHidden = true
        }
        
        //
        if strSubscriptionType == "Gold" {
            arrBenefits = ["Like without limit"]
            arrIcons = ["ic_like_orange"]
            
            lblHeader.text = "Become a Gold member".localizableString(lang: Helper.shared.strLanguage)
            lblRemainingTime.isHidden = false
            subscriptionPlanAPI()
        } else {
            arrBenefits = ["Chat without limit","Like without limit","See who likes you","Increase your matches","Control your privacy"]
            arrIcons = ["ic_chat_a","ic_maritial_status","ic_no_likes","ic_marriage_goal","eye_hide"]
            
            lblHeader.text = "Find your partner faster with premium membership".localizableString(lang: Helper.shared.strLanguage)
            lblRemainingTime.isHidden = true
        }
        
        
        collview.register(UINib(nibName: "SubscriptionCell", bundle: nil), forCellWithReuseIdentifier: "SubscriptionCell")
        
        self.tabBarController?.tabBar.isHidden = true
        
    }
    func fetchProducts() {
        AppHelper.showLinearProgress()
        
        if strSubscriptionType == "Gold" {
            let request = SKProductsRequest(productIdentifiers: arrProductIdentifiersGold)
            request.delegate = self
            request.start()
        } else {
            let request = SKProductsRequest(productIdentifiers: arrProductIdentifiersPremium)
            request.delegate = self
            request.start()
        }
        
    }
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.scrollAutomatically), userInfo: nil, repeats: true)
    }
    @objc func scrollAutomatically(_ timer1: Timer) {
        
        if let coll  = collviewPlans {
            for cell in coll.visibleCells {
                let indexPath: IndexPath? = coll.indexPath(for: cell)
                if ((indexPath?.row)! < (arrBenefits.count) - 1){
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: (indexPath?.row)! + 1, section: (indexPath?.section)!)
                    
                    coll.scrollToItem(at: indexPath1!, at: .right, animated: true)
                }
                else{
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: 0, section: (indexPath?.section)!)
                    coll.scrollToItem(at: indexPath1!, at: .left, animated: true)
                }
                
            }
        }
    }
    @objc func timerAction_remainTime() {
        remain_time = remain_time - 1
        
        //--
        let time_ = secondsToHoursMinutesSeconds(remain_time)
        lblRemainingTime.text = "\(time_.0):\(time_.1):\(time_.2)"
        
        
        if remain_time <= 0{
            lblRemainingTime.text = "0:0:0"
            timer_remainTime.invalidate()
            //navigationController?.popViewController(animated: true)
        }
    }
    func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    // MARK: - Webservice
    func subscriptionPlanAPI()  {
        
        if NetworkReachabilityManager()!.isReachable == false
        {
            return
        }
        else
        {
            //--
            let dicParam:[String:AnyObject] = ["type": type_subscription as AnyObject]
            let userModel = Login_LocalDB.getLoginUserModel()
            AppHelper.showLinearProgress()
            self.view.isUserInteractionEnabled = false
            HttpWrapper.requestWithparamdictParamPostMethodwithHeader(url: a_subscriptionPlan, dicsParams: dicParam, headers: ["Authorization":userModel.data?.api_token ?? ""], completion: { [self] (response) in
                self.view.isUserInteractionEnabled = true
                AppHelper.hideLinearProgress()
                let dicsResponseFinal = response.replaceNulls(with: "")
                print(dicsResponseFinal as Any)
                
                subscriptionModel = SubscriptionModel(JSON: dicsResponseFinal as! [String : Any])!
                if subscriptionModel.code == 200{
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let date1 = dateFormatter.date(from:(subscriptionModel.data?.current_date_time)!)
                    let date2 = dateFormatter.date(from:(subscriptionModel.data?.end_date_time)!)
                    
                    //let date1 = dateFormatter.date(from:"2022-11-30 11:00:00")
                    //let date2 = dateFormatter.date(from:"2022-11-30 13:00:00")
                    
                    remain_time =  (date2?.seconds(from: date1!))!
                    timer_remainTime = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction_remainTime), userInfo: nil, repeats: true)
                    
                }else if subscriptionModel.code == 401{
                    AppHelper.Logout(navigationController: self.navigationController!)
                }else{
                    self.view.makeToast(dicsResponseFinal?.object(forKey: "message") as? String ?? "")
                }
            }) { (error) in
                print(error)
                self.view.isUserInteractionEnabled = true
                AppHelper.hideLinearProgress()
            }
        }
    }
    func purchaseSubscriptionAPI(transactionID:String) {
        
        if NetworkReachabilityManager()!.isReachable == false
        {
            return
        }
        AppHelper.showLinearProgress()
        
        let userModel = Login_LocalDB.getLoginUserModel()
        
        var dicParams:[String:String] = ["payment_method_nonce":transactionID,
                                         "amount":strSelectedAmount,
                                         "purchaseTime":Date().toString(dateFormat: "yyyy-MM-dd HH:mm:ss"),
                                         "plan":strSelectedPlan,
                                         "monthtime":strSelectedMonthTime]
        
        
        if strSubscriptionType == "Gold" {
            dicParams["type_swipe"] = SubscriptionType.swipe
            dicParams["type"] = "Gold"
        } else {
            dicParams["type_swipe"] = SubscriptionType.chat_swipe
            dicParams["type"] = "Premium"
        }
        
        
        let headers:HTTPHeaders = ["Accept":"application/json",
                                   "Authorization":userModel.data?.api_token ?? ""]
        
        AF.request(purchase_subscription, method: .post, parameters: dicParams, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            
            print(response)
            
            if let json = response.value as? [String:Any] {
                
                if json["status"] as? String == "Success" {
                    
                    //let dict = json["data"] as? [String:Any]
                    AppHelper.returnTopNavigationController().view.makeToast("Payment Success".localizableString(lang: Helper.shared.strLanguage))
                    self.navigationController?.popViewController(animated: false)
                    
                }
            }
            
            AppHelper.hideLinearProgress()
        }
    }
    
    
    // MARK: - IBAction
    
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func btnContinue(_ sender: Any) {
        
        if arrProducts[intSelectedPlanIndex] == nil {
            return
        }
        
        if SKPaymentQueue.canMakePayments() {
            
            let payment = SKPayment(product: (arrProducts[intSelectedPlanIndex]))
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
            
            //
            if intSelectedPlanIndex == 0 {
                strSelectedMonthTime = "1"
                strSelectedPlan = "1 month"
                if strSubscriptionType == "Gold" {
                    strSelectedAmount = "14.99"
                } else {
                    strSelectedAmount = "24.99"
                }
            } else if intSelectedPlanIndex == 1 {
                strSelectedMonthTime = "3"
                strSelectedPlan = "3 months"
                if strSubscriptionType == "Gold" {
                    strSelectedAmount = "20.99"
                } else {
                    strSelectedAmount = "59.99"
                }
            } else if intSelectedPlanIndex == 2 {
                strSelectedMonthTime = "6"
                strSelectedPlan = "6 months"
                if strSubscriptionType == "Gold" {
                    strSelectedAmount = "29.99"
                } else {
                    strSelectedAmount = "89.99"
                }
            }
        }
    }
    

}
extension PremiumMembershipVC:UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == collviewPlans {
            pageControl.numberOfPages = arrBenefits.count
            pageControl.isHidden = !((arrBenefits.count) > 1)
            return arrBenefits.count
        } else {
            return arrProducts.count 
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collviewPlans {
            let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "PlanBenefitsCell", for: indexPath) as! PlanBenefitsCell
            cell.img.image = UIImage(named: arrIcons[indexPath.row])
            cell.lblTitle.text = arrBenefits[indexPath.row].localizableString(lang: Helper.shared.strLanguage)
            return cell
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubscriptionCell", for: indexPath) as! SubscriptionCell
            
            cell.lbl1.text = arrProductDuration[indexPath.row]
            //cell.lbl2.text = "$\(arrProducts?[indexPath.row].price ?? 0)"
            
            cell.lbl3.text = arrProductPrice[indexPath.row]
            
            //
            
            if indexPath.row == 0 {
                cell.viewbgMain.layer.borderWidth = 1
                //cell.viewOffer.isHidden = true
                cell.viewSave.isHidden = true
                cell.lblBestOffer.text = "Basic"
            }
            if indexPath.row == 1 {
                cell.viewbgMain.layer.borderWidth = 1
                //cell.viewOffer.isHidden = true
                cell.viewSave.isHidden = true
                cell.lblBestOffer.text = "Most popular"
            }
            if indexPath.row == 2 {
                cell.viewbgMain.layer.borderWidth = 1
                //cell.viewOffer.isHidden = false
                cell.viewSave.isHidden = false
                cell.lblSave.text = "Save 50%"
                cell.lblBestOffer.text = "Best value"
            }
            
            if indexPath.row == intSelectedPlanIndex {
                cell.viewbgMain.layer.borderColor = #colorLiteral(red: 1, green: 0.3882352941, blue: 0.3882352941, alpha: 1)
            } else {
                cell.viewbgMain.layer.borderColor = UIColor.lightGray.cgColor
            }
            return cell
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == collview{
            
            //
            intSelectedPlanIndex = indexPath.row
            collview.reloadData()
            
            //
            //
            if intSelectedPlanIndex == 0 {
                btnContinue.setTitle("Upgrade for $24.99", for: .normal)
            } else if intSelectedPlanIndex == 1 {
                btnContinue.setTitle("Upgrade for $59.99", for: .normal)
            } else if intSelectedPlanIndex == 2 {
                btnContinue.setTitle("Upgrade for $89.99", for: .normal)
            }
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == collviewPlans {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        } else {
            return CGSize(width: (collectionView.frame.width/3)-10, height: collectionView.frame.height)
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == collviewPlans {
            pageControl?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        }
    }
    
}
extension PremiumMembershipVC: SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        
        if let products = response.products as? [SKProduct] {
            
            DispatchQueue.main.async {
                AppHelper.hideLinearProgress()
                
                let index1 = products.firstIndex{$0.productIdentifier == "com.LogosDatingApp.1Month.Premium.NonRenew"}
                let index2 = products.firstIndex{$0.productIdentifier == "com.LogosDatingApp.3Month.Premium.NonRenew"}
                let index3 = products.firstIndex{$0.productIdentifier == "com.LogosDatingApp.6Month.Premium.NonRenew"}
                
                self.arrProducts.removeAll()
                self.arrProducts.append(products[index1!])
                self.arrProducts.append(products[index2!])
                self.arrProducts.append(products[index3!])
                
                //self.arrProducts = products
                self.collview.reloadData()
                
                //select row programatically
                let indexPathForFirstRow = IndexPath(row: self.intSelectedPlanIndex, section: 0)
                self.collview.selectItem(at: indexPathForFirstRow, animated:false, scrollPosition: UICollectionView.ScrollPosition(rawValue: 0))
                self.collectionView(self.collview, didSelectItemAt: indexPathForFirstRow)
            }
            
//            print(product.localizedTitle)
//            print(product.localizedDescription)
//            print(product.priceLocale)
//            print(product.price)
//            print(product.productIdentifier)
            
        }
        

    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        AppHelper.showLinearProgress()
        
        for transaction in transactions {
            
            switch transaction.transactionState {
                
            case .purchased,.restored:
                
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
                AppHelper.hideLinearProgress()
                purchaseSubscriptionAPI(transactionID:transaction.transactionIdentifier!)
                break
            case .deferred,.failed:
                
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
                AppHelper.hideLinearProgress()
                break
            default:
                //AppHelper.hideLinearProgress()
                break
//                SKPaymentQueue.default().finishTransaction(transaction)
//                SKPaymentQueue.default().remove(self)
//                break
                
            }
        }
    }
    
}

