//
//  GetmarriedVC.swift
//  HalalDating
//
//  Created by Maulik Vora on 26/11/21.
//

import UIKit
import CoreLocation
import Alamofire
import GoogleMaps


class GetmarriedVC: UIViewController {
    //MARK: - @IBOutlet
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var tblList: UITableView!
    
    
    //MARK: - Veriable
    var userModel = UserModel()
    var isComeProfile = false
    var arrList = ["Marriage within a year".localizableString(lang: Helper.shared.strLanguage),
                   "Marriage in 1-2 Years".localizableString(lang: Helper.shared.strLanguage),
                   "Marriage in 3-4 Years".localizableString(lang: Helper.shared.strLanguage),
                   "Marriage in 4+ Years".localizableString(lang: Helper.shared.strLanguage),
                   "Serious Relationship".localizableString(lang: Helper.shared.strLanguage),
                   "Don’t know yet".localizableString(lang: Helper.shared.strLanguage)]
    var selectIndex = 0
    var delegateUpdateProfileInfo:UpdateProfileInfo?
    
    let locationManager = CLLocationManager()
    
    private var isLocationUpdated = false
    private var currentCountry = ""

    
    
    //MARK: - func
    override func viewDidLoad() {
        super.viewDidLoad()
        setLanguageUI()
        checkAndPromptForLocation()
        setProgress()
        registerCell()
        AppHelper.updateScreenNumber(userID: userModel.data?.id ?? 0, screenNumber: 20, token: userModel.data?.api_token ?? "")
        
        //--
        if isComeProfile{
            setHeaderView()
            setProfile()
            btnNext.setTitle("DONE".localizableString(lang: Helper.shared.strLanguage), for: .normal)
        }else{
            headerView.delegate_HeaderView = self
            btnNext.setTitle("NEXT".localizableString(lang: Helper.shared.strLanguage), for: .normal)
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )

    }
    
    @objc func appDidBecomeActive() {
        checkAndPromptForLocation()
    }

    
    func setLanguageUI() {
        
        if Helper.shared.strLanguage == "ar" {
            lblTitle.semanticContentAttribute = .forceRightToLeft
            headerView.semanticContentAttribute = .forceRightToLeft
        }
        lblTitle.text = "What is your dating purpose?".localizableString(lang: Helper.shared.strLanguage)
    }
    
