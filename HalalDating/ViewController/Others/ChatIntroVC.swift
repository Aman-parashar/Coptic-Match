//
//  ChatIntroVC.swift
//  HalalDating
//
//  Created by Apple on 10/12/22.
//

import UIKit
import Alamofire

class ChatIntroVC: UIViewController {

    // MARK: - Variable
    var arrNotifications:[[String:Any]]?
    
    // MARK: - IBOutlet
    @IBOutlet weak var lblTitle1: UILabel!
    @IBOutlet weak var lblTitle2: UILabel!
    @IBOutlet weak var lblTitle3: UILabel!
    @IBOutlet weak var lblTitle4: UILabel!
    @IBOutlet weak var lblTitle5: UILabel!
    @IBOutlet weak var lblTitle6: UILabel!
    @IBOutlet weak var lblTitle7: UILabel!
    @IBOutlet weak var lblTitle8: UILabel!
    @IBOutlet weak var lblTitle9: UILabel!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var lblHeaderTitle: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setLanguageUI()
        getNotificationsAPI()
        self.tabBarController?.tabBar.isHidden = true
        
        //
        let userModel = Login_LocalDB.getLoginUserModel()
        
        
        //
        lblTitle8.text = Helper.shared.changeDateFormat(fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSSSZ", toFormat: "MMM dd, yyyy", date: userModel.data?.created_at ?? "")
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if let headerView = table.tableHeaderView {

            let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            var headerFrame = headerView.frame

            //Comparison necessary to avoid infinite loop
            if height != headerFrame.size.height {
                headerFrame.size.height = height
                headerView.frame = headerFrame
                table.tableHeaderView = headerView
            }
        }
    }
    

    // MARK: - Function
    func setLanguageUI() {
        
        if Helper.shared.strLanguage == "ar"  {
            
            lblTitle1.semanticContentAttribute = .forceRightToLeft
            lblTitle2.semanticContentAttribute = .forceRightToLeft
            lblTitle3.semanticContentAttribute = .forceRightToLeft
            lblTitle4.semanticContentAttribute = .forceRightToLeft
            lblTitle5.semanticContentAttribute = .forceRightToLeft
            lblTitle6.semanticContentAttribute = .forceRightToLeft
            lblTitle7.semanticContentAttribute = .forceRightToLeft
            lblTitle9.semanticContentAttribute = .forceRightToLeft
            imgBack.semanticContentAttribute = .forceRightToLeft
            viewHeader.semanticContentAttribute = .forceRightToLeft
            viewTop.semanticContentAttribute = .forceRightToLeft
            lblHeaderTitle.semanticContentAttribute = .forceRightToLeft
        }
        lblTitle1.text = "Welcome to halaldating 😊".localizableString(lang: Helper.shared.strLanguage)
        lblTitle2.text = "#1 Marriage App For Muslims 🥇".localizableString(lang: Helper.shared.strLanguage)
        lblTitle3.text = "You can see our successful stories".localizableString(lang: Helper.shared.strLanguage)
        lblTitle4.text = "You are here to get married only 💍 so if you here for any other reason your account will be deactivated permanently.".localizableString(lang: Helper.shared.strLanguage)
        lblTitle5.text = "Please be respectful to each other: We are here a family helping each other to get safe and happy Islamic marriage.".localizableString(lang: Helper.shared.strLanguage)
        lblTitle6.text = "Please read carefully safety tips for your safety:This will explain to you what are the steps of safe dating.".localizableString(lang: Helper.shared.strLanguage)
        lblTitle7.text = "Please report users with bad attitude:there is report option on the top of chat and you can use it to report any user you are not comfortable with.".localizableString(lang: Helper.shared.strLanguage)
        
    }
    // MARK: - Webservice
    func getNotificationsAPI() {
        
        if NetworkReachabilityManager()!.isReachable == false
        {
            return
        }
        AppHelper.showLinearProgress()
        
        let userModel = Login_LocalDB.getLoginUserModel()
        
        let dicParams:[String:Any] = ["user_id":userModel.data?.id ?? 0]
        
        
        let headers:HTTPHeaders = ["Accept":"application/json"]
        
        AF.request(user_notification, method: .post, parameters: dicParams, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            
            print(response)
            
            if let json = response.value as? [String:Any] {
                
                if json["status"] as? String == "Success" {
                    
                    self.arrNotifications = json["data"] as? [[String:Any]]
                    self.table.reloadData()
                    
                    UserDefaults.standard.setValue((json["data"] as? [[String:Any]])?.count, forKey: "notiBadgeCount")
                    UserDefaults.standard.synchronize()
                }
            }
            
            AppHelper.hideLinearProgress()
        }
    }
    
    // MARK: - IBAction
    
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func btnOpenLink(_ sender: Any) {
        guard let url = URL(string: "https://www.halal-dating.com") else { return }
        UIApplication.shared.open(url)
    }
    
}
extension ChatIntroVC:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrNotifications?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationChatCell") as! NotificationChatCell
        
        let arr = arrNotifications?[indexPath.row]["users_chat_info"] as? [[String:Any]]
        
        if Helper.shared.strLanguage == "ar"  {
            cell.viewBg.semanticContentAttribute = .forceRightToLeft
            cell.lblTitle.semanticContentAttribute = .forceRightToLeft
            cell.lblTitle.text = arr?[1]["message"] as? String
        } else {
            cell.lblTitle.text = arr?[0]["message"] as? String
        }
        
        cell.lblDate.text = Helper.shared.changeDateFormat(fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSSSZ", toFormat: "MMM dd, yyyy", date: (arrNotifications?[indexPath.row]["created_at"] as? String)!)
        
        return cell
    }
    
}
