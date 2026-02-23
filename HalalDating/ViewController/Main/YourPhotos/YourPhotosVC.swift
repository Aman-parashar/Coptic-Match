//
//  YourPhotosVC.swift
//  HalalDating
//
//  Created by Maulik Vora on 26/11/21.
//

import UIKit
import FaceSDK
import Alamofire

class YourPhotosVC: UIViewController {
    //MARK: - @IBOutlet
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var img4: UIImageView!
    @IBOutlet weak var img5: UIImageView!
    @IBOutlet weak var img6: UIImageView!
    @IBOutlet weak var btnadd1: UIButton!
    @IBOutlet weak var btnadd2: UIButton!
    @IBOutlet weak var btnadd3: UIButton!
    @IBOutlet weak var btnadd4: UIButton!
    @IBOutlet weak var btnadd5: UIButton!
    @IBOutlet weak var btnadd6: UIButton!
    @IBOutlet weak var btnClear3: UIButton!
    @IBOutlet weak var btnClear4: UIButton!
    @IBOutlet weak var btnClear5: UIButton!
    @IBOutlet weak var btnClear6: UIButton!
    @IBOutlet var viewPopup: UIView!
    
    @IBOutlet weak var lblTitlePopUp: UILabel!
    @IBOutlet weak var lblSubtitlePopUp: UILabel!
    @IBOutlet weak var btnOkay: UIButton!
    @IBOutlet var viewLoader: UIView!
    @IBOutlet weak var lblTitleLoader: UILabel!
    @IBOutlet weak var imgLoader: UIImageView!
    
    //MARK: - Veriable
    var userModel = UserModel()
    var selectImageIndex = 0
    var isSelectImg1 = false
    var isSelectImg2 = false
    var isSelectImg3 = false
    var isSelectImg4 = false
    var isSelectImg5 = false
    var isSelectImg6 = false
    
    var intScannedImagesCount = 0
    
    var firstSelectedImage: UIImage?
    
    //MARK: - func
    override func viewDidLoad() {
        super.viewDidLoad()
        setLanguageUI()
        headerView.delegate_HeaderView = self
        headerView.progressBar.isHidden = true
        headerView.imgAppIcon.isHidden = true
        
        AppHelper.updateScreenNumber(userID: userModel.data?.id ?? 0, screenNumber: 21, token: userModel.data?.api_token ?? "")
        loadGIF()
        
    }
    
    func setLanguageUI() {
        
        if Helper.shared.strLanguage == "ar" {
            lblTitle.semanticContentAttribute = .forceRightToLeft
            lblDetail.semanticContentAttribute = .forceRightToLeft
            headerView.semanticContentAttribute = .forceRightToLeft
        }
        lblTitle.text = "Add your best photos".localizableString(lang: Helper.shared.strLanguage)
        lblDetail.text = "Please upload at least 3 real photos to your account. Accounts without real pictures may be subject to deactivation for verification reasons."
        lblTitlePopUp.text = "Take a selfie".localizableString(lang: Helper.shared.strLanguage)
        //lblSubtitlePopUp.text = "Please take a quick selfie to confirm you're a real person. Your selfie won't appear on your profile and will not be seen by our team.".localizableString(lang: Helper.shared.strLanguage)
        //lblTitleLoader.text = "We are reviewing your profile. Please wait to get approved.".localizableString(lang: Helper.shared.strLanguage)
        btnNext.setTitle("I accept".localizableString(lang: Helper.shared.strLanguage), for: .normal)
        btnOkay.setTitle("Okay".localizableString(lang: Helper.shared.strLanguage), for: .normal)
    }
    
