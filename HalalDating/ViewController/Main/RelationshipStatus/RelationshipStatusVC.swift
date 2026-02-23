//
//  RelationshipStatusVC.swift
//  HalalDating
//
//  Created by Maulik Vora on 26/11/21.
//

import UIKit

class RelationshipStatusVC: UIViewController {
    //MARK: - @IBOutlet
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var tblList: UITableView!
    
    
    //MARK: - Veriable
    var userModel = UserModel()
    var isComeProfile = false
    var arrList = ["Never married".localizableString(lang: Helper.shared.strLanguage), "Single".localizableString(lang: Helper.shared.strLanguage), "Separated".localizableString(lang: Helper.shared.strLanguage), "Divorced".localizableString(lang: Helper.shared.strLanguage), "Widowed".localizableString(lang: Helper.shared.strLanguage)]
    var selectIndex = 0
    var delegateUpdateProfileInfo:UpdateProfileInfo?
    
    
    //MARK: - func
    override func viewDidLoad() {
        super.viewDidLoad()
        setLanguageUI()
        setProgress()
        registerCell()
        AppHelper.updateScreenNumber(userID: userModel.data?.id ?? 0, screenNumber: 7, token: userModel.data?.api_token ?? "")
        
        //--
        if isComeProfile{
            setHeaderView()
            setProfile()
            btnNext.setTitle("DONE".localizableString(lang: Helper.shared.strLanguage), for: .normal)
        }else{
            headerView.delegate_HeaderView = self
            btnNext.setTitle("NEXT".localizableString(lang: Helper.shared.strLanguage), for: .normal)
        }
    }
    func setLanguageUI() {
        
        if Helper.shared.strLanguage == "ar" {
            lblTitle.semanticContentAttribute = .forceRightToLeft
            headerView.semanticContentAttribute = .forceRightToLeft
        }
        lblTitle.text = "What is your relationship status?".localizableString(lang: Helper.shared.strLanguage)
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

        
        let percentProgress = Float(3.0/16.0)
        headerView.progressBar.setProgress(percentProgress, animated: false)
                
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
          UIView.animate(withDuration: 1, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction], animations: { [unowned self] in
              //headerView.progressBar.setProgress(0, animated: true)
              let percentProgress = Float(4.0/16.0)
              headerView.progressBar.setProgress(percentProgress, animated: true)
          })
        }
        
    }
    func setProfile(){
//        for index in 0..<arrList.count{
//            let title = arrList[index]
//            if title.lowercased() == "\(userModel.data?.relation_status ?? "")".lowercased(){
//                selectIndex = index
//            }
//        }
        
        if (userModel.data?.relation_status ?? "") == "Never married" || (userModel.data?.relation_status ?? "") == "لم يسبق الزواج" {
            selectIndex = 0
        } else if (userModel.data?.relation_status ?? "") == "Single" || (userModel.data?.relation_status ?? "") == "أعزب" {
            selectIndex = 1
        } else if (userModel.data?.relation_status ?? "") == "Separated" || (userModel.data?.relation_status ?? "") == "منفصل" {
            selectIndex = 2
        } else if (userModel.data?.relation_status ?? "") == "Divorced" || (userModel.data?.relation_status ?? "") == "مطلق" {
            selectIndex = 3
        } else if (userModel.data?.relation_status ?? "") == "Widowed" || (userModel.data?.relation_status ?? "") == "ارمل" {
            selectIndex = 4
        }
        
        tblList.reloadData()
    }
    
    
    
    //MARK: - @IBAction
    @IBAction func btnNext(_ sender: Any) {
        //--
        userModel.data?.relation_status = arrList[selectIndex]
        if isComeProfile{
            delegateUpdateProfileInfo?.updateProfileInfo(userModel_: userModel)
            self.navigationController?.popViewController(animated: true)
        }else{
            //--
            let vc = HaveKidsVC(nibName: "HaveKidsVC", bundle: nil)
            vc.userModel = userModel
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}

extension RelationshipStatusVC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrList.count//studentListModel.data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileOptionCell", for: indexPath) as! ProfileOptionCell
        cell.selectionStyle = .none
        
        cell.lblTitle.text = arrList[indexPath.row].localizableString(lang: Helper.shared.strLanguage)
        
        if indexPath.row == selectIndex{
            cell.lblTitle.textColor = UIColor(named: "AppRed")
            cell.viewbg.borderColor = UIColor(named: "AppRed")
        }else{
            cell.lblTitle.textColor = UIColor(named: "AppGray")
            cell.viewbg.borderColor = UIColor(named: "AppGray")
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectIndex = indexPath.row
        tblList.reloadData()
    }
}

extension RelationshipStatusVC: HeaderView_Protocol{
    func btnBack() {
        self.navigationController?.popViewController(animated: true)
    }
}