    func setHeaderView(){
        headerView.delegate_HeaderView = self
        headerView.progressBar.isHidden = true
        headerView.imgAppIcon.isHidden = true
        headerView.lblTitle.isHidden = false
        headerView.lblTitle.text = "Edit Profile"
    }
    
    
    func checkAndPromptForLocation() {
        // Initialize location manager
        locationManager.delegate = self

        guard CLLocationManager.locationServicesEnabled() else {
            // Show alert if needed
            return
        }

        // Check authorization status
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
        case .denied, .restricted:
            showSettingsAlert()
            
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            
        @unknown default:
            break
        }
    }
    
    // Show alert to guide user to settings if location services are denied or restricted
    func showSettingsAlert() {
        let alert = UIAlertController(
            title: Constant.locationAlertTitle,
            message: Constant.locationAlertMessageGetMarried,
            preferredStyle: .alert
        )
//        alert.addAction(.init(title: "Cancel", style: .cancel))
        alert.addAction(.init(title: Constant.openSetting, style: .default) { _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        })

//        let cancelAction = UIAlertAction(
//            title: "Cancel",
//            style: .cancel,
//            handler: nil
//        )
//        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }

    
    func registerCell(){
        tblList.register(UINib(nibName: "ProfileOptionCell", bundle: nil), forCellReuseIdentifier: "ProfileOptionCell")
    }
    func setProgress(){
        let percentProgress = Float(15.0/16.0)
        headerView.progressBar.setProgress(percentProgress, animated: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
          UIView.animate(withDuration: 1, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction], animations: { [unowned self] in
              //headerView.progressBar.setProgress(0, animated: true)
              let percentProgress = Float(16.0/16.0)
              headerView.progressBar.setProgress(percentProgress, animated: true)
          })
        }
    }
    func setProfile(){
//        for index in 0..<arrList.count{
//            let title = arrList[index]
//            if title.lowercased() == "\(userModel.data?.married_year ?? "")".lowercased(){
//                selectIndex = index
//            }
//        }
        
        if (userModel.data?.married_year ?? "") == "Marriage within a year" || (userModel.data?.married_year ?? "") == "الزواج خلال عام" {
            selectIndex = 0
        } else if (userModel.data?.married_year ?? "") == "Marriage in 1-2 Years" || (userModel.data?.married_year ?? "") == "الزواج خلال 1-2 اعوام" {
            selectIndex = 1
        } else if (userModel.data?.married_year ?? "") == "Marriage in 3-4 Years" || (userModel.data?.married_year ?? "") == "الزواج خلال 3-4 اعوام" {
            selectIndex = 2
        } else if (userModel.data?.married_year ?? "") == "Marriage in 4+ Years" || (userModel.data?.married_year ?? "") == "الزواج خلال اكثر من 4 اعوام" {
            selectIndex = 3
        } else if (userModel.data?.married_year ?? "") == "Serious Relationship" || (userModel.data?.married_year ?? "") == "علاقة جدية" {
            selectIndex = 4
        } else if (userModel.data?.married_year ?? "") == "Don’t know yet" || (userModel.data?.married_year ?? "") == "لا أعرف بعد" {
            selectIndex = 5
        }
        tblList.reloadData()
    }
    
    //MARK: - ApiCall

    func apiCall_updateProfile()  {
        if NetworkReachabilityManager()!.isReachable == false
        {
            let alert = UIAlertController(title: internetConnectedTitle.localizableString(lang: Helper.shared.strLanguage), message: internetConnected, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK".localizableString(lang: Helper.shared.strLanguage), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            var strEmail = ""
            
            if userModel.data?.email == "" || userModel.data?.email == nil {
                strEmail = Helper.shared.email
            } else {
                strEmail = userModel.data?.email ?? ""
            }
            
            
            let devicetoken = UserDefaults.standard.object(forKey: "fcm_devicetoken") as? String ?? "ios"
            
            
            let dicParam:[String:AnyObject] = ["name":userModel.data?.name as AnyObject,
                                               "dob":userModel.data?.dob as AnyObject,
                                               "gender":userModel.data?.gender as AnyObject,
                                               "relation_status":userModel.data?.relation_status as AnyObject,
                                               "kids":userModel.data?.kids as AnyObject,
                                               "education":userModel.data?.education as AnyObject,
                                               "height":userModel.data?.height as AnyObject,
                                               "looking_for":userModel.data?.looking_for as AnyObject,
                                               "work_out":userModel.data?.work_out as AnyObject,
                                               "language_id":userModel.data?.language_id as AnyObject,
                                               "denomination_id":userModel.data?.denomination_id as AnyObject,
                                               "religious":userModel.data?.religious as AnyObject,
                                               "pray":userModel.data?.pray as AnyObject,
                                               "eating":userModel.data?.eating as AnyObject,
                                               "go_church":userModel.data?.go_church as AnyObject,
                                               "smoke":userModel.data?.smoke as AnyObject,
                                               "alcohol":userModel.data?.alcohol as AnyObject,
                                               "your_zodiac":userModel.data?.your_zodiac as AnyObject,
                                               "married_year":userModel.data?.married_year as AnyObject,
                                               "fcm_token":devicetoken as AnyObject,
                                               "device_type":"iOS" as AnyObject,
                                               "email":strEmail as AnyObject,
                                               "quickbox_id":"" as AnyObject,
                                               "lat":userModel.data?.lat as AnyObject,
                                               "lng":userModel.data?.lng as AnyObject,
                                               "address":userModel.data?.address as AnyObject,
                                               "city":userModel.data?.state as AnyObject,
                                               "country":userModel.data?.country as AnyObject,
                                               "mobile_no":userModel.data?.mobile_no as AnyObject,
                                               "country_code":userModel.data?.country_code as AnyObject,
                                               "update_profile":"0" as AnyObject]
            
            AppHelper.showLinearProgress()
            self.view.isUserInteractionEnabled = false
            HttpWrapper.requestMultipartFormDataWithImageAndFile(a_updateProfile, dicsParams: dicParam, headers: ["Authorization":userModel.data?.api_token ?? ""], completion: { (response) in
                self.view.isUserInteractionEnabled = true
                AppHelper.hideLinearProgress()
                let dicsResponseFinal = response.replaceNulls(with: "")
                print(dicsResponseFinal as Any)
                
                let userListModel_ = UserModel(JSON: dicsResponseFinal as! [String : Any])!
                if userListModel_.code == 200{
                    
                    ///- to save login info
//                    if let userModelString = userListModel_.toJSONString() {
//                        Login_LocalDB.saveLoginInfo(strData: userModelString)
//                    }

                    let vc = YourPhotosVC(nibName: "YourPhotosVC", bundle: nil)
                    vc.userModel = self.userModel
                    self.navigationController?.pushViewController(vc, animated: true)

                } else if userListModel_.code == 401{
                    //AppHelper.Logout(navigationController: self.navigationController!)
                } else{
                    self.view.makeToast(dicsResponseFinal?.object(forKey: "message") as? String ?? "")
                }
                
            }) { (error) in
                print(error)
                self.view.isUserInteractionEnabled = true
                AppHelper.hideLinearProgress()
            }
        }
    }
    
    //MARK: - @IBAction
    @IBAction func btnNext(_ sender: Any) {
//        print(Helper.shared.currentCountry)
//        if let _ = AllowedCountry(rawValue: Helper.shared.currentCountry) {
//            userModel.data?.married_year = arrList[selectIndex]
//            
//            if isComeProfile{
//                delegateUpdateProfileInfo?.updateProfileInfo(userModel_: userModel)
//                self.navigationController?.popViewController(animated: true)
//                
//            } else{
//                apiCall_updateProfile()
//            }
//        } else {
//            AppHelper.showAlert("Unavailable", message: "This application is not presently accessible in your country.")
//        }
        
        userModel.data?.married_year = arrList[selectIndex]
        
        if isComeProfile{
            delegateUpdateProfileInfo?.updateProfileInfo(userModel_: userModel)
            self.navigationController?.popViewController(animated: true)
            
        } else{
            
            if userModel.data?.lat == "" && userModel.data?.lng == "" {
                self.checkAndPromptForLocation()
            } else {
                apiCall_updateProfile()
            }
            
            
        }
        
        
    }
}