    func openFaceDetector() {
        
        let configuration = FaceCaptureConfiguration {
            $0.cameraPosition = .front
            $0.isCloseButtonEnabled = true
            $0.isTorchButtonEnabled = true
            $0.isCameraSwitchButtonEnabled = true
        }
        
        FaceSDK.service.presentFaceCaptureViewController(
            from: self,
            animated: true,
            configuration: configuration,
            onCapture: { response in
                // ... check response.image for capture result.
                print(response)
                
                if response.error != nil {
                    
                    self.navigationController?.popViewController(animated: false)
                    return
                }
                
                if response.image?.image != nil {
                    
                    //
                    self.viewLoader.frame = self.view.bounds
                    self.view.addSubview(self.viewLoader)
                    //AppHelper.showLinearProgress()
                    for i in 0..<self.arrSelectedImage.count {
                        
                        self.matchImages(imgSelfieSelect:(response.image?.image)!, img: self.arrSelectedImage[i] as! UIImage, index:i)
                    }
                }
            },
            completion: nil
        )
    }
    
    func matchImages(imgSelfieSelect:UIImage, img:UIImage, index:Int) {
        
        let images = [
            MatchFacesImage(image: img, imageType: .printed),
            MatchFacesImage(image: imgSelfieSelect, imageType: .printed),
        ]
        let request = MatchFacesRequest(images: images)

        FaceSDK.service.matchFaces(request, completion: { response in
            // ... check response.results for results with score and similarity values.
            //print(response)
            
            let doubleSimilarity = Double(String(format: "%.2f", Double(truncating: response.results[0].similarity ?? 0.0000000)))
            
            print("\(img)=\(doubleSimilarity!)")
            
            if (doubleSimilarity ?? 0.0) < 0.60 {//0.10 {
                print("Image number \(index+1) doesnt match")
                AppHelper.returnTopNavigationController().view.makeToast("Image number \(index+1) doesn't match")
                //AppHelper.hideLinearProgress()
                self.viewLoader.removeFromSuperview()
                return
            }
            self.intScannedImagesCount += 1
            
            if self.intScannedImagesCount == self.arrSelectedImage.count {
                print("All Images matched")
                //AppHelper.hideLinearProgress()
                //self.viewLoader.removeFromSuperview()
                
//                let vc = SelfieConfirmVC(nibName: "SelfieConfirmVC", bundle: nil)
//                vc.imgSelfieSelect = imgSelfieSelect
//                vc.userModel = self.userModel
//                vc.arrSelectedImage = self.arrSelectedImage
//                self.navigationController?.pushViewController(vc, animated: true)
                
//                self.apiCall_updateProfile(quickblox_id: "")
                self.updateProfileWithImage()
            }
        })
    }
    
    func loadGIF(){
        do {
            let gif = try UIImage(gifName: "spinner-loading.gif")
            imgLoader.setGifImage(gif, loopCount: -1)
        } catch {
            print(error)
        }
    }
    
    func showCongratsView() {
        
        let customView = Bundle.main.loadNibNamed("CongratsView", owner: self, options: nil)?.first as? CongratsView
        
        //customView?.frame = self.view.bounds
        //self.view.addSubview(customView!)
        
        let applicationDelegate = UIApplication.shared.delegate as? AppDelegate
        customView?.frame = (applicationDelegate?.window?.bounds)!
        applicationDelegate?.window?.addSubview(customView!)
    }
    
    //MARK: - ApiCall

    func apiCall_updateProfile(quickblox_id: String)  {
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
                                               "quickbox_id":quickblox_id as AnyObject,
                                               "lat":userModel.data?.lat as AnyObject,
                                               "lng":userModel.data?.lng as AnyObject,
                                               "address":userModel.data?.address as AnyObject,
                                               "city":userModel.data?.state as AnyObject,
                                               "country":userModel.data?.country as AnyObject,
                                               "mobile_no":userModel.data?.mobile_no as AnyObject,
                                               "country_code":userModel.data?.country_code as AnyObject,
                                               "update_profile":"1" as AnyObject,
                                               "selfie":arrSelectedImage[0] as AnyObject,
                                               "image[]":arrSelectedImage as AnyObject]
            
