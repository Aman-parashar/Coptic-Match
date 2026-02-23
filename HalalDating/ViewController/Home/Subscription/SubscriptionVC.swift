//
//  SubscriptionVC.swift
//  HalalDating
//
//  Created by Maulik Vora on 29/11/21.
//

import UIKit
import Alamofire
import Popover
import MobileCoreServices
import PassKit

class SubscriptionVC: UIViewController {
    //MARK: - @IBOutlet
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lbltitle_plan1: UILabel!
    @IBOutlet weak var lbldetail_plan1: UILabel!
    @IBOutlet weak var lbltitle_plan2: UILabel!
    @IBOutlet weak var lbldetail_plan2: UILabel!
    @IBOutlet weak var lbltitle_plan3: UILabel!
    @IBOutlet weak var lbldetail_plan3: UILabel!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var collectionPrice: UICollectionView!
    @IBOutlet weak var lblTerm_title: UILabel!
    @IBOutlet weak var lblTerm_detail: UILabel!
    @IBOutlet weak var lblTerm: UILabel!
    @IBOutlet weak var lblANd: UILabel!
    @IBOutlet weak var lblPrivacyPolicy: UILabel!
    @IBOutlet weak var viewbgBottomDetail: UIView!
    @IBOutlet var viewbg_paymentOption: UIView!
    
    
    //MARK: - Veriable
    var popover = Popover()
    var type_subscription = ""
    var subscriptionModel = SubscriptionModel()
    var remain_time = 0
    var timer_remainTime = Timer()
    
    //MARK: - func
    override func viewDidLoad() {
        super.viewDidLoad()
        setHeaderView()
        registerCell()
   
        //--
        apiCall_subscriptionPlan()
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
        
    }
    override func viewDidLayoutSubviews() {
        
        viewbgBottomDetail.roundCorners(corners: [.topLeft, .topRight], radius: 15.0)
    }
    func setHeaderView(){
        headerView.delegate_HeaderView = self
        headerView.progressBar.isHidden = true
        headerView.imgAppIcon.isHidden = true
        headerView.lblTitle.isHidden = false
        headerView.lblTitle.text = "Become a Gold member"
    }
    func registerCell(){
        collectionPrice.register(UINib(nibName: "SubscriptionCell", bundle: nil), forCellWithReuseIdentifier: "SubscriptionCell")
    }
    
    //MARK: - ApiCall
    func apiCall_subscriptionPlan()  {
        if NetworkReachabilityManager()!.isReachable == false
        {
            let alert = UIAlertController(title: internetConnectedTitle.localizableString(lang: Helper.shared.strLanguage), message: internetConnected.localizableString(lang: Helper.shared.strLanguage), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK".localizableString(lang: Helper.shared.strLanguage), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
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
                    //--
                    remain_time = Int(subscriptionModel.data?.remain_time ?? "0")!/1000
                    timer_remainTime = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction_remainTime), userInfo: nil, repeats: true)

                    //--
                    var index = 0
                    subscriptionModel.data?.plan.forEach({ subscriptionPlan in
                        if index == 0{
                            subscriptionPlan.isSelect = true
                        }
                        index = index + 1
                    })
                    collectionPrice.reloadData()
                    
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
    
    
    @objc func timerAction_remainTime() {
        remain_time = remain_time - 1
        
        //--
        let time_ = secondsToHoursMinutesSeconds(remain_time)
        lbldetail_plan1.text = "\(time_.0):\(time_.1):\(time_.2)"
        
        
        if remain_time <= 0{
            lbldetail_plan1.text = "0:0:0"
            timer_remainTime.invalidate()
        }
    }
    func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }

    //MARK: - @IBAction
    @IBAction func btnContinue(_ sender: Any) {
        
        ApplePayPayment()
        
        /*viewbg_paymentOption.frame.size = CGSize(width: self.view.frame.width-20, height: viewbg_paymentOption.frame.height)
        let aView = UIView()
        aView.frame = viewbg_paymentOption.frame
        aView.addSubview(viewbg_paymentOption)
        popover.dismissOnBlackOverlayTap = true
        popover.showAsDialog(aView, inView: self.view)*/
    }
    
