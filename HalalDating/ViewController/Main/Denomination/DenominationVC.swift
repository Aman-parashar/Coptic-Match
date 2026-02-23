//
//  DenominationVC.swift
//  HalalDating
//
//  Created by Apple on 02/02/24.
//

import UIKit
import Alamofire

class DenominationVC: UIViewController {

    //MARK: - @IBOutlet
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var tblList: UITableView!
    
    
    //MARK: - Veriable
    var userModel = UserModel()
    var isComeProfile = false
    var arrDenomination:[[String:Any]]?
    var selectIndex = 0
    var arrFlag:[Int] = []
    var delegateUpdateProfileInfo:UpdateProfileInfo?
    
    
    //MARK: - func
    override func viewDidLoad() {
        super.viewDidLoad()
        setLanguageUI()
        setProgress()
        registerCell()
        AppHelper.updateScreenNumber(userID: userModel.data?.id ?? 0, screenNumber: 6, token: userModel.data?.api_token ?? "")
        
        
        
        //
        getDenominationAPI()
        
    }
    func setLanguageUI() {
        
        if Helper.shared.strLanguage == "ar" {
            lblTitle.semanticContentAttribute = .forceRightToLeft
            lblDetail.semanticContentAttribute = .forceRightToLeft
            headerView.semanticContentAttribute = .forceRightToLeft
        }
        //lblTitle.text = "I am a".localizableString(lang: Helper.shared.strLanguage)
        //lblDetail.text = "Please choose carefully you will not be able to edit this information later.".localizableString(lang: Helper.shared.strLanguage)
    }
    func setHeaderView(){
        headerView.delegate_HeaderView = self
        headerView.progressBar.isHidden = true
        headerView.imgAppIcon.isHidden = true
        headerView.lblTitle.isHidden = false
        headerView.lblTitle.text = "Edit Profile"
    }
    func registerCell(){
        tblList.register(UINib(nibName: "ProfileOptionCell", bundle: nil), forCellReuseIdentifier: "ProfileOptionCell")
    }
    func setProgress(){
        
        let percentProgress = Float(2.0/16.0)
        headerView.progressBar.setProgress(percentProgress, animated: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
          UIView.animate(withDuration: 1, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction], animations: { [unowned self] in
              //headerView.progressBar.setProgress(0, animated: true)
              let percentProgress = Float(3.0/16.0)
              headerView.progressBar.setProgress(percentProgress, animated: true)
          })
        }
    }
    
    func setProfile(){
        
        //
        
        let lang = "\(((userModel.data?.denomination_id ?? "").replacingOccurrences(of: "[", with: "")).replacingOccurrences(of: "]", with: ""))"
        
        let arr = lang.components(separatedBy: ", ")
        for i in 0..<arr.count {
            
            if let index = arrDenomination?.firstIndex{$0["name"] as? String == arr[i]} {
                
                arrFlag[index] = 1
            }
            
        }
        
        tblList.reloadData()
    }
    
    //MARK: - @Webservice
    func getDenominationAPI() {
        
        if NetworkReachabilityManager()!.isReachable == false
        {
            return
        }
        AppHelper.showLinearProgress()
        
        let headers:HTTPHeaders = ["Accept":"application/json"]
        
        AF.request(get_denomination, method: .get, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            
            print(response)
            
            if let json = response.value as? [String:Any] {
                
                if json["status"] as? String == "Success" {
                    
//                    self.arrDenomination = json["data"] as? [[String:Any]]
                    
                    if let data = json["data"] as? [[String:Any]] {
                        self.arrDenomination = data.sorted {
                            ($0["position"] as? Int ?? 999) < ($1["position"] as? Int ?? 999)
                        }
                    }

                    
                    self.arrFlag.removeAll()
                    for _ in 0..<(self.arrDenomination?.count ?? 0) {
                        
                        self.arrFlag.append(0)
                    }
                    self.tblList.reloadData()
                    
                    //--
                    if self.isComeProfile{
                        self.setHeaderView()
                        self.setProfile()
                        self.btnNext.setTitle("DONE".localizableString(lang: Helper.shared.strLanguage), for: .normal)
                    }else{
                        self.headerView.delegate_HeaderView = self
                        self.btnNext.setTitle("NEXT".localizableString(lang: Helper.shared.strLanguage), for: .normal)
                    }
                    
                }
            }
            
            AppHelper.hideLinearProgress()
        }
    }
    
    
    //MARK: - @IBAction
    @IBAction func btnNext(_ sender: Any) {
        
        
        var strDenominationName = ""
        for i in 0..<arrFlag.count {
            
            if arrFlag[i] == 1 {
                
                strDenominationName += "\(arrDenomination?[i]["name"] as? String ?? ""), "
            }
        }
        if strDenominationName != "" {
            userModel.data?.denomination_name = "[\(strDenominationName.dropLast(2))]"
            userModel.data?.denomination_id = "[\(strDenominationName.dropLast(2))]"
        } else {
            userModel.data?.denomination_name = ""
            userModel.data?.denomination_id = ""
        }
        
        if arrFlag.contains(1) {
            print("yes")
            //--
            
            if isComeProfile{
                delegateUpdateProfileInfo?.updateProfileInfo(userModel_: userModel)
                self.navigationController?.popViewController(animated: true)
            }else{
                //--
                let vc = RelationshipStatusVC(nibName: "RelationshipStatusVC", bundle: nil)
                vc.userModel = userModel
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        } else {
            AppHelper.returnTopNavigationController().view.makeToast("Please select denomination")
        }
    }
    
    
}

extension DenominationVC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row == 0 {
//            return 0.0
//        }
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDenomination?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileOptionCell", for: indexPath) as! ProfileOptionCell
        cell.selectionStyle = .none
        
        cell.lblTitle.text = arrDenomination?[indexPath.row]["name"] as? String
     
        if arrFlag[indexPath.row] == 1 {
            cell.lblTitle.textColor = UIColor(named: "AppRed")
            cell.viewbg.borderColor = UIColor(named: "AppRed")
        }else{
            cell.lblTitle.textColor = UIColor(named: "AppGray")
            cell.viewbg.borderColor = UIColor(named: "  AppGray")
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.arrFlag.removeAll()
        for _ in 0..<(self.arrDenomination?.count ?? 0) {
            
            self.arrFlag.append(0)
        }
        
        arrFlag[indexPath.row] = 1
        self.tblList.reloadData()
        
    }
}

extension DenominationVC: HeaderView_Protocol{
    func btnBack() {
        self.navigationController?.popViewController(animated: true)
    }
}