            AppHelper.showLinearProgress()
            self.view.isUserInteractionEnabled = false
//            HttpWrapper.requestMultipartFormDataWithImageAndFile(a_updateProfile, dicsParams: dicParam, headers: ["Authorization":userModel.data?.api_token ?? ""], completion: { (response) in
//                self.view.isUserInteractionEnabled = true
//                self.viewLoader.removeFromSuperview()
//                AppHelper.hideLinearProgress()
//                let dicsResponseFinal = response.replaceNulls(with: "")
//                print(dicsResponseFinal as Any)
//                
//                let userListModel_ = UserModel(JSON: dicsResponseFinal as! [String : Any])!
//                if userListModel_.code == 200{
//                    
//                    if let userListModel_ = UserModel(JSON: dicsResponseFinal as! [String : Any])!.toJSONString(){
//                        Login_LocalDB.saveLoginInfo(strData: userListModel_)
//                    }
//                    
//                    UserDefaults.standard.set("true", forKey: "is_Login")
//                    UserDefaults.standard.set(self.userModel.data?.notification, forKey: "isNotificationOn")
//                    UserDefaults.standard.synchronize()
//                    
//                    AppHelper.openTabBar()
//                    self.showCongratsView()
//                    
////                    let vc = CompleteProfileVC(nibName: "CompleteProfileVC", bundle: nil)
////                    vc.userModel = userListModel_
////                    self.navigationController?.pushViewController(vc, animated: true)
//                    
//                    //AppHelper.returnTopNavigationController().view.makeToast(dicsResponseFinal?.object(forKey: "message") as? String ?? "")
//                    
//                }else if userListModel_.code == 401{
//                    //AppHelper.Logout(navigationController: self.navigationController!)
//                }else{
//                    self.view.makeToast(dicsResponseFinal?.object(forKey: "message") as? String ?? "")
//                }
//            }) { (error) in
//                print(error)
//                self.view.isUserInteractionEnabled = true
//                self.viewLoader.removeFromSuperview()
//                AppHelper.hideLinearProgress()
//            }
            