    @IBAction func btnApplePay(_ sender: Any) {
        popover.dismiss()
        
    }
    
    @IBAction func btnGooglePay(_ sender: Any) {
        popover.dismiss()
        
    }
    
    //MARK: - Apple Pay
    func ApplePayPayment() {
        //--
        let filter = subscriptionModel.data?.plan.filter{$0.isSelect == true}
        
        var totalAmount = 0
        if filter?.count != 0{
            totalAmount = filter?.first?.price ?? 0
        }else{
            totalAmount = 0
        }
        
        //--
        let paymentItem = PKPaymentSummaryItem.init(label: kAlertTitle, amount: NSDecimalNumber(value: totalAmount))
        let paymentNetworks = [PKPaymentNetwork.amex, .discover, .masterCard, .visa]
        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentNetworks) {
            
            //--
            if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentNetworks) {
                let request = PKPaymentRequest()
                request.currencyCode = "USD" // 1
                request.countryCode = "US" // 2
                request.merchantIdentifier = "merchant.com.app.mindweel" // 3
                request.merchantCapabilities = PKMerchantCapability.capability3DS // 4
                request.supportedNetworks = paymentNetworks // 5
                request.paymentSummaryItems = [paymentItem] // 6
                
                guard let paymentVC = PKPaymentAuthorizationViewController(paymentRequest: request) else {
                    AppHelper.showAlert(kAlertTitle, message: "Unable to present Apple Pay authorization.")
                    //displayDefaultAlert(title: "Error", message: "Unable to present Apple Pay authorization.")
                    return
                }
                paymentVC.delegate = self
                self.present(paymentVC, animated: true, completion: nil)
            }
            
        } else {
            AppHelper.showAlert(kAlertTitle, message: "Unable to make Apple Pay transaction.")
        }
        
    }
}

extension SubscriptionVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.size.width
        //let height = collectionView.frame.size.height
        return CGSize(width: 120, height: 120)
        
        //        if #available(iOS 11.0, *) {
        //            let window = UIApplication.shared.keyWindow
        //            let topPadding = window?.safeAreaInsets.top
        //            let bottomPadding = window?.safeAreaInsets.bottom
        //
        //
        //            _ = UIScreen.main.bounds.size.height - topPadding! - bottomPadding! - 60//100.0
        //            return CGSize(width: width, height: collectionView.frame.size.height)
        //
        //        }else{
        //            let height = UIScreen.main.bounds.size.height - 122
        //
        //        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subscriptionModel.data?.plan.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubscriptionCell", for: indexPath) as! SubscriptionCell
        
        cell.lbl1.text = "\(subscriptionModel.data?.plan[indexPath.row].time ?? 0) \(subscriptionModel.data?.plan[indexPath.row].time_period ?? "")"
        cell.lbl2.text = "$\(subscriptionModel.data?.plan[indexPath.row].price ?? 0)"
        cell.lbl3.text = "$\(subscriptionModel.data?.plan[indexPath.row].per_month ?? "")"
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //--
        var index = 0
        subscriptionModel.data?.plan.forEach({ subscriptionPlan in
            if indexPath.row == index{
                subscriptionPlan.isSelect = true
            }else{
                subscriptionPlan.isSelect = false
            }
            index = index + 1
        })
        collectionPrice.reloadData()
        
    }
    
    
}

extension SubscriptionVC: HeaderView_Protocol{
    func btnBack() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension SubscriptionVC: PKPaymentAuthorizationViewControllerDelegate {
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        dismiss(animated: true, completion: nil)
    }
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        dismiss(animated: true, completion: nil)
        // Payment token can be found like this
        print(payment.token)
        // Get response from the server and set the PKPaymentAuthorizationStatus
        let status = PKPaymentAuthorizationStatus(rawValue: 0)!
        
        let transactionId = payment.token.transactionIdentifier
        
        switch status.rawValue {
        case 0:
            print("approved")
            // perform Functionality on Apple Pay Successfull Payment
            
            //apiCall__stripe_payment(stripetoken: transactionId, payUsing: "apple")
        //apiCall_subscriptionSave(id_: transactionId, is_paypal: false)
        default:
            print("failed")
            
        }
    }
    
    
}