extension GetmarriedVC: UITableViewDelegate, UITableViewDataSource
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

extension GetmarriedVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last, !isLocationUpdated else { return }
        isLocationUpdated = true
        manager.stopUpdatingLocation() // Stop further updates to save battery

        let geocoder = CLGeocoder()
        let englishLocale = Locale(identifier: "en_US")
        
        geocoder.reverseGeocodeLocation(location, preferredLocale: englishLocale) { [weak self] (placemarks, error) in
            if let error = error {
                print("Reverse geocoding failed: \(error.localizedDescription)")
                return
            }
            
            guard let placemark = placemarks?.first else {
                print("No placemark found")
                return
            }
            
            if let country = placemark.country {
                print("Country (English): \(country)") // e.g., "Sweden" (always English)
                Helper.shared.currentCountry = country
                
                if let _ = AllowedCountry(rawValue: country) {
                    guard let location = manager.location else {
                        print("Location unavailable")
                        return
                    }
                    
                    let latitude = String(location.coordinate.latitude)
                    let longitude = String(location.coordinate.longitude)
                    
                    if self?.userModel.data?.lat.isEmpty == true ||
                       self?.userModel.data?.lng.isEmpty == true {
                        self?.userModel.data?.lat = latitude
                        self?.userModel.data?.lng = longitude
                        self?.getAddressFromCoords(latitude: latitude, longitude: longitude)
                    }
                } else {
                    //AppHelper.showAlert("Unavailable", message: "This application is not presently accessible in your country.")
                }
            } else {
                print("No country name found in placemark")
            }
        }
    }
    
    func getAddressFromCoords(latitude: String, longitude: String) {
        guard let lat = Double(latitude), let lon = Double(longitude) else {
            print("Invalid latitude or longitude")
            return
        }
        
        let ceo = CLGeocoder()
        let locale = Locale(identifier: "en_US")
        let loc = CLLocation(latitude: lat, longitude: lon)
        
        ceo.reverseGeocodeLocation(loc, preferredLocale: locale) { [weak self] (placemarks, error) in
            if let error = error {
                print("Reverse geocode failed: \(error.localizedDescription)")
                return
            }
            
            guard let placemarks = placemarks, let pm = placemarks.first else {
                print("No placemarks found")
                return
            }
            
            var addressString = ""
            if let subLocality = pm.subLocality {
                addressString += subLocality + ", "
            }
            if let locality = pm.locality {
                addressString += locality + ", "
                DispatchQueue.main.async {
                    self?.userModel.data?.city = locality
                }
            }
            if let administrativeArea = pm.administrativeArea {
                addressString += administrativeArea + ", "
                DispatchQueue.main.async {
                    self?.userModel.data?.state = administrativeArea
                }
            }
            if let country = pm.country {
                addressString += country + ", "
                DispatchQueue.main.async {
                    self?.userModel.data?.country = country
                }
            }
            if let postalCode = pm.postalCode {
                addressString += postalCode + " "
            }
            
            print(addressString)
            
            DispatchQueue.main.async {
                self?.userModel.data?.lat = "\(loc.coordinate.latitude)"
                self?.userModel.data?.lng = "\(loc.coordinate.longitude)"
                self?.userModel.data?.address = addressString
            }
        }
    }

}

extension GetmarriedVC: HeaderView_Protocol{
    func btnBack() {
        self.navigationController?.popViewController(animated: true)
    }
}
