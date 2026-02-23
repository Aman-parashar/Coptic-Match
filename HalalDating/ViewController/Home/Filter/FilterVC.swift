//
//  FilterVC.swift
//  HalalDating
//
//  Created by Maulik Vora on 27/11/21.
//

import UIKit
import MultiSlider
import Alamofire

enum OnlineStatus:String {
    case yes
    case no
}

protocol Filter {
    func applyFilter()
}

class FilterVC: UIViewController {
    
    //MARK: - Variable
    var selectedStatus = OnlineStatus.no.rawValue
    var myPickerView : UIPickerView!
    var toolBar : UIToolbar!
    var delegate:Filter?
    var arrRelationshipStatus = ["Select Relationship Status".localizableString(lang: Helper.shared.strLanguage),
                                 "No preference".localizableString(lang: Helper.shared.strLanguage),
                                 "Never married".localizableString(lang: Helper.shared.strLanguage),
                                 "Single".localizableString(lang: Helper.shared.strLanguage),
                                 "Separated".localizableString(lang: Helper.shared.strLanguage),
                                 "Divorced".localizableString(lang: Helper.shared.strLanguage),
                                 "Widowed".localizableString(lang: Helper.shared.strLanguage)]
    
    var arrLookingFor = ["Select Looking for".localizableString(lang: Helper.shared.strLanguage),
                         "No preference".localizableString(lang: Helper.shared.strLanguage),
                         "Marriage".localizableString(lang: Helper.shared.strLanguage),
                         "Relationship".localizableString(lang: Helper.shared.strLanguage)]
    
    var arrDenomination:[[String:Any]]?
    var selectedTextfield:UITextField?
    
