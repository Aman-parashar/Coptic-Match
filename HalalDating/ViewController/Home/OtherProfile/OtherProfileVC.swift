//
//  OtherProfileVC.swift
//  HalalDating
//
//  Created by Maulik Vora on 28/11/21.
//

import UIKit
import Quickblox
import Alamofire

protocol ProfileDetails {
    func likeDislikeFromProfileDetails(likeStatus:Int, selectedIndex:Int)
    func backButtonClicked(flag:Bool)
}



class OtherProfileVC: UIViewController {
    
    //MARK: - @IBOutlet
    @IBOutlet weak var imgMain: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblAboutme_title: UILabel!
    @IBOutlet weak var collectionAboutMe: UICollectionView!
    @IBOutlet weak var imgSecond: UIImageView!
    @IBOutlet weak var lblMyLifeStyle_title: UILabel!
    @IBOutlet weak var collectionMylifeStyle: UICollectionView!
    @IBOutlet weak var lblMarriagegoals_title: UILabel!
    @IBOutlet weak var collectionMarriagegoals: UICollectionView!
    @IBOutlet weak var viewbg_chat: UIView!
    @IBOutlet weak var collectionImage: UICollectionView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var lblLanguage_title: UILabel!
    @IBOutlet weak var collectionLanguage: UICollectionView!
    @IBOutlet weak var heightCollLang: NSLayoutConstraint!
    @IBOutlet weak var imgLikeDislike: UIImageView!
    @IBOutlet weak var imgOnlineStatus: UIImageView!
    @IBOutlet weak var collectionImageOther: UICollectionView!
    @IBOutlet weak var pageControllerOther: UIPageControl!
    @IBOutlet weak var heightCollectionImageOther: NSLayoutConstraint!
    @IBOutlet weak var lblOnlineStatus: UILabel!
    @IBOutlet weak var lblOnlineDot: UILabel!
    
    
    
    
    //MARK: - Veriable
    var userData:UserData?
    var arrAbout:[String] = []
    var arrLanguage:[String] = []
    var arrMylifeStyle:[String] = []
    var arrMarriageGoals:[String] = []
    var arrDialogs:[QBChatDialog]?
    var delegate:ProfileDetails?
    var is_liked_count:Int?
    var intSelectedIndex:Int?
    var intUserId:Int?
    var arrOthePhotos:[User_Image] = []
    
    
    //MARK: - func
    override func viewDidLoad() {
        super.viewDidLoad()
        setLanguageUI()
        registerCell()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        
        //
        getUserDetailsAPI()
    }
    func setLanguageUI() {
        
        if Helper.shared.strLanguage == "ar"  {
            
            //            lblTitle.semanticContentAttribute = .forceRightToLeft
            //            lblDetail.semanticContentAttribute = .forceRightToLeft
            lblAboutme_title.semanticContentAttribute = .forceRightToLeft
            lblLanguage_title.semanticContentAttribute = .forceRightToLeft
            lblMarriagegoals_title.semanticContentAttribute = .forceRightToLeft
            lblMyLifeStyle_title.semanticContentAttribute = .forceRightToLeft
            collectionAboutMe.semanticContentAttribute = .forceRightToLeft
            collectionLanguage.semanticContentAttribute = .forceRightToLeft
            collectionMarriagegoals.semanticContentAttribute = .forceRightToLeft
            collectionMylifeStyle.semanticContentAttribute = .forceRightToLeft
        }
        lblAboutme_title.text = "About me".localizableString(lang: Helper.shared.strLanguage)
        lblLanguage_title.text = "Language I speak".localizableString(lang: Helper.shared.strLanguage)
        lblMarriagegoals_title.text = "Marriage goals".localizableString(lang: Helper.shared.strLanguage)
        lblMyLifeStyle_title.text = "My lifestyle".localizableString(lang: Helper.shared.strLanguage)
    }
    
