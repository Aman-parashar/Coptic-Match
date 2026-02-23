//
//  PremiumMembershipNewVC.swift
//  HalalDating
//
//  Created by Apple on 11/06/24.
//

import UIKit
import StoreKit
import SwiftyStoreKit
import Alamofire
import SwiftyJSON

protocol PremiumMembershipDelegate {
    func backButtonClicked()
}


class PremiumMembershipNewVC: UIViewController {
    
    
    // MARK: - Variable
    var delegate: PremiumMembershipDelegate?
    
    var subscriptionModel = SubscriptionModel()
    var remain_time = 0
    var timer_remainTime = Timer()
    var type_subscription = ""
    
    var strSubscriptionType = "Gold"
    var arrBenefits:[String]!
    var arrIcons:[String]!
    var timer:Timer?
    var arrProductIdentifiersPremium:Set = [
        "com.LogosDatingApp.Premium.AutoRenew.plan1",
        "com.LogosDatingApp.Premium.AutoRenew.plan2",
        "com.LogosDatingApp.Premium.AutoRenew.plan3",
        /*"com.LogosDatingApp.Premium.AutoRenew.plan4"*/
    ]
    
    var planIdentifiers = [
        "com.LogosDatingApp.Premium.AutoRenew.plan1",
        "com.LogosDatingApp.Premium.AutoRenew.plan2",
        "com.LogosDatingApp.Premium.AutoRenew.plan3",
        /*"com.LogosDatingApp.Premium.AutoRenew.plan4",*/
        ]
    
    var arrProducts:[SKProduct] = []
    var arrProductDuration = ["1 week","1 month","3 months"]
//    var arrProductPrice = ["$6.99/wk","$9.99/wk","$24.99"]

    
    var strSelectedMonthTime = ""
    var strSelectedAmount = ""
    var strSelectedPlan = ""
    
    var intSelectedPlanIndex = 1
    
    var verifyReceiptURL = ""//"https://sandbox.itunes.apple.com/verifyReceipt"//"https://buy.itunes.apple.com/verifyReceipt"
    
