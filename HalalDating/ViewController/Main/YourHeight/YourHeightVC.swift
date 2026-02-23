//
//  YourHeightVC.swift
//  HalalDating
//
//  Created by Maulik Vora on 26/11/21.
//

import UIKit

class YourHeightVC: UIViewController {
    //MARK: - @IBOutlet
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var tblList: UITableView!
    
    
    //MARK: - Veriable
    var userModel = UserModel()
    var isComeProfile = false
    var arrList = ["4'0'' (122 cm)".localizableString(lang: Helper.shared.strLanguage),
                   "4'1'' (125 cm)".localizableString(lang: Helper.shared.strLanguage),
                   "4'2'' (127 cm)".localizableString(lang: Helper.shared.strLanguage),
                   "4'3'' (130 cm)".localizableString(lang: Helper.shared.strLanguage),
                   "4'4'' (132 cm)".localizableString(lang: Helper.shared.strLanguage),
                   "4'5'' (135 cm)".localizableString(lang: Helper.shared.strLanguage),
                   "4'6'' (137 cm)".localizableString(lang: Helper.shared.strLanguage),
                   "4'7'' (140 cm)".localizableString(lang: Helper.shared.strLanguage),
                   "4'9'' (145 cm)".localizableString(lang: Helper.shared.strLanguage),
                   "4'10'' (147 cm)".localizableString(lang: Helper.shared.strLanguage),
                   "4'11'' (150 cm)".localizableString(lang: Helper.shared.strLanguage),
                   "4'12'' (152 cm)".localizableString(lang: Helper.shared.strLanguage),
                   "5'0'' (153 cm)".localizableString(lang: Helper.shared.strLanguage),
                   "5'1'' (155 cm)".localizableString(lang: Helper.shared.strLanguage),
                   "5'2'' (157 cm)".localizableString(lang: Helper.shared.strLanguage),
                   "5'3'' (160 cm)".localizableString(lang: Helper.shared.strLanguage),
                   "5'4'' (162 cm)".localizableString(lang: Helper.shared.strLanguage),
                   "5'5'' (165 cm)".localizableString(lang: Helper.shared.strLanguage),
                   "5'6'' (167 cm)".localizableString(lang: Helper.shared.strLanguage),
                   "5'7'' (170 cm)".localizableString(lang: Helper.shared.strLanguage),
                   "5'8'' (172 cm)".localizableString(lang: Helper.shared.strLanguage),
                   "5'9'' (175 cm)".localizableString(lang: Helper.shared.strLanguage),
                   "5'10'' (177 cm)".localizableString(lang: Helper.shared.strLanguage),
                   "5'11'' (180 cm)".localizableString(lang: Helper.shared.strLanguage),
                   "5'12'' (182 cm)".localizableString(lang: Helper.shared.strLanguage),
                   "6'0'' (183 cm)".localizableString(lang: Helper.shared.strLanguage),
                   "6'1'' (186 cm)".localizableString(lang: Helper.shared.strLanguage),
                   "6'2'' (188 cm)".localizableString(lang: Helper.shared.strLanguage),
                   "6'3'' (190 cm)".localizableString(lang: Helper.shared.strLanguage),
                   "6'4'' (193 cm)".localizableString(lang: Helper.shared.strLanguage),
                   "6'5'' (195 cm)".localizableString(lang: Helper.shared.strLanguage),
                   "6'6'' (198 cm)".localizableString(lang: Helper.shared.strLanguage),
                   "6'7'' (200 cm)".localizableString(lang: Helper.shared.strLanguage),
                   "6'8'' (202 cm)".localizableString(lang: Helper.shared.strLanguage),
                   "6'9'' (205 cm)".localizableString(lang: Helper.shared.strLanguage),
                   "6'10'' (207 cm)".localizableString(lang: Helper.shared.strLanguage),
                   "6'11'' (210 cm)".localizableString(lang: Helper.shared.strLanguage),
                   "6'12'' (212 cm)".localizableString(lang: Helper.shared.strLanguage)]
    var selectIndex = 0
    var delegateUpdateProfileInfo:UpdateProfileInfo?
    
    
    //MARK: - func
    override func viewDidLoad() {
        super.viewDidLoad()
        setLanguageUI()
        setProgress()
        registerCell()
        AppHelper.updateScreenNumber(userID: userModel.data?.id ?? 0, screenNumber: 10, token: userModel.data?.api_token ?? "")
        
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
        lblTitle.text = "What is your height?".localizableString(lang: Helper.shared.strLanguage)
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
        let percentProgress = Float(6.0/16.0)
        headerView.progressBar.setProgress(percentProgress, animated: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
          UIView.animate(withDuration: 1, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction], animations: { [unowned self] in
              //headerView.progressBar.setProgress(0, animated: true)
              let percentProgress = Float(7.0/16.0)
              headerView.progressBar.setProgress(percentProgress, animated: true)
          })
        }
    }
    func setProfile(){
//        for index in 0..<arrList.count{
//            let title = arrList[index]
//            if title.lowercased() == "\(userModel.data?.height ?? "")".lowercased(){
//                selectIndex = index
//            }
//        }
        
        let height = "\((userModel.data?.height ?? "").replacingOccurrences(of: "\"", with: "''"))"
        
        if height == "4'0'' (122 cm)" || height == "0'4 (122 سم)" {
            selectIndex = 0
        } else if height == "4'1'' (125 cm)" || height == "1'4 (125 سم)" {
            selectIndex = 1
        } else if height == "4'2'' (127 cm)" || height == "2'4 (127 سم)" {
            selectIndex = 2
        } else if height == "4'3'' (130 cm)" || height == "3'4 (130 سم)" {
            selectIndex = 3
        } else if height == "4'4'' (132 cm)" || height == "4'4 (132 سم)" {
            selectIndex = 4
        } else if height == "4'5'' (135 cm)" || height == "5'4 (135 سم)" {
            selectIndex = 5
        } else if height == "4'6'' (137 cm)" || height == "6'4 (137 سم)" {
            selectIndex = 6
        } else if height == "4'7'' (140 cm)" || height == "7'4 (140 سم)" {
            selectIndex = 7
        } else if height == "4'8'' (142 cm)" || height == "8'4 (142 سم)" {
            selectIndex = 8
        } else if height == "4'9'' (145 cm)" || height == "9'4 (145 سم)" {
            selectIndex = 9
        } else if height == "4'10'' (147 cm)" || height == "10'4 (147 سم)" {
            selectIndex = 10
        } else if height == "4'11'' (150 cm)" || height == "11'4 (150 سم)" {
            selectIndex = 11
        }  else if height == "4'12'' (152 cm)" || height == "12'4 (152 سم)" {
            selectIndex = 12
        } else if height == "5'0'' (153 cm)" || height == "0'5 (153 سم)" {
            selectIndex = 13
        } else if height == "5'1'' (155 cm)" || height == "1'5 (155 سم)" {
            selectIndex = 14
        } else if height == "5'2'' (157 cm)" || height == "2'5 (157 سم)" {
            selectIndex = 15
        } else if height == "5'3'' (160 cm)" || height == "3'5 (160 سم)" {
            selectIndex = 16
        } else if height == "5'4'' (162 cm)" || height == "4'5 (162 سم)" {
            selectIndex = 17
        } else if height == "5'5'' (165 cm)" || height == "5'5 (165 سم)" {
            selectIndex = 18
        } else if height == "5'6'' (167 cm)" || height == "6'5 (167 سم)" {
            selectIndex = 19
        } else if height == "5'7'' (170 cm)" || height == "7'5 (170 سم)" {
            selectIndex = 20
        } else if height == "5'8'' (172 cm)" || height == "8'5 (172 سم)" {
            selectIndex = 21
        } else if height == "5'9'' (175 cm)" || height == "9'5 (175 سم)" {
            selectIndex = 22
        } else if height == "5'10'' (177 cm)" || height == "10'5 (177 سم)" {
            selectIndex = 23
        } else if height == "5'11'' (180 cm)" || height == "11'5 (180 سم)" {
            selectIndex = 24
        } else if height == "5'12'' (182 cm)" || height == "12'5 (182 سم)" {
            selectIndex = 25
        } else if height == "6'0'' (183 cm)" || height == "0'6 (183 سم)" {
            selectIndex = 26
        } else if height == "6'1'' (186 cm)" || height == "1'6 (186 سم)" {
            selectIndex = 27
        } else if height == "6'2'' (188 cm)" || height == "2'6 (188 سم)" {
            selectIndex = 28
        } else if height == "6'3'' (190 cm)" || height == "3'6 (190 سم)" {
            selectIndex = 29
        } else if height == "6'4'' (193 cm)" || height == "4'6 (193 سم)" {
            selectIndex = 30
        } else if height == "6'5'' (195 cm)" || height == "5'6 (195 سم)" {
            selectIndex = 31
        } else if height == "6'6'' (198 cm)" || height == "6'6 (198 سم)" {
            selectIndex = 32
        } else if height == "6'7'' (200 cm)" || height == "7'6 (200 سم)" {
            selectIndex = 33
        } else if height == "6'8'' (202 cm)" || height == "8'6 (202 سم)" {
            selectIndex = 34
        } else if height == "6'9'' (205 cm)" || height == "9'6 (205 سم)" {
            selectIndex = 35
        } else if height == "6'10'' (207 cm)" || height == "10'6 (207 سم)" {
            selectIndex = 36
        } else if height == "6'11'' (210 cm)" || height == "11'6 بوصة (210 سم)" {
            selectIndex = 37
        } else if height == "6'12'' (212 cm)" || height == "12'6 (212 سم)" {
            selectIndex = 38
        }
        
        tblList.reloadData()
    }
    
    
    
    //MARK: - @IBAction
    @IBAction func btnNext(_ sender: Any) {
        //--
        userModel.data?.height = arrList[selectIndex]
        if isComeProfile{
            delegateUpdateProfileInfo?.updateProfileInfo(userModel_: userModel)
            self.navigationController?.popViewController(animated: true)
        }else{
            //--
            let vc = LookingForVC(nibName: "LookingForVC", bundle: nil)
            vc.userModel = userModel
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}

extension YourHeightVC: UITableViewDelegate, UITableViewDataSource
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

extension YourHeightVC: HeaderView_Protocol{
    func btnBack() {
        self.navigationController?.popViewController(animated: true)
    }
}
