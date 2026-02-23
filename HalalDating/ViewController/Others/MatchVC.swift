//
//  MatchVC.swift
//  HalalDating
//
//  Created by Apple on 05/12/22.
//

protocol SendMsgBtnMatchUI {
    func sendMsgBtnClick(strReceiverId:String, strRoomId:String)
}

import UIKit
import Quickblox
import Alamofire
import StoreKit

class MatchVC: UIViewController {

    // MARK: - Variable
    var userModel:UserData!
    var arrDialogs:[QBChatDialog]?
    var dictReceiver:QBChatDialog?
    var strReceiverId:String = ""
    var strRoomId:String = ""
    var delegate:SendMsgBtnMatchUI?
    
    // MARK: - IBOutlet
    @IBOutlet weak var imgSelf: UIImageView!
    @IBOutlet weak var imgOpponent: UIImageView!
    @IBOutlet weak var btnSendMessage: UIButton!
    @IBOutlet weak var lblMatchNames: UILabel!
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var viewMatch: UIView!
    @IBOutlet weak var viewMatchMain: UIView!
    @IBOutlet weak var lblMatchWith: UILabel!
    @IBOutlet weak var ratingView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        getRating()
        setLanguageUI()
        setupUI()
        
        sendMessageAPI()
        //EDIT
        //getAllDialogs()
    }
    

    // MARK: - Function
    func setupUI() {
        //btnSendMessage.isUserInteractionEnabled = false
        var imgName = userModel.user_image.first?.image ?? ""
        imgName = "\(kImageBaseURL)\(imgName)".replacingOccurrences(of: " ", with: "%20")
        
        ImageLoader().imageLoad(imgView: imgOpponent, url: imgName)
        //ImageLoader().imageLoad(imgView: imgBg, url: imgName)
        
        //
        let userModel1 = Login_LocalDB.getLoginUserModel()
        
        var imgName1 = userModel1.data?.user_image.first?.image ?? ""
        imgName1 = "\(kImageBaseURL)\(imgName1)".replacingOccurrences(of: " ", with: "%20")
        
        ImageLoader().imageLoad(imgView: imgSelf, url: imgName1)
        
        //
        //lblMatchNames.text = "\("You".localizableString(lang: Helper.shared.strLanguage)) & \(userModel1.data?.name ?? "")"
        
        //
        //lblMatchWith.text = "You matched with \(userModel1.data?.name ?? "")"
        
        //
        view.isOpaque = false
        view.backgroundColor = .clear
        
        //
        makesViewBlur()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        }
    }
    
    func setLanguageUI() {
        
        if Helper.shared.strLanguage == "ar"  {
            
            viewMatch.semanticContentAttribute = .forceRightToLeft
            viewMatchMain.semanticContentAttribute = .forceRightToLeft
            
        }
        
        btnSendMessage.setTitle("Send a message".localizableString(lang: Helper.shared.strLanguage), for: .normal)
    }
    
    //EDIT
//    func getAllDialogs() {
//
//        //get dialogs that have been updated during the last month and sort by the date of the last message in descending order
//        //let monthAgoDate = Calendar.current.date( byAdding: .month, value: -1, to: Date())
//        //let timeInterval = monthAgoDate!.timeIntervalSince1970
//
//        let paramSort = "sort_desc"
//        let sortValue = "last_message_date_sent"
//        //let paramFilter = "updated_at[gte]"
//        //let filterValue = "\(timeInterval)"
//
//        var extendedRequest: [String: String] = [:]
//        extendedRequest[paramSort] = sortValue
//        //extendedRequest[paramFilter] = filterValue
//        let responsePage = QBResponsePage(limit: 0)
//
//        QBRequest.dialogs(for: responsePage, extendedRequest: extendedRequest, successBlock: { response, dialogs, dialogsUsersIDs, page in
//
//            print(dialogs)
//            self.arrDialogs = dialogs
//
//            //
//            let quickbox_id = "\(self.userModel.quickbox_id)"
//
//            self.processChat(quickbox_id: quickbox_id)
//
//            //
//
//        }, errorBlock: { response in
//
//        })
//    }
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
//
//            btnSendMessage.isUserInteractionEnabled = true
//            self.dictReceiver = arrDialogs?[index!]
//
//        } else {
//
//            let arr2:[NSNumber] = [user,receiver]
//
//            let index2 = arrDialogs?.firstIndex{$0.occupantIDs == arr2}
//
//            if let _ = index2 {
//
//                btnSendMessage.isUserInteractionEnabled = true
//                self.dictReceiver = arrDialogs?[index2!]
//            } else {
//
//                //create
//                createDialog(userId: UInt(Int(quickbox_id)!))
//            }
//        }
//
//    }
    