    //MARK: - @IBOutlet
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var lblAge_title: UILabel!
    @IBOutlet weak var ageSlider: MultiSlider!
    @IBOutlet weak var lblMinAge: UILabel!
    @IBOutlet weak var lblMaxAge: UILabel!
    @IBOutlet weak var lblDistance_title: UILabel!
    @IBOutlet weak var lblDistanceValue: UILabel!
    @IBOutlet weak var btnApply: UIButton!
    @IBOutlet weak var distanceSlider: MultiSlider!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var imgOnlineNow: UIImageView!
    @IBOutlet weak var imgAll: UIImageView!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblOnlineNow: UILabel!
    @IBOutlet weak var lblAll: UILabel!
    @IBOutlet weak var lblRelaStatus: UILabel!
    @IBOutlet weak var txtSelectRelationshipStatus: UITextField!
    @IBOutlet weak var stackviewStatus: UIStackView!
    @IBOutlet weak var viewOnline: UIView!
    @IBOutlet weak var viewAll: UIView!
    @IBOutlet weak var txtDenomination: UITextField!
    @IBOutlet weak var txtLookingFor: UITextField!
    
    
    
    
    //MARK: - func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLanguageUI()
        setHeaderView()
        setAgeSlider()
        setSelectedValue()
        setupUI()
        getDenominationAPI()
    }
    func setHeaderView(){
        headerView.delegate_HeaderView = self
        headerView.progressBar.isHidden = true
        headerView.imgAppIcon.isHidden = true
        headerView.lblTitle.isHidden = false
        headerView.lblTitle.text = "Filter".localizableString(lang: Helper.shared.strLanguage)
    }
    func setLanguageUI() {
        
        if Helper.shared.strLanguage == "ar" {
            scrollview.semanticContentAttribute = .forceRightToLeft
            headerView.semanticContentAttribute = .forceRightToLeft
            headerView.lblTitle.semanticContentAttribute = .forceRightToLeft
            lblAge_title.semanticContentAttribute = .forceRightToLeft
            lblDistance_title.semanticContentAttribute = .forceRightToLeft
            ageSlider.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            distanceSlider.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            txtSelectRelationshipStatus.textAlignment = .right
            txtLookingFor.textAlignment = .right
            lblStatus.semanticContentAttribute = .forceRightToLeft
            lblRelaStatus.semanticContentAttribute = .forceRightToLeft
            lblOnlineNow.semanticContentAttribute = .forceRightToLeft
            lblAll.semanticContentAttribute = .forceRightToLeft
            stackviewStatus.semanticContentAttribute = .forceRightToLeft
            viewOnline.semanticContentAttribute = .forceRightToLeft
            viewAll.semanticContentAttribute = .forceRightToLeft
        }
        btnApply.setTitle("Update".localizableString(lang: Helper.shared.strLanguage), for: .normal)
        //lblAge_title.text = "Age".localizableString(lang: Helper.shared.strLanguage)
        //lblDistance_title.text = "Distance".localizableString(lang: Helper.shared.strLanguage)
        lblStatus.text = "Status".localizableString(lang: Helper.shared.strLanguage)
        lblRelaStatus.text = "Relationship Status".localizableString(lang: Helper.shared.strLanguage)
        lblOnlineNow.text = "Online Now".localizableString(lang: Helper.shared.strLanguage)
        lblAll.text = "All".localizableString(lang: Helper.shared.strLanguage)
        
        txtSelectRelationshipStatus.placeholder = "No preference".localizableString(lang: Helper.shared.strLanguage)
        txtLookingFor.placeholder = "No preference".localizableString(lang: Helper.shared.strLanguage)
    }
    func setupUI() {
        
        self.tabBarController?.tabBar.isHidden = true
        txtSelectRelationshipStatus.delegate = self
        txtDenomination.delegate = self
        txtLookingFor.delegate = self
    }
    func setAgeSlider(){
        //let slider = MultiSlider()
        //--Age
        ageSlider.minimumValue = 18
        ageSlider.maximumValue = 70
        ageSlider.orientation = .horizontal
        ageSlider.value = [18, 70]
        
        ageSlider.addTarget(self, action: #selector(sliderChanged(slider:)), for: .valueChanged)
        ageSlider.addTarget(self, action: #selector(sliderChanged(slider:)), for: . touchUpInside)
        
        //--Distance
        distanceSlider.minimumValue = 1
        distanceSlider.maximumValue = 500
        distanceSlider.orientation = .horizontal
        distanceSlider.value = [500]
        
        
        distanceSlider.addTarget(self, action: #selector(distanceSliderChanged(slider:)), for: .valueChanged)
        distanceSlider.addTarget(self, action: #selector(distanceSliderChanged(slider:)), for: . touchUpInside)
    }
    @objc func sliderChanged(slider: MultiSlider) {
        print("thumb \(slider.draggedThumbIndex) moved")
        print("now thumbs are at \(slider.minimumValue)") // e.g., [1.0, 4.5, 5.0]
        lblMinAge.text = String(format: "%.0f", slider.value[0])
        lblMaxAge.text = String(format: "%.0f", slider.value[1])
    }
    @objc func distanceSliderChanged(slider: MultiSlider) {
        print("thumb \(slider.value) moved")
        print("now thumbs are at \(slider.minimumValue)") // e.g., [1.0, 4.5, 5.0]
        
        
        if slider.value[0] == 500 {
            lblDistanceValue.text = "Max"//String(format: "%.0f\("+")", slider.value[0])
        } else {
            lblDistanceValue.text = String(format: "%.0f", slider.value[0])
        }
        
    }
    func setSelectedValue(){
        //--
        let str_m_age = Int(UserDefaults.standard.object(forKey: "age_minimum_filter") as? String ?? "18") ?? 0
        let str_mx_Age = Int(UserDefaults.standard.object(forKey: "age_maximum_filter") as? String ?? "70") ?? 0
        let age_minimum_filter = CGFloat(str_m_age)
        let age_maximum_filter = CGFloat(str_mx_Age)
        let distance_value_filter = Int(UserDefaults.standard.object(forKey: "distance_value_filter") as? String ?? "500") ?? 0
        let str_status_filter = UserDefaults.standard.object(forKey: "status_filter") as? String ?? OnlineStatus.no.rawValue.localizableString(lang: Helper.shared.strLanguage)
        let str_relationship_status_filter = UserDefaults.standard.object(forKey: "relationship_status_filter") as? String ?? ""
        let str_denomination_filter = UserDefaults.standard.object(forKey: "denomination_filter") as? String ?? ""
        let str_looking_for_filter = UserDefaults.standard.object(forKey: "looking_for_filter") as? String ?? ""
        
        lblMinAge.text = "\(str_m_age)"
        lblMaxAge.text = "\(str_mx_Age)"
        ageSlider.value = [age_minimum_filter, age_maximum_filter]
        
        if distance_value_filter == 500 {
            lblDistanceValue.text = "Max"//"\(distance_value_filter)\("+")"
        } else {
            lblDistanceValue.text = "\(distance_value_filter)"
        }
        
        distanceSlider.value = [CGFloat(distance_value_filter)]
        
        if str_status_filter == OnlineStatus.yes.rawValue || str_status_filter == "نعم" {
            
            imgOnlineNow.image = #imageLiteral(resourceName: "radio_filled")
            imgAll.image = #imageLiteral(resourceName: "radio_empty")
            selectedStatus = OnlineStatus.yes.rawValue
            
        } else if str_status_filter == OnlineStatus.no.rawValue || str_status_filter == "رقم" {
            imgOnlineNow.image = #imageLiteral(resourceName: "radio_empty")
            imgAll.image = #imageLiteral(resourceName: "radio_filled")
            selectedStatus = OnlineStatus.no.rawValue
        }
        
        //
        txtDenomination.text = str_denomination_filter
        
        //
        if str_relationship_status_filter == "No preference" || str_relationship_status_filter == "بدون تفضيل" {
            txtSelectRelationshipStatus.text = "No preference".localizableString(lang: Helper.shared.strLanguage)
        } else if str_relationship_status_filter == "Never married" || str_relationship_status_filter == "لم يسبق الزواج" {
            txtSelectRelationshipStatus.text = "Never married".localizableString(lang: Helper.shared.strLanguage)
        } else if str_relationship_status_filter == "Single" || str_relationship_status_filter == "أعزب" {
            txtSelectRelationshipStatus.text = "Single".localizableString(lang: Helper.shared.strLanguage)
        } else if str_relationship_status_filter == "Separated" || str_relationship_status_filter == "منفصل" {
            txtSelectRelationshipStatus.text = "Separated".localizableString(lang: Helper.shared.strLanguage)
        } else if str_relationship_status_filter == "Divorced" || str_relationship_status_filter == "مطلق" {
            txtSelectRelationshipStatus.text = "Divorced".localizableString(lang: Helper.shared.strLanguage)
        } else if str_relationship_status_filter == "Widowed" || str_relationship_status_filter == "ارمل" {
            txtSelectRelationshipStatus.text = "Widowed".localizableString(lang: Helper.shared.strLanguage)
        }
        
        //
        if str_looking_for_filter == "No preference" || str_looking_for_filter == "بدون تفضيل" {
            txtLookingFor.text = "No preference".localizableString(lang: Helper.shared.strLanguage)
        } else if str_looking_for_filter == "Marriage" || str_looking_for_filter == "الزواج" {
            txtLookingFor.text = "Marriage".localizableString(lang: Helper.shared.strLanguage)
        } else if str_looking_for_filter == "Relationship" {
            txtLookingFor.text = "Relationship".localizableString(lang: Helper.shared.strLanguage)
        } 
    }
    
    func pickUp(_ textField : UITextField){
        
        view.viewWithTag(1001)?.removeFromSuperview()
        view.viewWithTag(1002)?.removeFromSuperview()
        
        // UIPickerView
        self.myPickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.myPickerView.tag = 1001
        self.myPickerView.delegate = self
        self.myPickerView.dataSource = self
        self.myPickerView.backgroundColor = UIColor.white
        textField.inputView = self.myPickerView
        
        self.myPickerView.selectRow(1, inComponent: 0, animated: false)
        self.pickerView(self.myPickerView, didSelectRow: 1, inComponent: 0)
        
        // ToolBar
        toolBar = UIToolbar()
        toolBar.tag = 1002
        toolBar.barStyle = .default
        //toolBar.isTranslucent = true
        //toolBar.tintColor = UIColor.lightGray
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        toolBar.items = [UIBarButtonItem.init(title: "Done".localizableString(lang: Helper.shared.strLanguage), style: .done, target: self, action: #selector(doneClick))]
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
    }
    @objc func doneClick() {
        selectedTextfield?.resignFirstResponder()
     }
    
    //MARK: - @Webservice
    func getDenominationAPI() {
        
        if NetworkReachabilityManager()!.isReachable == false
        {
            return
        }
        //AppHelper.showLinearProgress()
        
        let headers:HTTPHeaders = ["Accept":"application/json"]
        
        AF.request(get_denomination, method: .get, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            
            print(response)
            
            if let json = response.value as? [String:Any] {
                
                if json["status"] as? String == "Success" {
                    
                    self.arrDenomination = json["data"] as? [[String:Any]]
                    
                }
            }
            
            //AppHelper.hideLinearProgress()
        }
    }
    
    //MARK: - @IBAction
    @IBAction func btnApply(_ sender: Any) {
        //--
        UserDefaults.standard.setValue(String(format: "%.0f", ageSlider.value[0]), forKey: "age_minimum_filter")
        UserDefaults.standard.setValue(String(format: "%.0f", ageSlider.value[1]), forKey: "age_maximum_filter")
        UserDefaults.standard.setValue(String(format: "%.0f", distanceSlider.value[0]), forKey: "distance_value_filter")
        UserDefaults.standard.setValue(selectedStatus, forKey: "status_filter")
            
        UserDefaults.standard.setValue(txtSelectRelationshipStatus.text, forKey: "relationship_status_filter")
        
        UserDefaults.standard.setValue(txtDenomination.text, forKey: "denomination_filter")
        
        UserDefaults.standard.setValue(txtLookingFor.text, forKey: "looking_for_filter")
        
        UserDefaults.standard.setValue("1", forKey: "apply_filter")
        UserDefaults.standard.synchronize()
        
        //delegate?.applyFilter()
        //--
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnStatus(_ sender: UIButton) {
        
        if sender.tag == 101 {
            imgOnlineNow.image = #imageLiteral(resourceName: "radio_filled")
            imgAll.image = #imageLiteral(resourceName: "radio_empty")
            selectedStatus = OnlineStatus.yes.rawValue
        } else {
            imgOnlineNow.image = #imageLiteral(resourceName: "radio_empty")
            imgAll.image = #imageLiteral(resourceName: "radio_filled")
            selectedStatus = OnlineStatus.no.rawValue
        }
    }
    
    
}
extension FilterVC:UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if selectedTextfield == txtSelectRelationshipStatus {
            return arrRelationshipStatus.count
        } else if selectedTextfield == txtDenomination {
            return (arrDenomination?.count ?? 0)+1
        } else if selectedTextfield == txtLookingFor {
            return arrLookingFor.count
        }
        return 0
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if selectedTextfield == txtSelectRelationshipStatus {
            if row == 1 {
                return "No preference".localizableString(lang: Helper.shared.strLanguage)
            }
            return arrRelationshipStatus[row]
        } else if selectedTextfield == txtDenomination {
            
            if row == 0 {
                return "Select Denomination"
            }
            return arrDenomination?[row-1]["name"] as? String
        } else if selectedTextfield == txtLookingFor {
            if row == 1 {
                return "No preference".localizableString(lang: Helper.shared.strLanguage)
            }
            return arrLookingFor[row]
        }
        return ""
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        
        if selectedTextfield == txtSelectRelationshipStatus {
            if row != 0 {
                self.txtSelectRelationshipStatus.text = arrRelationshipStatus[row]
            } else if row == 0 {
                self.txtSelectRelationshipStatus.text = ""
            }
        } else if selectedTextfield == txtDenomination {
            
            if row != 0 {
                self.txtDenomination.text = arrDenomination?[row-1]["name"] as? String
            } else if row == 0 {
                self.txtDenomination.text = ""
            }
        } else if selectedTextfield == txtLookingFor {
            if row != 0 {
                self.txtLookingFor.text = arrLookingFor[row]
            } else if row == 0 {
                self.txtLookingFor.text = ""
            }
        }
        
    }
}
extension FilterVC:UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        selectedTextfield = textField
        self.pickUp(textField)
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}

extension FilterVC: HeaderView_Protocol{
    func btnBack() {
        self.navigationController?.popViewController(animated: true)
    }
}
