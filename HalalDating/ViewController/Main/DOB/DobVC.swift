//
//  DobVC.swift
//  HalalDating
//
//  Created by Maulik Vora on 26/11/21.
//

import UIKit
import ActionSheetPicker_3_0

class DobVC: UIViewController {
    //MARK: - @IBOutlet
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var txtdob: UITextField!
    @IBOutlet weak var btnNext: UIButton!
    
    
    //MARK: - Veriable
    var userModel = UserModel()
    var isComeProfile = false
    var delegateUpdateProfileInfo:UpdateProfileInfo?
    
    
    //MARK: - func
    override func viewDidLoad() {
        super.viewDidLoad()
        setLanguageUI()
        setProgress()
        AppHelper.updateScreenNumber(userID: userModel.data?.id ?? 0, screenNumber: 4, token: userModel.data?.api_token ?? "")
        
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
            lblDetail.semanticContentAttribute = .forceRightToLeft
            txtdob.textAlignment = .right
            headerView.semanticContentAttribute = .forceRightToLeft
        }
        lblTitle.text = "What is your date of birth?".localizableString(lang: Helper.shared.strLanguage)
        lblDetail.text = "You must be at least 18 years old to use this app.".localizableString(lang: Helper.shared.strLanguage)
        //txtdob.placeholder = "DD / MM / YYYY".localizableString(lang: Helper.shared.strLanguage)
    }
    func setHeaderView(){
        headerView.delegate_HeaderView = self
        headerView.progressBar.isHidden = true
        headerView.imgAppIcon.isHidden = true
        headerView.lblTitle.isHidden = false
        headerView.lblTitle.text = "Edit Profile"
    }
    func setProgress(){
        let percentProgress = Float(1.0/16.0)
        headerView.progressBar.setProgress(percentProgress, animated: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
          UIView.animate(withDuration: 1, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction], animations: { [unowned self] in
              //headerView.progressBar.setProgress(0, animated: true)
              let percentProgress = Float(2.0/16.0)
              headerView.progressBar.setProgress(percentProgress, animated: true)
          })
        }
    }
    func setProfile(){
        
        txtdob.text = AppHelper.datetoconvertSpecificFormate(dateOldFTR: k_DateFormate_Date, dateNewFTR: "MM-dd-yyyy", strDate: "\(userModel.data?.dob ?? "")")
        
        
    }
    
    //MARK: - @IBAction
    @IBAction func btnDob(_ sender: Any) {
        self.view.endEditing(true)
        //--
        
        let cancelButton:UIButton =  UIButton(type: .custom)
            cancelButton.setTitle("Cancel".localizableString(lang: Helper.shared.strLanguage), for: .normal)
            cancelButton.setTitleColor(UIColor.black, for: .normal)
            cancelButton.frame = CGRect(x: 0, y: 0, width: 55, height: 32)

            let doneButton:UIButton =  UIButton(type: .custom)
            doneButton.setTitle("Done".localizableString(lang: Helper.shared.strLanguage), for: .normal)
            doneButton.setTitleColor(UIColor.black, for: .normal)
            doneButton.frame = CGRect(x: 0, y: 0, width: 55, height: 32)
        
        let maximumDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        let minimumDate = Calendar.current.date(byAdding: .year, value: -50, to: Date())
        let datePicker = ActionSheetDatePicker(title: "", datePickerMode: UIDatePicker.Mode.date, selectedDate: maximumDate, doneBlock: {
            picker, value, index in
            print(value as Any)
            
            //--
            let dateFinal = AppHelper.dateToString(date: value as! Date, strFormate: "MM-dd-yyyy")
            
            self.txtdob.text = dateFinal
            
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: (sender as AnyObject).superview!?.superview)
        datePicker?.maximumDate = maximumDate
        datePicker?.minimumDate = minimumDate
        datePicker?.setCancelButton(UIBarButtonItem(customView: cancelButton))
        datePicker?.setDoneButton(UIBarButtonItem(customView: doneButton))
        datePicker?.show()
    }
    @IBAction func btnNext(_ sender: Any) {
        self.view.endEditing(true)
        if AppHelper.isNull(txtdob.text!) == true {
            AppHelper.showAlert(kAlertTitle, message: k_select_date_of_birth.localizableString(lang: Helper.shared.strLanguage))
            return
        }
        
        userModel.data?.dob = AppHelper.datetoconvertSpecificFormate(dateOldFTR: "MM-dd-yyyy", dateNewFTR: k_DateFormate_Date, strDate: txtdob.text!)
        
        if isComeProfile{
            delegateUpdateProfileInfo?.updateProfileInfo(userModel_: userModel)
            self.navigationController?.popViewController(animated: true)
        }else{
            //--
            let vc = IamaVC(nibName: "IamaVC", bundle: nil)
            vc.userModel = userModel
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}

extension DobVC: HeaderView_Protocol{
    func btnBack() {
        self.navigationController?.popViewController(animated: true)
    }
}