//    func createDialog(userId:UInt) {
//        
//        let num = NSNumber(value: userId)
//        let num2 = NSNumber(value: QBSession.current.currentUser!.id)
//
//        let chatDialog = QBChatDialog(dialogID: nil, type: .group)
//        chatDialog.name = "match \(num2)"//"New group dialog"
//        chatDialog.occupantIDs = [num,num2]
//        // Photo can be a link to a file in Content module, Custom Objects module or just a web link.
//        // dialog.photo = "...";
//
//        QBRequest.createDialog(chatDialog, successBlock: { (response, dialog) in
//            dialog.join(completionBlock: { (error) in
//            })
//            print(response)
//            print(dialog)
//            self.btnSendMessage.isUserInteractionEnabled = true
//            self.dictReceiver = dialog
//        }, errorBlock: { (response) in
//
//        })
//    }
    
    func makesViewBlur() {
        self.view.viewWithTag(8001)?.removeFromSuperview()
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.tag = 8001
        blurEffectView.alpha = 0.60
        //blurEffectView.layer.cornerRadius = 10
        //blurEffectView.clipsToBounds = true
        blurEffectView.frame = self.viewBg.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.viewBg.addSubview(blurEffectView)
    }
    
    func getRating() {
        
        let userModel = Login_LocalDB.getLoginUserModel()
        
        let headers:HTTPHeaders = ["Accept":"application/json",
                                   "Authorization":userModel.data?.api_token ?? ""]
        
        AF.request(get_rating, method: .get, headers: headers).responseJSON { response in
            
            switch response.result {
                
            case .success(let data):
                
                if let json = data as? [String: Any] {
                    print("Response JSON: \(json)")
                    
                    if let data = json["data"] as? [String: Any],
                       let playStoreReview = data["play_store_review"] as? Int {
                        
                        print("Play Store Review: \(playStoreReview)")
                        
                        if playStoreReview == 0 {
                            self.ratingView.isHidden = false
                        }
                    }
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func setRating(completion: @escaping () -> Void) {
        let userModel = Login_LocalDB.getLoginUserModel()
        
        let headers: HTTPHeaders = ["Accept": "application/json",
                                    "Authorization": userModel.data?.api_token ?? ""]
        
        AF.request(set_rating, method: .post, parameters: ["play_store_review": 1], headers: headers).responseJSON { response in
            switch response.result {
            case .success(let data):
                if let json = data as? [String: Any] {
                    print("Response JSON: \(json)")
                    
                    if let data = json["data"] as? [String: Any],
                       let playStoreReview = data["play_store_review"] as? Int {
                        
                        print("Play Store Review: \(playStoreReview)")
                        completion()
                    }
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                completion()
            }
        }
    }
    
    
    // MARK: - Webservice
    func sendMessageAPI() {
        
        if NetworkReachabilityManager()!.isReachable == false
        {
            return
        }
        
        let dicParams:[String:String] = ["message":"createMetchList",
                                         "reciver_id":strReceiverId]
        AppHelper.showLinearProgress()
        
        let userModel = Login_LocalDB.getLoginUserModel()
        
        let headers:HTTPHeaders = ["Accept":"application/json",
                                   "Authorization":userModel.data?.api_token ?? ""]
        
        AF.request(send_chat_msg, method: .post, parameters: dicParams, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            
            print(response)
            
            if let json = response.value as? [String:Any] {
                
                if json["status"] as? String == "Success" {
                    
                    
                    self.strRoomId = (json["data"] as? [String:Any])?["room_id"] as? String ?? ""
                    
                }
            }
            
            AppHelper.hideLinearProgress()
        }
    }
    // MARK: - IBAction
    
    @IBAction func btnClose(_ sender: Any) {
        self.dismiss(animated: false)
    }
    
    @IBAction func btnSendMessage(_ sender: Any) {
        //EDIT
//        let vc = OnetoOneChatVC(nibName: "OnetoOneChatVC", bundle: nil)
//        vc.dictReceiver = dictReceiver
//        self.navigationController?.pushViewController(vc, animated: true)
        
        var myRoomId = ""
        if let room_id = strRoomId as? String {
            myRoomId = room_id
        } else {
            myRoomId = "no"//if there is no room created then pass "no" to get empty array with 200 response. As Passing empty string ll not give 200 response
        }
        
        delegate?.sendMsgBtnClick(strReceiverId: strReceiverId, strRoomId: myRoomId)
        
        self.dismiss(animated: false)
        
        
    }
    
    @IBAction func btnCancelReview(_ sender: UIButton) {
        self.ratingView.isHidden = true
    }
    
    @IBAction func btnRateNowAction(_ sender: UIButton) {
        self.ratingView.isHidden = true
        
        self.setRating {
            if let url = URL(string: "https://apps.apple.com/app/id\(6477770277)?action=write-review"), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}