            HttpWrapper.requestMultipartFormDataWithImageAndFile(a_updateProfile, dicsParams: dicParam,
                headers: ["Authorization": userModel.data?.api_token ?? ""],
                completion: { [weak self] (response) in
                    guard let self = self else { return }
                    
                    self.view.isUserInteractionEnabled = true
                    self.viewLoader.removeFromSuperview()
                    AppHelper.hideLinearProgress()
                    
                    // Check for specific error responses
                    if let errorMessage = response["message"] as? String,
                       response["code"] as? Int != 200 {
                        self.view.makeToast(errorMessage)
                        return
                    }
                    
                    // Process successful response
                    if let userListModel_ = UserModel(JSON: response as! [String: Any]) {
                        if userListModel_.code == 200 {
                            // Success path
                            if let userModelString = userListModel_.toJSONString() {
                                Login_LocalDB.saveLoginInfo(strData: userModelString)
                            }
                            
                            UserDefaults.standard.set("true", forKey: "is_Login")
                            UserDefaults.standard.set(self.userModel.data?.notification,
                                                    forKey: "isNotificationOn")
                            UserDefaults.standard.synchronize()
                            
                            AppHelper.openTabBar()
                            self.showCongratsView()
                        } else {
                            self.view.makeToast(response["message"] as? String ?? "Unknown error")
                        }
                    }
                },
                errorBlock: { [weak self] (error) in
                    guard let self = self else { return }
                    
                    print(error)
                    self.view.isUserInteractionEnabled = true
                    self.viewLoader.removeFromSuperview()
                    AppHelper.hideLinearProgress()
                    
                    // Show error to user
                    self.view.makeToast("Failed to upload photos. Please try again.")
            })
        }
    }
    
    private func updateProfileWithImage() {
        if NetworkReachabilityManager()!.isReachable == false {
            let alert = UIAlertController(title: internetConnectedTitle.localizableString(lang: Helper.shared.strLanguage), message: internetConnected, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK".localizableString(lang: Helper.shared.strLanguage), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            let parameters: [String: AnyObject] = [
                "update_profile": "1" as AnyObject,
                "image[]":arrSelectedImage as AnyObject
            ]
            
            AppHelper.showLinearProgress()
            HttpWrapper.requestMultipartFormDataWithImageAndFile(update_profile_images, dicsParams: parameters, headers: ["Authorization": userModel.data?.api_token ?? ""]) { [weak self] (response) in
                guard let self = self else { return }
                
                self.view.isUserInteractionEnabled = true
                self.viewLoader.removeFromSuperview()
                AppHelper.hideLinearProgress()
                
                // Check for specific error responses
                if let errorMessage = response["message"] as? String,
                   response["code"] as? Int == 201 && response["code"] as? Int != 200{
                    let vc = AdminAppovalVC(nibName: "AdminAppovalVC", bundle: nil)
                    vc.message = errorMessage
                    vc.isBackToHome = true
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                    return
                } else {
                    var errorMessage = response["message"] as? String ?? ""
                    self.view.makeToast(errorMessage)
                }
                
                // Process successful response
                if let userListModel_ = UserModel(JSON: response as! [String: Any]) {
                    if userListModel_.code == 200 {
                        
                        ///- to save login info
                        if let userModelString = userListModel_.toJSONString() {
                            Login_LocalDB.saveLoginInfo(strData: userModelString)
                        }

                        UserDefaults.standard.set("true", forKey: "is_Login")
                        UserDefaults.standard.set(self.userModel.data?.notification,
                                                  forKey: "isNotificationOn")
                        UserDefaults.standard.synchronize()
                        
                        AppHelper.openTabBar()
                        self.showCongratsView()
                    } else {
                        self.view.makeToast(response["message"] as? String ?? "Unknown error")
                    }
                }
                
                
            } errorBlock: { [weak self] (error) in
                guard let self = self else { return }
                
                print(error)
                self.view.isUserInteractionEnabled = true
                self.viewLoader.removeFromSuperview()
                AppHelper.hideLinearProgress()
                
                // Show error to user
                self.view.makeToast("Failed to upload photos. Please try again.")
            }
            
        }
    }
    //MARK: - @IBAction
    let arrSelectedImage = NSMutableArray()
    
    @IBAction func btnNext(_ sender: Any) {
        
        arrSelectedImage.removeAllObjects()
        if isSelectImg1{
            if let img_ = img1.image{
                arrSelectedImage.add(img_)
            }
        }
        if isSelectImg2{
            if let img_ = img2.image{
                arrSelectedImage.add(img_)
            }
        }
        if isSelectImg3{
            if let img_ = img3.image{
                arrSelectedImage.add(img_)
            }
        }
        if isSelectImg4{
            if let img_ = img4.image{
                arrSelectedImage.add(img_)
            }
        }
        if isSelectImg5{
            if let img_ = img5.image{
                arrSelectedImage.add(img_)
            }
        }
        if isSelectImg6{
            if let img_ = img6.image{
                arrSelectedImage.add(img_)
            }
        }

        if arrSelectedImage.count >= 3{
            //--
//            viewPopup.frame = view.bounds
//            view.addSubview(viewPopup)
//            self.apiCall_updateProfile(quickblox_id: "")
            self.updateProfileWithImage()
        }else{
            AppHelper.showAlert(kAlertTitle, message: k_three_photo)
        }
        
        
    }
    
    @IBAction func btnOkay(_ sender: Any) {
        
        viewPopup.removeFromSuperview()
        //
        intScannedImagesCount = 0
        openFaceDetector()
    }
    
    @IBAction func btnAddImg1(_ sender: Any) {
        self.view.endEditing(true)
        selectImageIndex = 1
        onTapImage()
    }
    @IBAction func btnAddImg2(_ sender: Any) {
        self.view.endEditing(true)
        selectImageIndex = 2
        onTapImage()
    }
    @IBAction func btnAddImg3(_ sender: Any) {
        self.view.endEditing(true)
        selectImageIndex = 3
        onTapImage()
    }
    @IBAction func btnAddImg4(_ sender: Any) {
        self.view.endEditing(true)
        selectImageIndex = 4
        onTapImage()
    }
    @IBAction func btnAddImg5(_ sender: Any) {
        self.view.endEditing(true)
        selectImageIndex = 5
        onTapImage()
    }
    @IBAction func btnAddImg6(_ sender: Any) {
        self.view.endEditing(true)
        selectImageIndex = 6
        onTapImage()
    }
    @IBAction func btnClearImg3(_ sender: Any) {
//        isSelectImg3 = false
//        img3.image = nil
//        btnClear3.isHidden = true
    }
    @IBAction func btnClearImg4(_ sender: Any) {
        isSelectImg4 = false
        img4.image = nil
        btnClear4.isHidden = true
    }
    @IBAction func btnClearImg5(_ sender: Any) {
        isSelectImg5 = false
        img5.image = nil
        btnClear5.isHidden = true
    }
    @IBAction func btnClearImg6(_ sender: Any) {
        isSelectImg6 = false
        img6.image = nil
        btnClear6.isHidden = true
    }
    
    