    func registerCell(){
        collectionImage.register(UINib(nibName: "ProfileImageCell", bundle: nil), forCellWithReuseIdentifier: "ProfileImageCell")
        collectionAboutMe.register(UINib(nibName: "ProfileQuestionCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ProfileQuestionCollectionCell")
        collectionLanguage.register(UINib(nibName: "ProfileQuestionCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ProfileQuestionCollectionCell")
        collectionMylifeStyle.register(UINib(nibName: "ProfileQuestionCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ProfileQuestionCollectionCell")
        collectionMarriagegoals.register(UINib(nibName: "ProfileQuestionCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ProfileQuestionCollectionCell")
        collectionImageOther.register(UINib(nibName: "ProfileImageCell", bundle: nil), forCellWithReuseIdentifier: "ProfileImageCell")
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        DispatchQueue.main.async {
            let height = self.collectionLanguage.collectionViewLayout.collectionViewContentSize.height
            self.heightCollLang.constant = height
            
            let height2 = self.collectionImageOther.collectionViewLayout.collectionViewContentSize.height
            self.heightCollectionImageOther.constant = height2
            
            self.view.layoutIfNeeded()
        }
    }
    func setProfile(){
        
        //--
        var index = 1
        userData?.user_image.forEach({ user_Image in
            let imgName = "\(kImageBaseURL)\(user_Image.image)".replacingOccurrences(of: " ", with: "%20")
            if index == 1{
                ImageLoader().imageLoad(imgView: imgMain, url: imgName)
                
            }else if index == 2{
                ImageLoader().imageLoad(imgView: imgSecond, url: imgName)
                
            }
            index = index + 1
        })
        pageController.numberOfPages = userData?.user_image.count ?? 0
        collectionImage.reloadData()
        
        //
        is_liked_count = userData?.is_liked_count
        imgLikeDislike.isHidden = false
        if is_liked_count == 0 {
            imgLikeDislike.image = UIImage(named: "ic_like")
        } else {
            imgLikeDislike.image = UIImage(named: "ic_likes_active")
        }
        

        //
        if userData?.is_online == 1 {// 1 online
            self.imgOnlineStatus.isHidden = false
            //self.imgOnlineStatus.image = #imageLiteral(resourceName: "green-circle")
            self.lblOnlineStatus.text = ""
            self.lblOnlineDot.isHidden = true
        } else if userData?.is_online == 2 {// 2 recently online
            self.imgOnlineStatus.isHidden = true
            //self.imgOnlineStatus.image = #imageLiteral(resourceName: "gray-circle")
            self.lblOnlineStatus.text = "Recently Online"
            self.lblOnlineDot.isHidden = false
        } else if userData?.is_online == 0 {// 0 offline
            self.imgOnlineStatus.isHidden = true
            //self.imgOnlineStatus.image = #imageLiteral(resourceName: "gray-circle")
            self.lblOnlineStatus.text = ""
            self.lblOnlineDot.isHidden = true
        }
        
        
        //
        if let dob_ = userData?.dob{
            let dob_ = AppHelper.stringToDate(strDate: dob_, strFormate: "yyyy-MM-dd")
            
            lblTitle.text = "\(userData?.name ?? ""), \(Date().years(from: dob_))"
        }
        lblDetail.text = "\(userData?.city ?? ""), \(userData?.country ?? "")"
        
        //About
        arrAbout.append("\(userData?.relation_status ?? "")")
        arrAbout.append("\(userData?.kids ?? "")")
        arrAbout.append("\(userData?.education ?? "")")
        arrAbout.append("\(userData?.looking_for ?? "")")
        arrAbout.append("\((userData?.height ?? "").replacingOccurrences(of: "\"", with: "''"))")
        arrAbout.append("\(userData?.religious ?? "")")
        let deno = "\(((userData?.denomination_id ?? "").replacingOccurrences(of: "[", with: "")).replacingOccurrences(of: "]", with: ""))"
        arrAbout.append("\(deno)")
        //arrAbout.append("\(userData?.your_zodiac ?? "")") -- Removed Zodiac
        collectionAboutMe.reloadData()
        
        //Language
        let lang = "\(((userData?.language_id ?? "").replacingOccurrences(of: "[", with: "")).replacingOccurrences(of: "]", with: ""))"
        arrLanguage = lang.components(separatedBy: ", ")
        collectionLanguage.reloadData()
        
        //Life
        arrMylifeStyle.append("\(userData?.pray ?? "")")
        arrMylifeStyle.append("\(userData?.go_church ?? "")")
        arrMylifeStyle.append("\(userData?.smoke ?? "")")
        arrMylifeStyle.append("\(userData?.work_out ?? "")")
        //arrMylifeStyle.append("\(userData?.eating ?? "")")
        arrMylifeStyle.append("\(userData?.alcohol ?? "")")
        collectionMylifeStyle.reloadData()
        
        //Marrige
        arrMarriageGoals.append("\(userData?.married_year ?? "")")
        collectionMarriagegoals.reloadData()
        
        //
        arrOthePhotos.removeAll()
        
        //--
        var index1 = 1
        userData?.user_image.forEach({ user_Image in
            let imgName = "\(kImageBaseURL)\(user_Image.image)".replacingOccurrences(of: " ", with: "%20")
            if index1 == 1{
                ImageLoader().imageLoad(imgView: imgMain, url: imgName)
                
            }else if index1 == 2{
                ImageLoader().imageLoad(imgView: imgSecond, url: imgName)
                
            } else {
                arrOthePhotos.append((userData?.user_image[index1-1])!)
            }
            index1 = index1 + 1
        })
        
        pageControllerOther.numberOfPages = arrOthePhotos.count
        collectionImageOther.reloadData()
    }
    //EDIT
    /*func createDialog(userId:UInt) {
     
     let num = NSNumber(value: userId)
     let num2 = NSNumber(value: QBSession.current.currentUser!.id)
     
     let chatDialog = QBChatDialog(dialogID: nil, type: .group)
     chatDialog.name = "direct_chat \(num2)"//"New group dialog"
     chatDialog.occupantIDs = [num,num2]
     // Photo can be a link to a file in Content module, Custom Objects module or just a web link.
     // dialog.photo = "...";
     
     QBRequest.createDialog(chatDialog, successBlock: { (response, dialog) in
     dialog.join(completionBlock: { (error) in
     })
     print(response)
     print(dialog)
     
     let vc = OnetoOneChatVC(nibName: "OnetoOneChatVC", bundle: nil)
     vc.dictReceiver = dialog
     self.navigationController?.pushViewController(vc, animated: true)
     }, errorBlock: { (response) in
     
     })
     
     //        let dialog = QBChatDialog(dialogID: nil, type: .private)
     //        dialog.occupantIDs = [num]
     //        QBRequest.createDialog(dialog, successBlock: { (response, createdDialog) in
     //
     //            print(createdDialog)
     //        }, errorBlock: { (response) in
     //            print(response)
     //        })
     }*/
    //EDIT
    //    func processChat(quickbox_id:String) {
    //
    //        let user = NSNumber(value: QBSession.current.currentUser!.id)
    //        let receiver = NSNumber(value: UInt(Int(quickbox_id)!))
    //
    //        let arr:[NSNumber] = [receiver,user]
    //
    //        let index = arrDialogs?.firstIndex{$0.occupantIDs == arr}
    //
    //        if let _ = index {
    //
    //            //go to chat screen
    //
    //            let vc = OnetoOneChatVC(nibName: "OnetoOneChatVC", bundle: nil)
    //            vc.dictReceiver = arrDialogs?[index!]
    //            self.navigationController?.pushViewController(vc, animated: true)
    //            //print(arrDialogs?[index!])
    //        } else {
    //
    //            let arr2:[NSNumber] = [user,receiver]
    //
    //            let index2 = arrDialogs?.firstIndex{$0.occupantIDs == arr2}
    //
    //            if let _ = index2 {
    //
    //                //go to chat screen
    //                let vc = OnetoOneChatVC(nibName: "OnetoOneChatVC", bundle: nil)
    //                vc.dictReceiver = arrDialogs?[index2!]
    //                self.navigationController?.pushViewController(vc, animated: true)
    //                //print(arrDialogs?[index2!])
    //            } else {
    //
    //                //create
    //                createDialog(userId: UInt(Int(quickbox_id)!))
    //            }
    //        }
    //
    //    }
    
    //MARK: - Webservice
    func apiCall_userLikeDislike(like: String, op_user_id: String)  {
        
        if NetworkReachabilityManager()!.isReachable == false
        {
            let alert = UIAlertController(title: internetConnectedTitle.localizableString(lang: Helper.shared.strLanguage), message: internetConnected, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK".localizableString(lang: Helper.shared.strLanguage), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            //--
            let dicParam:[String:AnyObject] = ["op_user_id":op_user_id as AnyObject,
                                               "flag":like as AnyObject,
                                               "plan_purchased":ManageSubscriptionInfo.getSubscriptionModel().data?.is_buy_valid_subscription_new as AnyObject]
            let userModel = Login_LocalDB.getLoginUserModel()
            //AppHelper.showLinearProgress()
            self.view.isUserInteractionEnabled = false
            HttpWrapper.requestWithparamdictParamPostMethodwithHeader(url: a_userLikeDislike, dicsParams: dicParam, headers: ["Authorization":userModel.data?.api_token ?? ""], completion: { [self] (response) in
                self.view.isUserInteractionEnabled = true
                AppHelper.hideLinearProgress()
                let dicsResponseFinal = response.replaceNulls(with: "")
                print(dicsResponseFinal as Any)
                
                let userLikeDislikeModel = UserLikeDislikeModel(JSON: dicsResponseFinal as! [String : Any])!
                if userLikeDislikeModel.code == 200{
                    
                    if like == "1" {
                        self.is_liked_count = 0
                        self.imgLikeDislike.image = UIImage(named: "ic_like")
                        self.delegate?.likeDislikeFromProfileDetails(likeStatus: self.is_liked_count!, selectedIndex: intSelectedIndex!)
                    } else {
                        self.is_liked_count = 1
                        self.imgLikeDislike.image = UIImage(named: "ic_likes_active")
                        self.delegate?.likeDislikeFromProfileDetails(likeStatus: self.is_liked_count!, selectedIndex: intSelectedIndex!)
                    }
                    
                    //self.navigationController?.popViewController(animated: true)
                    
                }else if userLikeDislikeModel.code == 401{
                    self.imgLikeDislike.image = UIImage(named: "ic_like")
                    AppHelper.Logout(navigationController: self.navigationController!)
                } else if userLikeDislikeModel.code == 201{
                    self.imgLikeDislike.image = UIImage(named: "ic_like")
                    let obj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PremiumMembershipNewVC") as! PremiumMembershipNewVC
                    //                    obj.strSubscriptionType = "Gold"
                    //                    obj.type_subscription = SubscriptionType.swipe
                    obj.strSubscriptionType = "Premium"
                    obj.type_subscription = SubscriptionType.chat_swipe
                    obj.hidesBottomBarWhenPushed = true
                    navigationController?.pushViewController(obj, animated: true)
                } else if userLikeDislikeModel.code == 202 {
                    
                    let obj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MatchVC") as! MatchVC
                    obj.userModel = userData
                    obj.strReceiverId = "\(userData?.id ?? 0)"
                    obj.delegate = self
                    obj.modalPresentationStyle = .overFullScreen
                    self.present(obj, animated: true, completion: nil)
                    
                } else{
                    self.imgLikeDislike.image = UIImage(named: "ic_like")
                    self.view.makeToast(dicsResponseFinal?.object(forKey: "message") as? String ?? "")
                }
            }) { (error) in
                print(error)
                self.view.isUserInteractionEnabled = true
                AppHelper.hideLinearProgress()
            }
        }
    }
    func reportAPI() {
        
        if NetworkReachabilityManager()!.isReachable == false
        {
            return
        }
        
        let dicParams:[String:Any] = ["type":"2",
                                      "reason":"Report account".localizableString(lang: Helper.shared.strLanguage),
                                      "reported_user_id":userData?.id ?? 0]
        AppHelper.showLinearProgress()
        
        let userModel = Login_LocalDB.getLoginUserModel()
        
        let headers:HTTPHeaders = ["Accept":"application/json",
                                   "Authorization":userModel.data?.api_token ?? ""]
        
        AF.request(a_report, method: .post, parameters: dicParams, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            
            print(response)
            
            if let json = response.value as? [String:Any] {
                
                if json["status"] as? String == "Success" {
                    
                    AppHelper.returnTopNavigationController().view.makeToast(json["message"] as? String)
                    self.navigationController?.popViewController(animated: true)
                    
                }
            }
            
            AppHelper.hideLinearProgress()
        }
    }
    
    func getUserDetailsAPI() {
        
        if NetworkReachabilityManager()!.isReachable == false
        {
            let alert = UIAlertController(title: internetConnectedTitle.localizableString(lang: Helper.shared.strLanguage), message: internetConnected.localizableString(lang: Helper.shared.strLanguage), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK".localizableString(lang: Helper.shared.strLanguage), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        let dicParams:[String:AnyObject] = ["user_id":intUserId as AnyObject]
        //AppHelper.showLinearProgress()
        
        let userModel = Login_LocalDB.getLoginUserModel()
        
        HttpWrapper.requestMultipartFormDataWithImageAndFile(detail_by_user_id, dicsParams: dicParams, headers: ["Authorization":userModel.data?.api_token ?? ""], completion: { (response) in
            self.view.isUserInteractionEnabled = true
            AppHelper.hideLinearProgress()
            let dicsResponseFinal = response.replaceNulls(with: "")
            print(dicsResponseFinal as Any)
            
            let userListModel_ = UserModel(JSON: dicsResponseFinal as! [String : Any])!
            if userListModel_.code == 200{
                //--
                self.userData = userListModel_.data
                self.setProfile()
                
            }else if userListModel_.code == 401{
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
    //MARK: - IBAction
    
    
    @IBAction func btnLike(_ sender: Any) {
        
        //
        if is_liked_count == 1 {
            //dislike
            //apiCall_userLikeDislike(like: "1",op_user_id: "\(userData?.id ?? 0)")
        } else {
            self.imgLikeDislike.image = UIImage(named: "ic_likes_active")
            //like
            apiCall_userLikeDislike(like: "0",op_user_id: "\(userData?.id ?? 0)")
        }
    }
    @IBAction func btnChat(_ sender: Any) {
        
        if ManageSubscriptionInfo.getSubscriptionModel().data?.is_buy_valid_subscription_new == "0" || ManageSubscriptionInfo.getSubscriptionModel().data?.is_buy_valid_subscription_new == "" {
            
            let obj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PremiumMembershipNewVC") as! PremiumMembershipNewVC
            obj.strSubscriptionType = "Premium"
            obj.type_subscription = SubscriptionType.chat_swipe
            obj.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(obj, animated: true)
            return
        }
        if ManageSubscriptionInfo.getSubscriptionModel().data?.is_buy_valid_subscription_new == "1" && ManageSubscriptionInfo.getSubscriptionModel().data?.type == "Swipe" {
            
            let obj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PremiumMembershipNewVC") as! PremiumMembershipNewVC
            obj.strSubscriptionType = "Premium"
            obj.type_subscription = SubscriptionType.chat_swipe
            obj.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(obj, animated: true)
            return
        }
        
        print(userData?.room_info)
        
        var dictRoomInfo:[String:Any]?
        if userData?.room_info.count != 0 {
            dictRoomInfo = userData?.room_info[0]
        }
        
        
        let vc = OnetoOneChatVC(nibName: "OnetoOneChatVC", bundle: nil)
        
        vc.strReceiverId = "\(userData?.id ?? 0)"
        if let room_id = dictRoomInfo?["room_id"] as? String {
            vc.strRoomId = room_id
        } else {
            vc.strRoomId = "no"//if there is no room created then pass "no" to get empty array with 200 response. As Passing empty string ll not give 200 response
        }
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        //EDIT
        //let quickbox_id = "\(userData?.quickbox_id ?? "")"
        //processChat(quickbox_id: quickbox_id)
    }
    
    @IBAction func btnReport(_ sender: Any) {
        
        reportAPI()
    }
    
    @IBAction func btnBack() {
        delegate?.backButtonClicked(flag: true)
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension OtherProfileVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let height = collectionView.frame.size.height
        let width = collectionView.frame.size.width
        
        if collectionView == collectionImage{
            return CGSize(width: UIScreen.main.bounds.width-30, height: 600)
        } else if collectionView == collectionImageOther{
            return CGSize(width: UIScreen.main.bounds.width-30, height: 600)
        } else if collectionView == collectionAboutMe{
            return CGSize(width: (width/2)-5, height: 52)
        }else if collectionView == collectionLanguage{
            let width = collectionView.frame.size.width
            //let height = collectionView.frame.size.height
            return CGSize(width: (width/2)-5, height: 50)
        }else if collectionView == collectionMylifeStyle{
            return CGSize(width: (width/2)-5, height: 50)
        }else{
            return CGSize(width: (width/2)-5, height: 52)
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionImage{
            return userData?.user_image.count ?? 0
        } else if collectionView == collectionImageOther{
            if arrOthePhotos.count == 0 {
                heightCollectionImageOther.constant = 1
            } else {
                heightCollectionImageOther.constant = 600
            }
            return arrOthePhotos.count
        } else if collectionView == collectionAboutMe{
            return arrAbout.count
        }else if collectionView == collectionLanguage{
            return arrLanguage.count
        }else if collectionView == collectionMylifeStyle{
            return arrMylifeStyle.count
        }else{
            return arrMarriageGoals.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionImage{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileImageCell", for: indexPath) as! ProfileImageCell
            
            var imgName = userData?.user_image[indexPath.row].image ?? ""
            imgName = "\(kImageBaseURL)\(imgName)".replacingOccurrences(of: " ", with: "%20")
            ImageLoader().imageLoad(imgView: cell.imgUser, url: imgName)
            
            return cell
        } else if collectionView == collectionImageOther{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileImageCell", for: indexPath) as! ProfileImageCell
            
            var imgName = arrOthePhotos[indexPath.row].image ?? ""
            imgName = "\(kImageBaseURL)\(imgName)".replacingOccurrences(of: " ", with: "%20")
            ImageLoader().imageLoad(imgView: cell.imgUser, url: imgName)
            
            return cell
        } else if collectionView == collectionAboutMe{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileQuestionCollectionCell", for: indexPath) as! ProfileQuestionCollectionCell
            cell.lblTitl.numberOfLines = 2
            if indexPath.row == 0{
                if arrAbout[indexPath.row] == "Never married" || arrAbout[indexPath.row] == "لم يسبق الزواج" {
                    cell.lblTitl.text = "Never married".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "Single" || arrAbout[indexPath.row] == "أعزب" {
                    cell.lblTitl.text = "Single".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "Separated" || arrAbout[indexPath.row] == "منفصل" {
                    cell.lblTitl.text = "Separated".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "Divorced" || arrAbout[indexPath.row] == "مطلق" {
                    cell.lblTitl.text = "Divorced".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "Widowed" || arrAbout[indexPath.row] == "ارمل" {
                    cell.lblTitl.text = "Widowed".localizableString(lang: Helper.shared.strLanguage)
                }
            }else if indexPath.row == 1{
                if arrAbout[indexPath.row] == "Have kids" || arrAbout[indexPath.row] == "نعم" {
                    cell.lblTitl.text = "Have kids".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "Don't have kids" || arrAbout[indexPath.row] == "ليس لديهم اطفال" {
                    cell.lblTitl.text = "Don't have kids".localizableString(lang: Helper.shared.strLanguage)
                }
            }else if indexPath.row == 2{
                if arrAbout[indexPath.row] == "High School" || arrAbout[indexPath.row] == "مدرسة ثانوية" {
                    cell.lblTitl.text = "High School".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "Bachelors" || arrAbout[indexPath.row] == "غير حاصل على شهادة" {
                    cell.lblTitl.text = "Bachelors".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "Masters" || arrAbout[indexPath.row] == "درجة جامعية" {
                    cell.lblTitl.text = "Masters".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "Post graduate" || arrAbout[indexPath.row] == "دراسات عليا" {
                    cell.lblTitl.text = "Post graduate".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "Prefer not to say" || arrAbout[indexPath.row] == "افضل عدم القول" {
                    cell.lblTitl.text = "Prefer not to say".localizableString(lang: Helper.shared.strLanguage)
                }
            }else if indexPath.row == 3{
                if arrAbout[indexPath.row] == "Relationship" {
                    cell.lblTitl.text = "Relationship"
                } else if arrAbout[indexPath.row] == "Marriage" || arrAbout[indexPath.row] == "الزواج" {
                    cell.lblTitl.text = "Marriage".localizableString(lang: Helper.shared.strLanguage)
                } 
            }else if indexPath.row == 4{
                if arrAbout[indexPath.row] == "4'0'' (122 cm)" || arrAbout[indexPath.row] == "0'4 (122 سم)" {
                    cell.lblTitl.text = "4'0'' (122 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "4'1'' (125 cm)" || arrAbout[indexPath.row] == "1'4 (125 سم)" {
                    cell.lblTitl.text = "4'1'' (125 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "4'2'' (127 cm)" || arrAbout[indexPath.row] == "2'4 (127 سم)" {
                    cell.lblTitl.text = "4'2'' (127 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "4'3'' (130 cm)" || arrAbout[indexPath.row] == "3'4 (130 سم)" {
                    cell.lblTitl.text = "4'3'' (130 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "4'4'' (132 cm)" || arrAbout[indexPath.row] == "4'4 (132 سم)" {
                    cell.lblTitl.text = "4'4'' (132 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "4'5'' (135 cm)" || arrAbout[indexPath.row] == "5'4 (135 سم)" {
                    cell.lblTitl.text = "4'5'' (135 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "4'6'' (137 cm)" || arrAbout[indexPath.row] == "6'4 (137 سم)" {
                    cell.lblTitl.text = "4'6'' (137 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "4'7'' (140 cm)" || arrAbout[indexPath.row] == "7'4 (140 سم)" {
                    cell.lblTitl.text = "4'7'' (140 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "4'8'' (142 cm)" || arrAbout[indexPath.row] == "8'4 (142 سم)" {
                    cell.lblTitl.text = "4'8'' (142 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "4'9'' (145 cm)" || arrAbout[indexPath.row] == "9'4 (145 سم)" {
                    cell.lblTitl.text = "4'9'' (145 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "4'10'' (147 cm)" || arrAbout[indexPath.row] == "10'4 (147 سم)" {
                    cell.lblTitl.text = "4'10'' (147 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "4'11'' (150 cm)" || arrAbout[indexPath.row] == "11'4 (150 سم)" {
                    cell.lblTitl.text = "4'11'' (150 cm)".localizableString(lang: Helper.shared.strLanguage)
                }  else if arrAbout[indexPath.row] == "4'12'' (152 cm)" || arrAbout[indexPath.row] == "12'4 (152 سم)" {
                    cell.lblTitl.text = "4'12'' (152 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "5'0'' (153 cm)" || arrAbout[indexPath.row] == "0'5 (153 سم)" {
                    cell.lblTitl.text = "5'0'' (153 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "5'1'' (155 cm)" || arrAbout[indexPath.row] == "1'5 (155 سم)" {
                    cell.lblTitl.text = "5'1'' (155 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "5'2'' (157 cm)" || arrAbout[indexPath.row] == "2'5 (157 سم)" {
                    cell.lblTitl.text = "5'2'' (157 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "5'3'' (160 cm)" || arrAbout[indexPath.row] == "3'5 (160 سم)" {
                    cell.lblTitl.text = "5'3'' (160 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "5'4'' (162 cm)" || arrAbout[indexPath.row] == "4'5 (162 سم)" {
                    cell.lblTitl.text = "5'4'' (162 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "5'5'' (165 cm)" || arrAbout[indexPath.row] == "5'5 (165 سم)" {
                    cell.lblTitl.text = "5'5'' (165 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "5'6'' (167 cm)" || arrAbout[indexPath.row] == "6'5 (167 سم)" {
                    cell.lblTitl.text = "5'6'' (167 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "5'7'' (170 cm)" || arrAbout[indexPath.row] == "7'5 (170 سم)" {
                    cell.lblTitl.text = "5'7'' (170 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "5'8'' (172 cm)" || arrAbout[indexPath.row] == "8'5 (172 سم)" {
                    cell.lblTitl.text = "5'8'' (172 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "5'9'' (175 cm)" || arrAbout[indexPath.row] == "9'5 (175 سم)" {
                    cell.lblTitl.text = "5'9'' (175 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "5'10'' (177 cm)" || arrAbout[indexPath.row] == "10'5 (177 سم)" {
                    cell.lblTitl.text = "5'10'' (177 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "5'11'' (180 cm)" || arrAbout[indexPath.row] == "11'5 (180 سم)" {
                    cell.lblTitl.text = "5'11'' (180 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "5'12'' (182 cm)" || arrAbout[indexPath.row] == "12'5 (182 سم)" {
                    cell.lblTitl.text = "5'12'' (182 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "6'0'' (183 cm)" || arrAbout[indexPath.row] == "0'6 (183 سم)" {
                    cell.lblTitl.text = "6'0'' (183 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "6'1'' (186 cm)" || arrAbout[indexPath.row] == "1'6 (186 سم)" {
                    cell.lblTitl.text = "6'1'' (186 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "6'2'' (188 cm)" || arrAbout[indexPath.row] == "2'6 (188 سم)" {
                    cell.lblTitl.text = "6'2'' (188 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "6'3'' (190 cm)" || arrAbout[indexPath.row] == "3'6 (190 سم)" {
                    cell.lblTitl.text = "6'3'' (190 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "6'4'' (193 cm)" || arrAbout[indexPath.row] == "4'6 (193 سم)" {
                    cell.lblTitl.text = "6'4'' (193 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "6'5'' (195 cm)" || arrAbout[indexPath.row] == "5'6 (195 سم)" {
                    cell.lblTitl.text = "6'5'' (195 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "6'6'' (198 cm)" || arrAbout[indexPath.row] == "6'6 (198 سم)" {
                    cell.lblTitl.text = "6'6'' (198 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "6'7'' (200 cm)" || arrAbout[indexPath.row] == "7'6 (200 سم)" {
                    cell.lblTitl.text = "6'7'' (200 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "6'8'' (202 cm)" || arrAbout[indexPath.row] == "8'6 (202 سم)" {
                    cell.lblTitl.text = "6'8'' (202 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "6'9'' (205 cm)" || arrAbout[indexPath.row] == "9'6 (205 سم)" {
                    cell.lblTitl.text = "6'9'' (205 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "6'10'' (207 cm)" || arrAbout[indexPath.row] == "10'6 (207 سم)" {
                    cell.lblTitl.text = "6'10'' (207 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "6'11'' (210 cm)" || arrAbout[indexPath.row] == "11'6 بوصة (210 سم)" {
                    cell.lblTitl.text = "6'11'' (210 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "6'12'' (212 cm)" || arrAbout[indexPath.row] == "12'6 (212 سم)" {
                    cell.lblTitl.text = "6'12'' (212 cm)".localizableString(lang: Helper.shared.strLanguage)
                }
            }else if indexPath.row == 5{
                if arrAbout[indexPath.row] == "Not Practising" || arrAbout[indexPath.row] == "لا امارس" {
                    cell.lblTitl.text = "Not Practising".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "Moderately practising" || arrAbout[indexPath.row] == "متدين" {
                    cell.lblTitl.text = "Moderately practising".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "Practising" || arrAbout[indexPath.row] == "امارس" {
                    cell.lblTitl.text = "Practising".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "Very practising" || arrAbout[indexPath.row] == "اصلى احيانا" {
                    cell.lblTitl.text = "Very practising".localizableString(lang: Helper.shared.strLanguage)
                }
            } else if indexPath.row == 6{
                
                cell.lblTitl.text = arrAbout[indexPath.row]
            } else if indexPath.row == 7 {
                
                if arrAbout[indexPath.row] == "Leo" {
                    cell.lblTitl.text = "Leo"
                } else if arrAbout[indexPath.row] == "Virgo" {
                    cell.lblTitl.text = "Virgo"
                } else if arrAbout[indexPath.row] == "Libra" {
                    cell.lblTitl.text = "Libra"
                } else if arrAbout[indexPath.row] == "Scorpio" {
                    cell.lblTitl.text = "Scorpio"
                } else if arrAbout[indexPath.row] == "Sagittarius" {
                    cell.lblTitl.text = "Sagittarius"
                } else if arrAbout[indexPath.row] == "Capricorn" {
                    cell.lblTitl.text = "Capricorn"
                } else if arrAbout[indexPath.row] == "Aquarius" {
                    cell.lblTitl.text = "Aquarius"
                } else if arrAbout[indexPath.row] == "Pisces" {
                    cell.lblTitl.text = "Pisces"
                } else {
                    cell.lblTitl.text = "Not set"
                }
            }
            //cell.lblTitl.text = arrAbout[indexPath.row].localizableString(lang: Helper.shared.strLanguage)
            if indexPath.row == 0{
                cell.ic_cat.image = UIImage(named: "ic_maritial_status")
            }else if indexPath.row == 1{
                cell.ic_cat.image = UIImage(named: "ic_kids")
            }else if indexPath.row == 2{
                cell.ic_cat.image = UIImage(named: "ic_education")
            }else if indexPath.row == 3{
                cell.ic_cat.image = UIImage(named: "ic_looking_for")
            }else if indexPath.row == 4{
                cell.ic_cat.image = UIImage(named: "ic_height")
            }else if indexPath.row == 5{
                cell.ic_cat.image = UIImage(named: "ic_religious")
            }else if indexPath.row == 6{
                cell.ic_cat.image = UIImage(named: "ic_denomination")
            }else if indexPath.row == 7{
                cell.ic_cat.image = UIImage(named: "ic_star")
            }
            
            return cell
        }else if collectionView == collectionLanguage{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileQuestionCollectionCell", for: indexPath) as! ProfileQuestionCollectionCell
            
            
            if arrLanguage[indexPath.row] == "Korean" || arrLanguage[indexPath.row] == "الكورية" {
                cell.lblTitl.text = "\("Korean".localizableString(lang: Helper.shared.strLanguage))"
            } else if arrLanguage[indexPath.row] == "Russian" || arrLanguage[indexPath.row] == "الروسية"{
                cell.lblTitl.text = "\("Russian".localizableString(lang: Helper.shared.strLanguage))"
            } else if arrLanguage[indexPath.row] == "Japanese" || arrLanguage[indexPath.row] == "ليابانية" {
                cell.lblTitl.text = "\("Japanese".localizableString(lang: Helper.shared.strLanguage))"
            } else if arrLanguage[indexPath.row] == "Irish" || arrLanguage[indexPath.row] == "إيرلندي" {
                cell.lblTitl.text = "\("Irish".localizableString(lang: Helper.shared.strLanguage))"
            } else if arrLanguage[indexPath.row] == "French" || arrLanguage[indexPath.row] == "فرنسي" {
                cell.lblTitl.text = "\("French".localizableString(lang: Helper.shared.strLanguage))"
            }  else if arrLanguage[indexPath.row] == "German" || arrLanguage[indexPath.row] == "ألمانية" {
                cell.lblTitl.text = "\("German".localizableString(lang: Helper.shared.strLanguage))"
            }  else if arrLanguage[indexPath.row] == "English" || arrLanguage[indexPath.row] == "إنجليزي" {
                cell.lblTitl.text = "\("English".localizableString(lang: Helper.shared.strLanguage))"
            }  else if arrLanguage[indexPath.row] == "Arabic" || arrLanguage[indexPath.row] == "عربي" {
                cell.lblTitl.text = "\("Arabic".localizableString(lang: Helper.shared.strLanguage))"
            } else if arrLanguage[indexPath.row] == "Italian" || arrLanguage[indexPath.row] == "إيطالي" {
                cell.lblTitl.text = "\("Italian".localizableString(lang: Helper.shared.strLanguage))"
            } else if arrLanguage[indexPath.row] == "Somali" || arrLanguage[indexPath.row] == "صومالي" {
                cell.lblTitl.text = "\("Somali".localizableString(lang: Helper.shared.strLanguage))"
            } else if arrLanguage[indexPath.row] == "Serbian" || arrLanguage[indexPath.row] == "الصربية" {
                cell.lblTitl.text = "\("Serbian".localizableString(lang: Helper.shared.strLanguage))"
            } else if arrLanguage[indexPath.row] == "Chinese" || arrLanguage[indexPath.row] == "صينى" {
                cell.lblTitl.text = "\("Chinese".localizableString(lang: Helper.shared.strLanguage))"
            } else if arrLanguage[indexPath.row] == "Spanish" || arrLanguage[indexPath.row] == "لاتيني" {
                cell.lblTitl.text = "\("Spanish".localizableString(lang: Helper.shared.strLanguage))"
            } else if arrLanguage[indexPath.row] == "Swedish" || arrLanguage[indexPath.row] == "السويدية" {
                cell.lblTitl.text = "\("Swedish".localizableString(lang: Helper.shared.strLanguage))"
            } else if arrLanguage[indexPath.row] == "Amharic" || arrLanguage[indexPath.row] == "الأمهرية" {
                cell.lblTitl.text = "\("Amharic".localizableString(lang: Helper.shared.strLanguage))"
            } else if arrLanguage[indexPath.row] == "Portuguese" || arrLanguage[indexPath.row] == "البرتغالية" {
                cell.lblTitl.text = "\("Portuguese".localizableString(lang: Helper.shared.strLanguage))"
            } else if arrLanguage[indexPath.row] == "Igbo" || arrLanguage[indexPath.row] == "الإيغبو" {
                cell.lblTitl.text = "\("Igbo".localizableString(lang: Helper.shared.strLanguage))"
            } else if arrLanguage[indexPath.row] == "Kannada" || arrLanguage[indexPath.row] == "الكانادا" {
                cell.lblTitl.text = "\("Kannada".localizableString(lang: Helper.shared.strLanguage))"
            } else if arrLanguage[indexPath.row] == "Telugu" || arrLanguage[indexPath.row] == "التيلجو" {
                cell.lblTitl.text = "\("Telugu".localizableString(lang: Helper.shared.strLanguage))"
            } else if arrLanguage[indexPath.row] == "Gujarati" || arrLanguage[indexPath.row] == "الغوجاراتية" {
                cell.lblTitl.text = "\("Gujarati".localizableString(lang: Helper.shared.strLanguage))"
            } else if arrLanguage[indexPath.row] == "Thai" || arrLanguage[indexPath.row] == "التايلاندية" {
                cell.lblTitl.text = "\("Thai".localizableString(lang: Helper.shared.strLanguage))"
            } else if arrLanguage[indexPath.row] == "Khmer" || arrLanguage[indexPath.row] == "الخمير" {
                cell.lblTitl.text = "\("Khmer".localizableString(lang: Helper.shared.strLanguage))"
            } else if arrLanguage[indexPath.row] == "Slovenian" || arrLanguage[indexPath.row] == "السلوفينية" {
                cell.lblTitl.text = "\("Slovenian".localizableString(lang: Helper.shared.strLanguage))"
            } else if arrLanguage[indexPath.row] == "Kazakh" || arrLanguage[indexPath.row] == "الكازاخستانية" {
                cell.lblTitl.text = "\("Kazakh".localizableString(lang: Helper.shared.strLanguage))"
            } else if arrLanguage[indexPath.row] == "Ukrainian" || arrLanguage[indexPath.row] == "الأوكرانية" {
                cell.lblTitl.text = "\("Ukrainian".localizableString(lang: Helper.shared.strLanguage))"
            } else if arrLanguage[indexPath.row] == "Kurdish" || arrLanguage[indexPath.row] == "كردي" {
                cell.lblTitl.text = "\("Kurdish".localizableString(lang: Helper.shared.strLanguage))"
            }
            cell.ic_cat.image = UIImage(named: "ic_language")
            
            return cell
        }else if collectionView == collectionMylifeStyle{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileQuestionCollectionCell", for: indexPath) as! ProfileQuestionCollectionCell
            
            if indexPath.row == 0 {
                
                if arrMylifeStyle[indexPath.row] == "Never pray" || arrMylifeStyle[indexPath.row] == "لا اصلى" {
                    cell.lblTitl.text = "Never pray".localizableString(lang: Helper.shared.strLanguage)
                } else if arrMylifeStyle[indexPath.row] == "Sometimes pray" || arrMylifeStyle[indexPath.row] == "بعض الاحيان اصلى" {
                    cell.lblTitl.text = "Sometimes pray".localizableString(lang: Helper.shared.strLanguage)
                } else if arrMylifeStyle[indexPath.row] == "Usually pray" || arrMylifeStyle[indexPath.row] == "عادة اصلى" {
                    cell.lblTitl.text = "Usually pray".localizableString(lang: Helper.shared.strLanguage)
                } else if arrMylifeStyle[indexPath.row] == "Always pray" || arrMylifeStyle[indexPath.row] == "دائما اصلى" {
                    cell.lblTitl.text = "Always pray".localizableString(lang: Helper.shared.strLanguage)
                }
            } else if indexPath.row == 1{
                
                if arrMylifeStyle[indexPath.row] == "Every week" || arrMylifeStyle[indexPath.row] == "نعم" {
                    cell.lblTitl.text = "Every week"
                } else if arrMylifeStyle[indexPath.row] == "Every other week" || arrMylifeStyle[indexPath.row] == "رقم" {
                    cell.lblTitl.text = "Every other week"
                } else if arrMylifeStyle[indexPath.row] == "Every month" || arrMylifeStyle[indexPath.row] == "رقم" {
                    cell.lblTitl.text = "Every month"
                } else if arrMylifeStyle[indexPath.row] == "Once in a while" || arrMylifeStyle[indexPath.row] == "رقم" {
                    cell.lblTitl.text = "Once in a while"
                }
            }else if indexPath.row == 2{
                if arrMylifeStyle[indexPath.row] == "Yes" || arrMylifeStyle[indexPath.row] == "نعم" {
                    cell.lblTitl.text = "Yes".localizableString(lang: Helper.shared.strLanguage)
                } else if arrMylifeStyle[indexPath.row] == "No" || arrMylifeStyle[indexPath.row] == "رقم" {
                    cell.lblTitl.text = "No".localizableString(lang: Helper.shared.strLanguage)
                }
            }else if indexPath.row == 3{
                
                
                
                if arrMylifeStyle[indexPath.row] == "Active" || arrMylifeStyle[indexPath.row] == "نعم" {
                    cell.lblTitl.text = "Active".localizableString(lang: Helper.shared.strLanguage)
                } else if arrMylifeStyle[indexPath.row] == "Sometimes" || arrMylifeStyle[indexPath.row] == "بعض الاحيان" {
                    cell.lblTitl.text = "Sometimes".localizableString(lang: Helper.shared.strLanguage)
                } else if arrMylifeStyle[indexPath.row] == "Almost never" || arrMylifeStyle[indexPath.row] == "على الاغلب ل" {
                    cell.lblTitl.text = "Almost never".localizableString(lang: Helper.shared.strLanguage)
                }
                
                //                if arrMylifeStyle[indexPath.row] == "Yes" || arrMylifeStyle[indexPath.row] == "نعم" {
                //                    cell.lblTitl.text = "Yes".localizableString(lang: Helper.shared.strLanguage)
                //                } else if arrMylifeStyle[indexPath.row] == "No" || arrMylifeStyle[indexPath.row] == "رقم" {
                //                    cell.lblTitl.text = "No".localizableString(lang: Helper.shared.strLanguage)
                //                }
            }else if indexPath.row == 4{
                if arrMylifeStyle[indexPath.row] == "Yes" || arrMylifeStyle[indexPath.row] == "نعم" {
                    cell.lblTitl.text = "Yes".localizableString(lang: Helper.shared.strLanguage)
                } else if arrMylifeStyle[indexPath.row] == "No" || arrMylifeStyle[indexPath.row] == "رقم" {
                    cell.lblTitl.text = "No".localizableString(lang: Helper.shared.strLanguage)
                } else if arrMylifeStyle[indexPath.row] == "Sometimes" || arrMylifeStyle[indexPath.row] == "بعض الاحيان" {
                    cell.lblTitl.text = "Sometimes".localizableString(lang: Helper.shared.strLanguage)
                }
            }
            
            //cell.lblTitl.text = arrMylifeStyle[indexPath.row].localizableString(lang: Helper.shared.strLanguage)
            if indexPath.row == 0{
                cell.ic_cat.image = UIImage(named: "ic_pray")
            }else if indexPath.row == 1{
                cell.ic_cat.image = UIImage(named: "ic_church")
            }else if indexPath.row == 2{
                cell.ic_cat.image = UIImage(named: "ic_smoke")
            }else if indexPath.row == 3{
                cell.ic_cat.image = UIImage(named: "ic_workout")
                //cell.ic_cat.image = UIImage(named: "ic_eat")
            }else if indexPath.row == 4{
                cell.ic_cat.image = UIImage(named: "ic_drink")
            }
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileQuestionCollectionCell", for: indexPath) as! ProfileQuestionCollectionCell
            cell.lblTitl.numberOfLines = 2
            if arrMarriageGoals[indexPath.row] == "Marriage within a year" || arrMarriageGoals[indexPath.row] == "الزواج خلال عام" {
                cell.lblTitl.text = "Marriage within a year".localizableString(lang: Helper.shared.strLanguage)
            } else if arrMarriageGoals[indexPath.row] == "Marriage in 1-2 Years" || arrMarriageGoals[indexPath.row] == "الزواج خلال 1-2 اعوام" {
                cell.lblTitl.text = "Marriage in 1-2 Years".localizableString(lang: Helper.shared.strLanguage)
            } else if arrMarriageGoals[indexPath.row] == "Marriage in 3-4 Years" || arrMarriageGoals[indexPath.row] == "الزواج خلال 3-4 اعوام" {
                cell.lblTitl.text = "Marriage in 3-4 Years".localizableString(lang: Helper.shared.strLanguage)
            } else if arrMarriageGoals[indexPath.row] == "Marriage in 4+ Years" || arrMarriageGoals[indexPath.row] == "الزواج خلال اكثر من 4 اعوام" {
                cell.lblTitl.text = "Marriage in 4+ Years".localizableString(lang: Helper.shared.strLanguage)
            } else if arrMarriageGoals[indexPath.row] == "Don’t know yet" || arrMarriageGoals[indexPath.row] == "لا أعرف بعد" {
                cell.lblTitl.text = "Don’t know yet".localizableString(lang: Helper.shared.strLanguage)
            }
            
            //cell.lblTitl.text = arrMarriageGoals[indexPath.row].localizableString(lang: Helper.shared.strLanguage)
            cell.ic_cat.image = UIImage(named: "ic_marriage_goal")
            
            
            return cell
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionAboutMe{
            
        }else if collectionView == collectionMylifeStyle{
            
        }else{
            
        }
    }
    
    
}



extension OtherProfileVC: UIScrollViewDelegate
{
    //--ScrollView Delegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == collectionImage{
            let pageWidth = collectionImage.frame.size.width
            let currentPage = Float(collectionImage.contentOffset.x / pageWidth)
            
            if 0.0 != fmodf(currentPage, 1.0) {
                pageController.currentPage = Int(currentPage + 1)
            } else {
                pageController.currentPage = Int(currentPage)
            }
            
        } else if scrollView == collectionImageOther{
            let pageWidth = collectionImageOther.frame.size.width
            let currentPage = Float(collectionImageOther.contentOffset.x / pageWidth)
            
            if 0.0 != fmodf(currentPage, 1.0) {
                pageControllerOther.currentPage = Int(currentPage + 1)
            } else {
                pageControllerOther.currentPage = Int(currentPage)
            }
            
        }
    }
    
}
extension OtherProfileVC: SendMsgBtnMatchUI {
    
    func sendMsgBtnClick(strReceiverId: String, strRoomId: String) {
        
        let vc = OnetoOneChatVC(nibName: "OnetoOneChatVC", bundle: nil)
        vc.strReceiverId = strReceiverId
        vc.strRoomId = strRoomId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