    // MARK: - IBOutlet
    @IBOutlet weak var lblRemainingTime: UILabel!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var collview: UICollectionView!
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
    @IBOutlet weak var heightCollview2: NSLayoutConstraint!
    @IBOutlet weak var heightCollview1: NSLayoutConstraint!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLanguageUI()
        setupUI()
        startTimer()
        retriveProductInfo()
        //        self.fetchProducts()
    }
    
    override func viewWillLayoutSubviews() {
        DispatchQueue.main.async {
            super.updateViewConstraints()
            self.heightCollview1?.constant = self.collviewPlans.contentSize.height
            self.heightCollview2?.constant = self.collview.contentSize.height
        }
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
        
        if strSubscriptionType == "Gold" {
            arrBenefits = ["Like without limit"]
            arrIcons = ["ic_like_orange"]
            
            lblHeader.text = "Become a Gold member".localizableString(lang: Helper.shared.strLanguage)
            lblRemainingTime.isHidden = false
            subscriptionPlanAPI()
        } else {
            arrBenefits = ["Chat without limit","Like without limit","See who likes you" ,"Control your privacy", "Send direct messages", "See received messages"]
            arrIcons = ["ic_chat_a","ic_maritial_status","ic_no_likes","ic_marriage_goal","eye_hide"]
            
            //lblHeader.text = "Find your partner faster with premium membership".localizableString(lang: Helper.shared.strLanguage)
            lblRemainingTime.isHidden = true
        }
        
        collview.register(UINib(nibName: "SubscriptionNewCell", bundle: nil), forCellWithReuseIdentifier: "SubscriptionNewCell")
//        self.tabBarController?.tabBar.isHidden = true
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
        
        if NetworkReachabilityManager()!.isReachable == false {
            return
        } else {
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
    
    func userSubscribeUnsubscribeAPI(flag:String) {
        if NetworkReachabilityManager()!.isReachable == false {
            return
        }
        
        let dicParams:[String:String] = ["flag":flag]
        //AppHelper.showLinearProgress()
        
        let userModel = Login_LocalDB.getLoginUserModel()
        
        let headers:HTTPHeaders = ["Accept":"application/json",
                                   "Authorization":userModel.data?.api_token ?? ""]
        
        AF.request(users_sub_or_unsubscribes, method: .post, parameters: dicParams, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            
            print(response)
            
            if let json = response.value as? [String:Any] {
                
                if json["status"] as? String == "Success" {
                    
                    let dict = json["data"] as? [String:Any]
                    
                    if dict?["is_buy_valid_subscription"] as? String == "0" || dict?["is_buy_valid_subscription"] as? String == "" {
                        
                    } else {
//                        AppHelper.returnTopNavigationController().view.makeToast("Success")
//                        self.navigationController?.popViewController(animated: false)
                    }
                }
            }
            //AppHelper.hideLinearProgress()
        }
    }
    
    func saveRenewalTransactionAPI(receipt: ReceiptItem) {
        
        if NetworkReachabilityManager()!.isReachable == false {
            AppHelper.hideLinearProgress()
            return
        }
        
        guard let expiryDate = receipt.subscriptionExpirationDate else {
            return
        }
        
        let dicParams:[String:Any] = ["original_transaction_id": receipt.originalTransactionId,
                                      "transaction_id": receipt.transactionId,
                                      "expires_date": expiryDate,
                                      "purchase_date": receipt.purchaseDate,
                                      "product_id": receipt.productId]
        
        let userModel = Login_LocalDB.getLoginUserModel()
        
        let headers:HTTPHeaders = ["Accept":"application/json",
                                   "Authorization":userModel.data?.api_token ?? ""]
        
        AF.request(save_renewal_transaction, method: .post, parameters: dicParams, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            AppHelper.hideLinearProgress()
            print(response)
            
            if let json = response.value as? [String:Any] {
                
                if json["status"] as? String == "Success" {
                    AppHelper.returnTopNavigationController().view.makeToast("Success")
                    self.delegate?.backButtonClicked()
                    self.navigationController?.popViewController(animated: false)
                }
            }
            
            //AppHelper.hideLinearProgress()
        }
    }
    
    func getExpirationDateFromResponse(_ jsonResponse: [String:Any]) -> Date? {
        if let receiptInfo = (jsonResponse["receipt"] as? [String:Any])?["in_app"] as? [[String:Any]] {//["latest_receipt_info"] as? [[String:Any]] {
            
            let lastReceipt = receiptInfo.last
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
            
            if let expiresDate = lastReceipt?["expires_date"] as? String {
                return formatter.date(from: expiresDate)
            }
            return nil
        }
        else {
            return nil
        }
    }
    
    
    
    // MARK: - IBAction
    @IBAction func btnBack(_ sender: Any) {
        delegate?.backButtonClicked()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnContinue(_ sender: Any) {
        self.purchaseProduct()
    }
    
    @IBAction func btnRestorePurchase(_ sender: Any) {
        restorePurchases()
    }
}



//MARK: - UICollectionView Delegate and DataSource
extension PremiumMembershipNewVC:UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collviewPlans {
            return arrBenefits.count
        } else {
            return arrProducts.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collviewPlans {
            let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "PlanBenefitsNewCell", for: indexPath) as! PlanBenefitsNewCell
            //cell.img.image = UIImage(named: arrIcons[indexPath.row])
            cell.lblTitle.text = arrBenefits[indexPath.row].localizableString(lang: Helper.shared.strLanguage)
            return cell
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubscriptionNewCell", for: indexPath) as! SubscriptionNewCell
            
            let arr = arrProductDuration[indexPath.row].components(separatedBy: " ")
            
            cell.lbl1.text = arr[0]
            cell.lbl2.text = arr[1]
            

            if indexPath.row == 2 {
                cell.lbl3.text = calculateMonthlyPrice(product: self.arrProducts[indexPath.row], forMonths: 12)
            } else if indexPath.row == 1 {
                cell.lbl3.text = calculateMonthlyPrice(product: self.arrProducts[indexPath.row], forMonths: 4)
            } else if indexPath.row == 0 {
                cell.lbl3.text = self.arrProducts[indexPath.row].localizedPrice
            }

            
            
            if indexPath.row == 0 {
                cell.viewOffer.isHidden = true
                cell.viewSave.isHidden = true
                cell.lblBestOffer.text = ""
            }
            if indexPath.row == 1 {
                cell.viewOffer.isHidden = false
                cell.viewSave.isHidden = false
                cell.lblSave.text = "Save 60%"
                cell.lblBestOffer.text = "Most popular"
            }
            if indexPath.row == 2 {
                cell.viewOffer.isHidden = false
                cell.viewSave.isHidden = false
                cell.lblSave.text = "Save 70%"
                cell.lblBestOffer.text = "Best value"
            }
            
            if indexPath.row == intSelectedPlanIndex {
                cell.viewbgMain.layer.borderColor = #colorLiteral(red: 0, green: 0.4470588235, blue: 0.6745098039, alpha: 1)
                cell.viewbgMain.backgroundColor = #colorLiteral(red: 0.8588235294, green: 0.9490196078, blue: 0.9960784314, alpha: 1)
                cell.viewbgMain.layer.borderWidth = 3
            } else {
                cell.viewbgMain.layer.borderColor = UIColor.lightGray.cgColor
                cell.viewbgMain.backgroundColor = .white
                cell.viewbgMain.layer.borderWidth = 1
            }
            return cell
        }
        
    }
    
    func calculateMonthlyPrice(product: SKProduct, forMonths months: Int) -> String {
//                let totalPrice = Decimal(23.99) //(for testing purposes)
        let totalPrice = product.price.decimalValue
        let totalWeeks = Decimal(months) // 4 weeks/month
        let weeklyPrice = (totalPrice / totalWeeks).truncated(toPlaces: 2)
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale // Use the product's locale
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        guard let formattedPrice = formatter.string(from: weeklyPrice as NSDecimalNumber) else {
            return ""
        }
        
//        let monthlyPrice = product.price
//        let weeklyPriceRaw = monthlyPrice.dividing(by: NSDecimalNumber(value: 4 * months))
//        
//        // 👇 Round down to nearest .99 (e.g., 7.23 → 6.99)
//        let weeklyDouble = weeklyPriceRaw.doubleValue
//        let floored = floor(weeklyDouble) // 6.9975 → 6.0
//        let marketingWeekly = floored + 0.99 // → 6.99
//        
//        // 💰 Format it with currency style
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .currency
//        formatter.locale = product.priceLocale
//        formatter.minimumFractionDigits = 2
//        formatter.maximumFractionDigits = 2
//        
//        guard let formattedWeeklyPrice = formatter.string(from: NSNumber(value: marketingWeekly)) else {
//            return "0/wk"
//        }
        
        return "\(formattedPrice)/wk"
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == collview{
            
            intSelectedPlanIndex = indexPath.row
            collview.reloadData()
            
            if intSelectedPlanIndex == 0 {
                btnContinue.setTitle("Get 1 week for \(self.arrProducts[indexPath.row].localizedPrice ?? "")", for: .normal)

            } else if intSelectedPlanIndex == 1 {
                btnContinue.setTitle("Get 1 month for \(self.arrProducts[indexPath.row].localizedPrice ?? "")", for: .normal)

            } else if intSelectedPlanIndex == 2 {
                btnContinue.setTitle("Get 3 month for \(self.arrProducts[indexPath.row].localizedPrice ?? "")", for: .normal)
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == collviewPlans {
            return CGSize(width: collectionView.frame.width, height: 30)
        } else {
            return CGSize(width: collectionView.frame.width, height: 80)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewWillLayoutSubviews()
    }
}



//MARK: - Purchase and Restore
extension PremiumMembershipNewVC {
    func purchaseProduct() {
        purchaseProduct(productID: planIdentifiers[intSelectedPlanIndex]) { isSuccess, message in
            if !isSuccess {
                self.view.makeToast(message)
                return
            }
        }
    }
    
    func retriveProductInfo() {
        AppHelper.showLinearProgress()
        
        SwiftyStoreKit.retrieveProductsInfo(arrProductIdentifiersPremium) { result in
            AppHelper.hideLinearProgress()
            
            if result.retrievedProducts.count > 0 {
                
                self.arrProducts.removeAll()
                
//                let plan4 = result.retrievedProducts.filter( { $0.productIdentifier == "com.LogosDatingApp.Premium.AutoRenew.plan4"})
                let plan3 = result.retrievedProducts.filter( { $0.productIdentifier == "com.LogosDatingApp.Premium.AutoRenew.plan3"})
                let plan2 = result.retrievedProducts.filter( { $0.productIdentifier == "com.LogosDatingApp.Premium.AutoRenew.plan2"})
                let plan1 = result.retrievedProducts.filter( { $0.productIdentifier == "com.LogosDatingApp.Premium.AutoRenew.plan1"})
                

                self.arrProducts.append(contentsOf: plan1)
                self.arrProducts.append(contentsOf: plan2)
                self.arrProducts.append(contentsOf: plan3)
//                self.arrProducts.append(contentsOf: plan4)
                
                self.collview.reloadData()
                
                //select row programatically
                let indexPathForFirstRow = IndexPath(row: self.intSelectedPlanIndex, section: 0)
                self.collview.selectItem(at: indexPathForFirstRow, animated:false, scrollPosition: UICollectionView.ScrollPosition(rawValue: 0))
                self.collectionView(self.collview, didSelectItemAt: indexPathForFirstRow)
                
            } else if let invalidProductId = result.invalidProductIDs.first {
                print("Invalid product identifier: \(invalidProductId)")
            }
            else {
                print("Error: \(String(describing: result.error))")
            }
        }
    }


    func purchaseProduct(productID: String, completion: @escaping (Bool, String) -> Void) {
        AppHelper.showLinearProgress()
        
        SwiftyStoreKit.purchaseProduct(productID, quantity: 1, atomically: true) { result in
//            AppHelper.hideLinearProgress()
            
            switch result {
            case .success(_):
                self.userSubscribeUnsubscribeAPI(flag: "1")
                self.validateSubscriptionReceipt(productID: productID)
                completion(true, "Payment Success".localizableString(lang: Helper.shared.strLanguage))
                break
                
            case .error(let error):
                AppHelper.hideLinearProgress()
                
                switch error.code {
                case .unknown: completion(false, "Unknown error. Please contact support")
                case .clientInvalid: completion(false, "Not allowed to make the payment")
                case .paymentCancelled: completion(false, "The payment has been canceled")
                case .paymentInvalid: completion(false, "The purchase identifier was invalid")
                case .paymentNotAllowed: completion(false, "The device is not allowed to make the payment")
                case .storeProductNotAvailable: completion(false, "The product is not available in the current storefront")
                case .cloudServicePermissionDenied: completion(false, "Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed: completion(false, "Could not connect to the network")
                case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                default: print((error as NSError).localizedDescription)
                }
            }
        }
    }
    
    
    func restorePurchases() {
        AppHelper.showLinearProgress()
        
        SwiftyStoreKit.restorePurchases { result in
            if result.restoreFailedPurchases.count > 0 {
                print("Restore Failed: \(result.restoreFailedPurchases)")
                AppHelper.hideLinearProgress()
                
            } else if result.restoredPurchases.count > 0 {

                let sorted = result.restoredPurchases.sorted(by: { $0.transaction.transactionDate! < $1.transaction.transactionDate!})
                self.validateSubscriptionReceipt(productID: sorted.last!.productId)
                
            } else {
                print("Nothing to restore")
                AppHelper.hideLinearProgress()
            }
        }
    }

    func validateSubscriptionReceipt(productID: String) {
        
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: "95e9212eb3f44fbe954e8f559b677bef")
        
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            
            switch result {
            case .success(let receipt):
                

                let productIds = Set([productID])
                let purchaseResult = SwiftyStoreKit.verifySubscriptions(productIds: productIds, inReceipt: receipt)
                
                switch purchaseResult {
                    
                case .purchased(let expiryDate, let items):
                    print("\(productIds) are valid until \(expiryDate)\n\(items)\n")
                    
                    // Get the latest transaction
                    if let latestTransaction = items.max(by: { $0.purchaseDate < $1.purchaseDate }) {
                        self.saveRenewalTransactionAPI(receipt: latestTransaction)
                    } else {
                        print("No valid transactions found")
                        AppHelper.hideLinearProgress()
                    }
                    
                case .expired(let expiryDate, let items):
                    print("\(productIds) are expired since \(expiryDate)\n\(items)\n")
                    self.userSubscribeUnsubscribeAPI(flag: "0")
                    AppHelper.hideLinearProgress()
                    
                case .notPurchased:
                    print("The user has never purchased \(productIds)")
                    AppHelper.hideLinearProgress()
                }
                
            case .error(_):
                break
            }
        }
    }
}


extension Decimal {
    func truncated(toPlaces places: Int) -> Decimal {
        var original = self
        var rounded = Decimal()
        NSDecimalRound(&rounded, &original, places, .down)
        return rounded
    }
}





//MARK: - Old code
extension PremiumMembershipNewVC {
    
    //    func fetchProducts() {
    //        AppHelper.showLinearProgress()
    //
    //        if strSubscriptionType == "Gold" {
    //            let request = SKProductsRequest(productIdentifiers: arrProductIdentifiersGold)
    //            request.delegate = self
    //            request.start()
    //        } else {
    //            let request = SKProductsRequest(productIdentifiers: arrProductIdentifiersPremium)
    //            request.delegate = self
    //            request.start()
    //        }
    //
    //    }

    
    //    func purchaseSubscriptionAPI(transactionID:String) {
    //
    //        if NetworkReachabilityManager()!.isReachable == false
    //        {
    //            return
    //        }
    //        AppHelper.showLinearProgress()
    //
    //        let userModel = Login_LocalDB.getLoginUserModel()
    //
    //        var dicParams:[String:String] = ["payment_method_nonce":transactionID,
    //                                         "amount":strSelectedAmount,
    //                                         "purchaseTime":Date().toString(dateFormat: "yyyy-MM-dd HH:mm:ss"),
    //                                         "plan":strSelectedPlan,
    //                                         "monthtime":strSelectedMonthTime]
    //
    //
    //        if strSubscriptionType == "Gold" {
    //            dicParams["type_swipe"] = SubscriptionType.swipe
    //            dicParams["type"] = "Gold"
    //        } else {
    //            dicParams["type_swipe"] = SubscriptionType.chat_swipe
    //            dicParams["type"] = "Premium"
    //        }
    //
    //
    //        let headers:HTTPHeaders = ["Accept":"application/json",
    //                                   "Authorization":userModel.data?.api_token ?? ""]
    //
    //        AF.request(purchase_subscription, method: .post, parameters: dicParams, encoding: URLEncoding.default, headers: headers).responseJSON { response in
    //
    //            print(response)
    //
    //            if let json = response.value as? [String:Any] {
    //
    //                if json["status"] as? String == "Success" {
    //
    //                    //let dict = json["data"] as? [String:Any]
    //                    AppHelper.returnTopNavigationController().view.makeToast("Payment Success".localizableString(lang: Helper.shared.strLanguage))
    //                    self.navigationController?.popViewController(animated: false)
    //
    //                }
    //            }
    //
    //            AppHelper.hideLinearProgress()
    //        }
    //    }

    //    func receiptValidation() {
    //
    //        //
    //        if let isRunningTestFlightBeta = Bundle.main.appStoreReceiptURL?.lastPathComponent as? String {
    //
    //            if isRunningTestFlightBeta == "sandboxReceipt" {//testflight&device(debug)
    //
    //                verifyReceiptURL = "https://sandbox.itunes.apple.com/verifyReceipt"//test
    //            } else if isRunningTestFlightBeta == "receipt" {//simulator & Live app
    //
    //                verifyReceiptURL = "https://buy.itunes.apple.com/verifyReceipt"//live
    //            } else {
    //                verifyReceiptURL = "https://buy.itunes.apple.com/verifyReceipt"//live
    //            }
    //
    //        }
    //
    //        //
    //        let receiptFileURL = Bundle.main.appStoreReceiptURL
    //        let receiptData = try? Data(contentsOf: receiptFileURL!)
    //        let recieptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
    //
    //        if recieptString == nil {
    //
    //            //recieptString comes nil, if user never subscribe or if user has active subscription but app gets uninstalled and then reinstalled. So in that case, we need to show Subscribe UI so user can buy plan or restore purchase respectively
    //            Helper.shared.isSubscriptionActive = "0"
    //            self.userSubscribeUnsubscribeAPI(flag: "0")
    //            return
    //        }
    //
    //
    //        let jsonDict: [String: AnyObject] = ["receipt-data" : recieptString! as AnyObject,
    //                                             "password" : "95e9212eb3f44fbe954e8f559b677bef" as AnyObject]
    //
    //        do {
    //            let requestData = try JSONSerialization.data(withJSONObject: jsonDict, options: JSONSerialization.WritingOptions.prettyPrinted)
    //            let storeURL = URL(string: verifyReceiptURL)!
    //            var storeRequest = URLRequest(url: storeURL)
    //            storeRequest.httpMethod = "POST"
    //            storeRequest.httpBody = requestData
    //
    //            AppHelper.showLinearProgress()
    //            let session = URLSession(configuration: URLSessionConfiguration.default)
    //            let task = session.dataTask(with: storeRequest, completionHandler: { [weak self] (data, response, error) in
    //
    //                DispatchQueue.main.async {
    //                    AppHelper.hideLinearProgress()
    //                }
    //
    //                if data == nil {
    //                    return
    //                }
    //                do {
    //                    let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
    //                    print("=======>",print(JSON.init(jsonResponse)))
    //
    //                    if (jsonResponse as? [String:Any])?["status"] as? Int == 0 {
    //
    //                        if let date = self?.getExpirationDateFromResponse(jsonResponse as! [String:Any]) {
    //                            print(date)
    //
    //                            if date < (Helper.shared.getCurrentDateGMT()) {
    //                                Helper.shared.isSubscriptionActive = "0"
    //                                self?.userSubscribeUnsubscribeAPI(flag: "0")
    //                            } else {
    //                                Helper.shared.isSubscriptionActive = "1"
    //                                self?.userSubscribeUnsubscribeAPI(flag: "1")
    //                            }
    //                        }
    //
    //                        if let receiptInfo = ((jsonResponse as? [String:Any])?["receipt"] as? [String:Any])?["in_app"] as? [[String:Any]] {
    //                            //for backend side use
    //                            if receiptInfo.count > 0 {
    //                                self?.saveRenewalTransactionAPI(receiptInfo: receiptInfo.last!)
    //                            }
    //                        }
    //
    //
    //
    //                    } else {
    //                        print((jsonResponse as? [String:Any])?["status"] as? Int)
    //                    }
    //
    //                } catch let parseError {
    //                    print(parseError)
    //                }
    //            })
    //            task.resume()
    //        } catch let parseError {
    //            print(parseError)
    //        }
    //    }

    
//    @IBAction func btnContinue(_ sender: Any) {
//        
//        self.purchaseProduct()
//        
//        if arrProducts[intSelectedPlanIndex] == nil {
//            return
//        }
//        
//        if SKPaymentQueue.canMakePayments() {
//            
//            let payment = SKPayment(product: (arrProducts[intSelectedPlanIndex]))
//            SKPaymentQueue.default().add(self)
//            SKPaymentQueue.default().add(payment)
//            
//            //
//            if intSelectedPlanIndex == 0 {
//                strSelectedMonthTime = "1"
//                strSelectedPlan = "1 month"
//                if strSubscriptionType == "Gold" {
//                    strSelectedAmount = "14.99"
//                } else {
//                    strSelectedAmount = "69.99"
//                }
//            } else if intSelectedPlanIndex == 1 {
//                strSelectedMonthTime = "3"
//                strSelectedPlan = "3 months"
//                if strSubscriptionType == "Gold" {
//                    strSelectedAmount = "20.99"
//                } else {
//                    strSelectedAmount = "34.99"
//                }
//            } else if intSelectedPlanIndex == 2 {
//                strSelectedMonthTime = "6"
//                strSelectedPlan = "6 months"
//                if strSubscriptionType == "Gold" {
//                    strSelectedAmount = "29.99"
//                } else {
//                    strSelectedAmount = "19.99"
//                }
//            }
//        }
//    }

}