//    func matchProfileImage(img:UIImage, image_id:String) {
//        
//        AppHelper.showLinearProgress()
//        
//        let user_Image = userModel.data?.user_image[0]
//        let imgName = "\(kImageBaseURL)\(user_Image?.image ?? "")".replacingOccurrences(of: " ", with: "%20")
//
//        let url = URL(string: imgName)
//        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
//        
//        let images = [
//            MatchFacesImage(image: img, imageType: .printed),
//            MatchFacesImage(image: UIImage(data: data!)!, imageType: .printed),
//        ]
//        let request = MatchFacesRequest(images: images)
//
//        FaceSDK.service.matchFaces(request, completion: { response in
//            // ... check response.results for results with score and similarity values.
//            //print(response)
//            
//            let doubleSimilarity = Double(String(format: "%.2f", Double(truncating: response.results[0].similarity ?? 0.0000000)))
//            
//            print("\(img)=\(doubleSimilarity!)")
//            
//            if (doubleSimilarity ?? 0.0) < 0.60 {//0.10 {
//                
//                AppHelper.returnTopNavigationController().view.makeToast("Image doesn't match")
//                AppHelper.hideLinearProgress()
//                return
//            }
//            
//            
//            print("Image matched")
//            AppHelper.hideLinearProgress()
//            
//            //
//            if self.selectImageIndex == 1{
//                self.img1.image = img
//                self.isSelectImg1 = true
//            }
//            if self.selectImageIndex == 2{
//                self.img2.image = img
//                self.isSelectImg2 = true
//            }
//            if self.selectImageIndex == 3{
//                self.img3.image = img
//                self.isSelectImg3 = true
//                
//                //--
//                //self.btnClear3.isHidden = false
//            }
//            if self.selectImageIndex == 4{
//                self.img4.image = img
//                self.isSelectImg4 = true
//                
//                //--
//                self.btnClear4.isHidden = false
//            }
//            if self.selectImageIndex == 5{
//                self.img5.image = img
//                self.isSelectImg5 = true
//                
//                //--
//                self.btnClear5.isHidden = false
//            }
//            if self.selectImageIndex == 6{
//                self.img6.image = img
//                self.isSelectImg6 = true
//                
//                //--
//                self.btnClear6.isHidden = false
//            }
//                
////            self.apiCall_updateImage(img_: img, image_id: image_id)
//            
//        })
//    }
    
    func matchProfileImage(img: UIImage, matchWith: UIImage, image_id: String) {
        AppHelper.showLinearProgress()
        
        // Create images array with both selected images
        let images = [
            MatchFacesImage(image: img, imageType: .printed),
            MatchFacesImage(image: matchWith, imageType: .printed)
        ]
        
        let request = MatchFacesRequest(images: images)

        FaceSDK.service.matchFaces(request, completion: { response in
            if let similarity = response.results.first?.similarity {
                let similarityScore = Double(truncating: similarity)
                
                if similarityScore < 0.60 {
//                    AppHelper.returnTopNavigationController().view.makeToast("Images don't match")
                    AppHelper.hideLinearProgress()
                    AppHelper.returnTopNavigationController().view.makeToast("Image number \(self.selectImageIndex) doesn't match")
                } else {
                    print("Images matched")
                    AppHelper.hideLinearProgress()
                    // Update UI based on `selectImageIndex`

                    if self.selectImageIndex == 1{
                        self.img1.image = img
                        self.isSelectImg1 = true
                    }
                    if self.selectImageIndex == 2{
                        self.img2.image = img
                        self.isSelectImg2 = true
                    }
                    if self.selectImageIndex == 3{
                        self.img3.image = img
                        self.isSelectImg3 = true
                        
                        //--
                        //self.btnClear3.isHidden = false
                    }
                    if self.selectImageIndex == 4{
                        self.img4.image = img
                        self.isSelectImg4 = true
                        
                        //--
                        self.btnClear4.isHidden = false
                    }
                    if self.selectImageIndex == 5{
                        self.img5.image = img
                        self.isSelectImg5 = true
                        
                        //--
                        self.btnClear5.isHidden = false
                    }
                    if self.selectImageIndex == 6{
                        self.img6.image = img
                        self.isSelectImg6 = true
                        
                        //--
                        self.btnClear6.isHidden = false
                    }
                }
            }
            
            AppHelper.hideLinearProgress()
        })
    }


}

