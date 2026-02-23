//
//  SelectlangVC.swift
//  HalalDating
//
//  Created by Maulik Vora on 26/11/21.
//

import UIKit
import Alamofire

class SelectlangVC: UIViewController {
    //MARK: - @IBOutlet
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var tblList: UITableView!
    
    
    //MARK: - Veriable
    var userModel = UserModel()
    var languageModel = LanguageModel()
    var isComeProfile = false
    var delegateUpdateProfileInfo:UpdateProfileInfo?
    var arrList = [
        "English".localizableString(lang: Helper.shared.strLanguage),
        "Korean".localizableString(lang: Helper.shared.strLanguage),
        "Russian".localizableString(lang: Helper.shared.strLanguage),
        "Japanese".localizableString(lang: Helper.shared.strLanguage),
        "Irish".localizableString(lang: Helper.shared.strLanguage),
        "French".localizableString(lang: Helper.shared.strLanguage),
        "German".localizableString(lang: Helper.shared.strLanguage),
        "Arabic".localizableString(lang: Helper.shared.strLanguage),
        "Italian".localizableString(lang: Helper.shared.strLanguage),
        "Somali".localizableString(lang: Helper.shared.strLanguage),
        "Serbian".localizableString(lang: Helper.shared.strLanguage),
        "Chinese".localizableString(lang: Helper.shared.strLanguage),
        "Spanish".localizableString(lang: Helper.shared.strLanguage),
        "Swedish".localizableString(lang: Helper.shared.strLanguage),
        "Amharic".localizableString(lang: Helper.shared.strLanguage),
        "Portuguese".localizableString(lang: Helper.shared.strLanguage),
        "Igbo".localizableString(lang: Helper.shared.strLanguage),
        "Kannada".localizableString(lang: Helper.shared.strLanguage),
        "Telugu".localizableString(lang: Helper.shared.strLanguage),
        "Gujarati".localizableString(lang: Helper.shared.strLanguage),
        "Thai".localizableString(lang: Helper.shared.strLanguage),
        "Khmer".localizableString(lang: Helper.shared.strLanguage),
        "Slovenian".localizableString(lang: Helper.shared.strLanguage),
        "Kazakh".localizableString(lang: Helper.shared.strLanguage),
        "Ukrainian".localizableString(lang: Helper.shared.strLanguage),
        "Kurdish".localizableString(lang: Helper.shared.strLanguage)]
    var selectIndex = 0
    var arrFlag:[Int] = []
    
    
    //MARK: - func
    override func viewDidLoad() {
        super.viewDidLoad()
        setLanguageUI()
        setProgress()
        registerCell()
        AppHelper.updateScreenNumber(userID: userModel.data?.id ?? 0, screenNumber: 13, token: userModel.data?.api_token ?? "")
        
        for _ in 0..<arrList.count {
            
            arrFlag.append(0)
        }
        
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
        lblTitle.text = "Select your language".localizableString(lang: Helper.shared.strLanguage)
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
        let percentProgress = Float(9.0/16.0)
        headerView.progressBar.setProgress(percentProgress, animated: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            UIView.animate(withDuration: 1, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction], animations: { [unowned self] in
                //headerView.progressBar.setProgress(0, animated: true)
                let percentProgress = Float(10.0/16.0)
                headerView.progressBar.setProgress(percentProgress, animated: true)
            })
        }
    }
    func setProfile(){
        
        //
        
        let lang = "\(((userModel.data?.language_id ?? "").replacingOccurrences(of: "[", with: "")).replacingOccurrences(of: "]", with: ""))"
        
        let arr = lang.components(separatedBy: ", ")
        for i in 0..<arr.count {
            
            if arr[i] == "English" || arr[i] == "إنجليزي" {
                arrFlag[0] = 1
            } else if arr[i] == "Korean" || arr[i] == "الكورية" {
                arrFlag[1] = 1
            } else if arr[i] == "Russian" || arr[i] == "الروسية"{
                arrFlag[2] = 1
            } else if arr[i] == "Japanese" || arr[i] == "ليابانية" {
                arrFlag[3] = 1
            } else if arr[i] == "Irish" || arr[i] == "إيرلندي" {
                arrFlag[4] = 1
            } else if arr[i] == "French" || arr[i] == "فرنسي" {
                arrFlag[5] = 1
            }  else if arr[i] == "German" || arr[i] == "ألمانية" {
                arrFlag[6] = 1
            }  else if arr[i] == "Arabic" || arr[i] == "عربي" {
                arrFlag[7] = 1
            }  else if arr[i] == "Italian" || arr[i] == "إيطالي" {
                arrFlag[8] = 1
            } else if arr[i] == "Somali" || arr[i] == "صومالي" {
                arrFlag[9] = 1
            } else if arr[i] == "Serbian" || arr[i] == "الصربية" {
                arrFlag[10] = 1
            } else if arr[i] == "Chinese" || arr[i] == "صينى" {
                arrFlag[11] = 1
            } else if arr[i] == "Spanish" || arr[i] == "لاتيني" {
                arrFlag[12] = 1
            } else if arr[i] == "Swedish" || arr[i] == "السويدية" {
                arrFlag[13] = 1
            } else if arr[i] == "Amharic" || arr[i] == "الأمهرية" {
                arrFlag[14] = 1
            } else if arr[i] == "Portuguese" || arr[i] == "البرتغالية" {
                arrFlag[15] = 1
            } else if arr[i] == "Igbo" || arr[i] == "الإيغبو" {
                arrFlag[16] = 1
            } else if arr[i] == "Kannada" || arr[i] == "الكانادا" {
                arrFlag[17] = 1
            } else if arr[i] == "Telugu" || arr[i] == "التيلجو" {
                arrFlag[18] = 1
            } else if arr[i] == "Gujarati" || arr[i] == "الغوجاراتية" {
                arrFlag[19] = 1
            } else if arr[i] == "Thai" || arr[i] == "التايلاندية" {
                arrFlag[20] = 1
            } else if arr[i] == "Khmer" || arr[i] == "الخمير" {
                arrFlag[21] = 1
            } else if arr[i] == "Slovenian" || arr[i] == "السلوفينية" {
                arrFlag[22] = 1
            } else if arr[i] == "Kazakh" || arr[i] == "الكازاخستانية" {
                arrFlag[23] = 1
            } else if arr[i] == "Ukrainian" || arr[i] == "الأوكرانية" {
                arrFlag[24] = 1
            } else if arr[i] == "Kurdish" || arr[i] == "كردي" {
                arrFlag[25] = 1
            }
        }
        
        tblList.reloadData()
    }
    
    //MARK: - @IBAction
    @IBAction func btnNext(_ sender: Any) {
        
        var strLangName = ""
        for i in 0..<arrFlag.count {
            
            if arrFlag[i] == 1 {
                
                strLangName += "\(arrList[i]), "
            }
        }
        if strLangName != "" {
            userModel.data?.language_name = "[\(strLangName.dropLast(2))]"
            userModel.data?.language_id = "[\(strLangName.dropLast(2))]"
        } else {
            userModel.data?.language_name = ""
            userModel.data?.language_id = ""
        }
        
        if arrFlag.contains(1) {
            print("yes")
            if isComeProfile{
                delegateUpdateProfileInfo?.updateProfileInfo(userModel_: userModel)
                self.navigationController?.popViewController(animated: true)
            }else{
                //--
                let vc = ReligiousVC(nibName: "ReligiousVC", bundle: nil)
                vc.userModel = userModel
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            AppHelper.returnTopNavigationController().view.makeToast("Please select language".localizableString(lang: Helper.shared.strLanguage))
        }
        
    }
    
    
}

extension SelectlangVC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileOptionCell", for: indexPath) as! ProfileOptionCell
        cell.selectionStyle = .none
        
        cell.lblTitle.text = arrList[indexPath.row]
        
        if arrFlag[indexPath.row] == 1 {
            cell.lblTitle.textColor = UIColor(named: "AppRed")
            cell.viewbg.borderColor = UIColor(named: "AppRed")
        }else{
            cell.lblTitle.textColor = UIColor(named: "AppGray")
            cell.viewbg.borderColor = UIColor(named: "AppGray")
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if arrFlag[indexPath.row] == 0 {
            arrFlag[indexPath.row] = 1
        } else {
            arrFlag[indexPath.row] = 0
        }
        
        tblList.reloadData()
    }
}

extension SelectlangVC: HeaderView_Protocol{
    func btnBack() {
        self.navigationController?.popViewController(animated: true)
    }
}