extension YourPhotosVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    //MARK:- ImagePicker delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            
            
//            if let firstSelectedImage = firstSelectedImage {
//                
//                matchProfileImage(img: image, matchWith: firstSelectedImage, image_id: "")
//                
//            } else {
//                
                firstSelectedImage = image
                
                if selectImageIndex == 1{
                    img1.image = image
                    isSelectImg1 = true
                    
                }
                if selectImageIndex == 2{
                    img2.image = image
                    isSelectImg2 = true
                    
                }
                if selectImageIndex == 3{
                    img3.image = image
                    isSelectImg3 = true
                    
                    //--
                    //btnClear3.isHidden = false
                }
                if selectImageIndex == 4{
                    img4.image = image
                    isSelectImg4 = true
                    
                    //--
                    btnClear4.isHidden = false
                }
                if selectImageIndex == 5{
                    img5.image = image
                    isSelectImg5 = true
                    
                    //--
                    btnClear5.isHidden = false
                }
                if selectImageIndex == 6{
                    img6.image = image
                    isSelectImg6 = true
                    
                    //--
                    btnClear6.isHidden = false
                }
//            }
        }
        

//        if let image = info[.originalImage] as? UIImage {
//            if selectImageIndex == 1{
//                img1.image = image
//                isSelectImg1 = true
//                
//            }
//            if selectImageIndex == 2{
//                img2.image = image
//                isSelectImg2 = true
//                
//            }
//            if selectImageIndex == 3{
//                img3.image = image
//                isSelectImg3 = true
//                
//                //--
//                //btnClear3.isHidden = false
//            }
//            if selectImageIndex == 4{
//                img4.image = image
//                isSelectImg4 = true
//                
//                //--
//                btnClear4.isHidden = false
//            }
//            if selectImageIndex == 5{
//                img5.image = image
//                isSelectImg5 = true
//                
//                //--
//                btnClear5.isHidden = false
//            }
//            if selectImageIndex == 6{
//                img6.image = image
//                isSelectImg6 = true
//                
//                //--
//                btnClear6.isHidden = false
//            }
//        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func onTapImage() {
        let alert = UIAlertController(title: "Choose Image".localizableString(lang: Helper.shared.strLanguage), message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera".localizableString(lang: Helper.shared.strLanguage), style: .default, handler: { _ in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Gallery".localizableString(lang: Helper.shared.strLanguage), style: .default, handler: { _ in
            self.openGallary()
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel".localizableString(lang: Helper.shared.strLanguage), style: .cancel, handler: nil))
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        self.present(alert, animated: true, completion: nil)
    }
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: kAlertTitle, message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK".localizableString(lang: Helper.shared.strLanguage), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
}


extension YourPhotosVC: HeaderView_Protocol{
    func btnBack() {
        self.navigationController?.popViewController(animated: true)
    }
}
