//
//  AppHelper.swift
//  Deputize Americar
//
//  Created by Darshak Trivedi.
//  Copyright © 2017 Scorch Mobile. All rights reserved.
//

import UIKit
//import MaterialComponents.MaterialProgressView
//import SJSwiftSideMenuController
import SDWebImage
import SafariServices
import MBProgressHUD
import FirebaseFirestore
import Alamofire

//let progressView_linear = MDCProgressView()

class AppHelper: NSObject
{
    
    class func returnTopNavigationController() -> UIViewController
    {
        if var topController = UIApplication.shared.keyWindow?.rootViewController
        {
            while let presentedViewController = topController.presentedViewController
            {
                topController = presentedViewController
            }
            return topController
        }
        return UIViewController()
    }
    /*
     func loginSuccess()
     {
     let mainVC = SJSwiftSideMenuController()
     let sideVC_L : SideMenu_Vc = (objSideMenuSB.instantiateViewController(withIdentifier: "SideMenu_Vc") as? SideMenu_Vc)!
     let sideVC_R : SideMenu_Vc = (objSideMenuSB.instantiateViewController(withIdentifier: "SideMenu_Vc") as? SideMenu_Vc)!
     
     let rootVC = HomeVC(nibName: "HomeVC", bundle: nil)
     
     
     SJSwiftSideMenuController.setUpNavigation(rootController: rootVC, leftMenuController: sideVC_L, rightMenuController: sideVC_R, leftMenuType: .SlideOver, rightMenuType: .SlideView)
     
     // SJSwiftSideMenuController.enableSwipeGestureWithMenuSide(menuSide: .LEFT)
     
     SJSwiftSideMenuController.enableDimbackground = true
     SJSwiftSideMenuController.leftMenuWidth = 300
     //=======================================
     
     self.window?.rootViewController = mainVC
     self.window?.makeKeyAndVisible()
     //
     //
     }
     
     */
    
    class func openTabBar() {
        
//        UITabBar.appearance().tintColor = UIColor(resource: .iconTint)
//        UITabBar.appearance().barTintColor = .white // Set barTintColor to black
//        UITabBar.appearance().backgroundColor = .white // Optional: Set the background color
//        UITabBar.appearance().unselectedItemTintColor = .white
        
        UITabBar.appearance().tintColor = UIColor(resource: .iconTint)
        UITabBar.appearance().barTintColor = UIColor(resource: .darkBlueBG)
        UITabBar.appearance().backgroundColor = UIColor(resource: .darkBlueBG)
        UITabBar.appearance().unselectedItemTintColor = .white
        UITabBar.appearance().isTranslucent = false
        
//        let appearance = UITabBarAppearance()
//        appearance.configureWithOpaqueBackground()
//        appearance.backgroundColor = UIColor(resource: .darkBlueBG)
//        
//        // Apply to all tab bar styles
//        UITabBar.appearance().standardAppearance = appearance
//        if #available(iOS 15.0, *) {
//            UITabBar.appearance().scrollEdgeAppearance = appearance
//        } else {
//            // Fallback on earlier versions
//        }
//        
//        // Set tint colors
//        UITabBar.appearance().tintColor = UIColor(resource: .iconTint)
//        UITabBar.appearance().unselectedItemTintColor = .white
//        
//        // Remove translucency
//        UITabBar.appearance().isTranslucent = false



        
        //--Tab Bar
        let vc1 = UINavigationController(rootViewController: HomeVC(nibName: "HomeVC", bundle: nil))
        let vc2 = UINavigationController(rootViewController: LikeVC(nibName: "LikeVC", bundle: nil))
        let vc3 = UINavigationController(rootViewController: ChatVC(nibName: "ChatVC", bundle: nil))
        let vc4 = UINavigationController(rootViewController: ProfileVC(nibName: "ProfileVC", bundle: nil))
        
        
        let controllers = [vc1, vc2, vc3, vc4]
        let vc = TabBarVC(nibName: "TabBarVC", bundle: nil)
        vc.viewControllers = controllers
        
        
        
        let t_1 = UITabBarItem(title: "", image: UIImage(named: "iconHomeTab"), selectedImage: UIImage(named: "iconHomeTabActive"))
        //t_1.imageInsets = UIEdgeInsets(top: 55, left: 0, bottom: 50, right: 0);
        t_1.imageInsets = UIEdgeInsets(top: 3, left: 0, bottom: 3, right: 0);
        vc1.tabBarItem = t_1
        
        let t_2 = UITabBarItem(title: "", image: UIImage(named: "iconLikeTab"), selectedImage: UIImage(named: "iconLikeTabActive"))
        //t_2.imageInsets = UIEdgeInsets(top: 50, left: 0, bottom: 45, right: 0);
        t_2.imageInsets = UIEdgeInsets(top: 3, left: 0, bottom: 3, right: 0);
        vc2.tabBarItem = t_2
        
        
        let t_3 = UITabBarItem(title: "", image: UIImage(named: "iconChatTab"), selectedImage: UIImage(named: "iconChatTabActive"))
        //t_3.imageInsets = UIEdgeInsets(top: 45, left: 0, bottom: 41, right: 0);
        t_3.imageInsets = UIEdgeInsets(top: 3, left: 0, bottom: 3, right: 0);
        vc3.tabBarItem = t_3
        
        let t_4 = UITabBarItem(title: "", image: UIImage(named: "iconProfileTab"), selectedImage: UIImage(named: "iconProfileTabActive"))
        //t_4.imageInsets = UIEdgeInsets(top: 55, left: 0, bottom: 50, right: 0);
        t_4.imageInsets = UIEdgeInsets(top: 3, left: 0, bottom: 3, right: 0);
        vc4.tabBarItem = t_4
        
//        UITabBar.appearance().tintColor = UIColor.black
//        UITabBar.appearance().barTintColor = .white
        //UITabBar.appearance().backgroundColor = #colorLiteral(red: 0.946852982, green: 0.9430886507, blue: 0.9245496392, alpha: 1)
        
        if Helper.shared.strLanguage == "ar"  {
            
            UITabBar.appearance().semanticContentAttribute = .forceRightToLeft
        } else {
            UITabBar.appearance().semanticContentAttribute = .forceLeftToRight
        }
        //--
        //appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        appDelegate.window?.rootViewController = vc
        appDelegate.window?.makeKeyAndVisible()
        

    }
    
    class func setStatusbarBG(){
        if #available(iOS 13, *)
        {
            let statusBar = UIView(frame: (appDelegate.window?.windowScene?.statusBarManager?.statusBarFrame)!)
            statusBar.backgroundColor = UIColor(named: "AppPrimaryBlue")
            statusBar.tintColor = .white
            appDelegate.window?.addSubview(statusBar)
            
        } else {
            // ADD THE STATUS BAR AND SET A CUSTOM COLOR
            let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
            if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
                statusBar.backgroundColor = UIColor(named: "AppPrimaryBlue")
                statusBar.tintColor = .white
            }
            UIApplication.shared.statusBarStyle = .lightContent
        }
    }
    
    
    class func Logout(navigationController: UINavigationController?){
        let logoutAlert = UIAlertController(title: kAlertTitle, message: "Your session has timed out.".localizableString(lang: Helper.shared.strLanguage), preferredStyle: UIAlertController.Style.alert)
        logoutAlert.addAction(UIAlertAction(title: "Ok".localizableString(lang: Helper.shared.strLanguage), style: .default, handler: { (action: UIAlertAction!) in
            
            //--
            AppHelper.removeAllNsUserDefault()
            
             //--
             let vc = objMainSB.instantiateViewController(withIdentifier: "MainVC") as! MainVC
             let appDelegate = UIApplication.shared.delegate as! AppDelegate
             appDelegate.window?.rootViewController = UINavigationController.init(rootViewController: vc)
             //appDelegate.window?.makeKeyAndVisible()
             
        }))
        
        //        logoutAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
        //            print("Handle Cancel Logic here")
        //        }))
        
        navigationController?.present(logoutAlert, animated: true, completion: nil)
    }
    
    class func setDottedBorder(viewy: UIView, width: Int, height: Int){
        let yourViewBorder = CAShapeLayer()
        yourViewBorder.strokeColor = UIColor.black.cgColor
        yourViewBorder.lineDashPattern = [2, 2]
        yourViewBorder.frame = CGRect(x: 0, y: 0, width: width, height: height)
        yourViewBorder.fillColor = nil
        yourViewBorder.path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: width, height: height)).cgPath
        viewy.layer.addSublayer(yourViewBorder)
    }
    
    class func setTabBarFont(){
        //--
        let appearance = UITabBarItem.appearance()
        let attributes = [NSAttributedString.Key.font:UIFont(name: "HelveticaNeue-Bold", size: 14)]
        appearance.setTitleTextAttributes(attributes as [NSAttributedString.Key : Any], for: .normal)
    }
    
    //---------------------------------------
    class func image_blurEffect(image:UIImageView){
        let context = CIContext(options: nil)
        let currentFilter = CIFilter(name: "CIGaussianBlur")
        let beginImage = CIImage(image: image.image!)
        currentFilter!.setValue(beginImage, forKey: kCIInputImageKey)
        currentFilter!.setValue(10, forKey: kCIInputRadiusKey)
        
        let cropFilter = CIFilter(name: "CICrop")
        cropFilter!.setValue(currentFilter!.outputImage, forKey: kCIInputImageKey)
        cropFilter!.setValue(CIVector(cgRect: beginImage!.extent), forKey: "inputRectangle")
        
        let output = cropFilter!.outputImage
        let cgimg = context.createCGImage(output!, from: output!.extent)
        let processedImage = UIImage(cgImage: cgimg!)
        image.image = processedImage
        
    }
    
    class func statusBarHeight() -> CGFloat {
        let statusBarSize = UIApplication.shared.statusBarFrame.size
        return Swift.min(statusBarSize.width, statusBarSize.height)
    }
    class func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    class func timeAgoSinceDate(_ date:Date,currentDate:Date, numericDates:Bool) -> String {
        let calendar = Calendar.current
        let now = currentDate
        let earliest = (now as NSDate).earlierDate(date)
        let latest = (earliest == now) ? date : now
        let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
        
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
    }
    
    class func select_loginType() -> String
    {
        if let select_loginType =  UserDefaults.standard.object(forKey: "select_loginType") as? String
        {
            return select_loginType
        }
        else
        {
            return ""
        }
    }
    
    class func getColor_green() -> UIColor
    {
        return UIColor(red: 19/255.0, green: 137/255.0, blue: 73/255.0, alpha: 1.0)
    }
    
    class func getColor_Orange() -> UIColor
    {
        return UIColor(red: 201/255.0, green: 162/255.0, blue: 30/255.0, alpha: 1.0)
    }
    
    class func showAlert(_ title:String, message:String)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let defaultAction = UIAlertAction(title: "OK".localizableString(lang: Helper.shared.strLanguage), style:UIAlertAction.Style.default, handler: nil)
        alertController.addAction(defaultAction)
        if var topController = UIApplication.shared.keyWindow?.rootViewController
        {
            while let presentedViewController = topController.presentedViewController
            {
                topController = presentedViewController
            }
            topController.present(alertController, animated: true, completion: nil)
        }
    }
    
    class func getCurrentDate(dateFormate:String) -> String
    {
        let date = Date()
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = dateFormate
        let endDate = dateformatter.string(from: date)
        return endDate
    }
    
    class func isValidEmail(_ testStr:String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    class func isValid_Pwd_Oneletter_Onenumber_OnespecialChar(_ testStr:String) -> Bool
    {
        //Note : "YOUR PASSWORD NEEDS TO CONTAIN AT LEAST ONE CAPITAL, ONE LOWERCASE, ONE NUMBER AND ONE SPECIAL CHARACTER".
        
        let emailRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{6,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    class func isValidMobileNumber(_ testStr:String) -> Bool {
        let mobileRegEx = "[0-9]+"
        let mobileTest = NSPredicate(format:"SELF MATCHES %@", mobileRegEx)
        print(mobileTest.evaluate(with: testStr))
        return mobileTest.evaluate(with: testStr)
    }
    
    
    class func isNull(_ testStr:String) -> Bool {
        let trimmed = testStr.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed == "" {
            return true
        }
        else {
            return false
        }
    }
    
    class func minLength(_ testStr:String,_ length:Int) -> Bool {
        if testStr.count < length {
            return false
        }
        else {
            return true
        }
    }
    
    class func convertToDictionary(text: String) -> Any? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: [])
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    class func json(object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    class func stringToDate(strDate:String, strFormate:String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = strFormate //Your date format
        dateFormatter.locale = Locale(identifier: "en")
        //dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00") //Current time zone
        //according to date format your date string
        if let date = dateFormatter.date(from: strDate) {
            //return
            //fatalError()
            return date
        }else{
            return Date()
        }
    }
    
    class func dateToString(date:Date, strFormate:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = strFormate //Your New Date format as per requirement change it own
        let newDate = dateFormatter.string(from: date) //pass Date here
        return newDate
    }
    
    class func getStatusBarHeight() -> CGFloat {
        var statusBarHeight: CGFloat = 0
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        return statusBarHeight
    }
    
    /*
     class func showLinearProgress()
     {
     let window = UIApplication.shared.keyWindow!
     
     progressView_linear.progress = 0.75
     progressView_linear.mode = .indeterminate
     progressView_linear.progressTintColor = #colorLiteral(red: 0.8980392157, green: 0.07843137255, blue: 0.1254901961, alpha: 1)
     progressView_linear.trackTintColor = .clear
     
     let progressViewHeight = CGFloat(2)
     let statusbarheight = AppHelper.getStatusBarHeight()
     progressView_linear.frame = CGRect(x: 0, y: statusbarheight, width: UIScreen.main.bounds.width, height: progressViewHeight)
     
     
     window.addSubview(progressView_linear)
     progressView_linear.startAnimating()
     }
     class func hideLinearProgress()
     {
     progressView_linear.stopAnimating()
     }
     */
    class func showLinearProgress()//showLoadingView()
    {
        if appDelegate.isLoadingViewVisible == false
        {
            
            let window = UIApplication.shared.keyWindow
            let loading = MBProgressHUD.showAdded(to: window!, animated: true)
            loading.mode = MBProgressHUDMode.indeterminate
            appDelegate.isLoadingViewVisible = true
        }
    }
    class func hideLinearProgress()//hideLoadingView()
    {
        let window = UIApplication.shared.keyWindow
        MBProgressHUD.hide(for: window!, animated: true)
        appDelegate.isLoadingViewVisible = false
    }
    
    class func datetoconvertSpecificFormate(dateOldFTR:String,dateNewFTR:String,strDate:String) -> String
    {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = dateOldFTR
        let showDate = inputFormatter.date(from: strDate)
        inputFormatter.dateFormat = dateNewFTR
        let resultString = inputFormatter.string(from: showDate!)
        return resultString
    }
    
    class func convertDateString(dateString : String!, fromFormat sourceFormat : String!, toFormat desFormat : String!) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = sourceFormat
        let date = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = desFormat
        return dateFormatter.string(from: date!)
    }
    
    class func getDate_SpecificFormate(date:Date,dateFormate:String) -> String
    {
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = dateFormate
        let endDate = dateformatter.string(from: date)
        return endDate
    }
    
    
    
    class func removeAllNsUserDefault()
    {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach{ key in
            if key == "fcm_devicetoken" || key == "is_remember_me" || key == "email_is_remember_me" || key == "pwd_is_remember_me" || key == "current_language" || key == "Theme_Current" 
            {
                
            }
            else
            {
                defaults.removeObject(forKey: key)
            }
        }
    }
    
    class func json_(object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    class func pathCurvedForView(givenView: UIImageView, curvedPercent:CGFloat) //->UIBezierPath
    {
        let arrowPath = UIBezierPath()
        arrowPath.move(to: CGPoint(x:0, y:0))
        arrowPath.addLine(to: CGPoint(x:givenView.bounds.size.width, y:0))
        arrowPath.addLine(to: CGPoint(x:givenView.bounds.size.width, y:givenView.bounds.size.height - (givenView.bounds.size.height*curvedPercent)))
        arrowPath.addQuadCurve(to: CGPoint(x:0, y:givenView.bounds.size.height - (givenView.bounds.size.height*curvedPercent)), controlPoint: CGPoint(x:givenView.bounds.size.width/2, y:givenView.bounds.size.height))
        arrowPath.addLine(to: CGPoint(x:0, y:0))
        arrowPath.close()
        
        let shapeLayer = CAShapeLayer(layer: givenView.layer)
        shapeLayer.path = arrowPath.cgPath
        shapeLayer.frame = givenView.bounds
        shapeLayer.masksToBounds = true
        givenView.layer.mask = shapeLayer
        
        //return arrowPath
    }
    class func pathCurvedForUIView(givenView: UIView, curvedPercent:CGFloat) //->UIBezierPath
    {
        let arrowPath = UIBezierPath()
        arrowPath.move(to: CGPoint(x:0, y:0))
        arrowPath.addLine(to: CGPoint(x:givenView.bounds.size.width, y:0))
        arrowPath.addLine(to: CGPoint(x:givenView.bounds.size.width, y:givenView.bounds.size.height - (givenView.bounds.size.height*curvedPercent)))
        arrowPath.addQuadCurve(to: CGPoint(x:0, y:givenView.bounds.size.height - (givenView.bounds.size.height*curvedPercent)), controlPoint: CGPoint(x:givenView.bounds.size.width/2, y:givenView.bounds.size.height))
        arrowPath.addLine(to: CGPoint(x:0, y:0))
        arrowPath.close()
        
        let shapeLayer = CAShapeLayer(layer: givenView.layer)
        shapeLayer.path = arrowPath.cgPath
        shapeLayer.frame = givenView.bounds
        shapeLayer.masksToBounds = true
        givenView.layer.mask = shapeLayer
        
        //return arrowPath
    }
    class func returnFileData(localUrl: URL) -> Data{
        if FileManager.default.fileExists(atPath: localUrl.path){
            if let cert = NSData(contentsOfFile: localUrl.path) {
                return cert as Data
            }
        }
        return Data()
    }
    
    //MARK:- Open Document Browser
    class func openDocuemtnBrowser(docUrl: String, nav: UINavigationController){
        if let url = URL(string: docUrl){
            //--
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            let vc = SFSafariViewController(url: url, configuration: config)
            nav.present(vc, animated: true)
        }
    }
    
    
    class func updateScreenNumber(userID: Int, screenNumber: Int, token: String) {
        let parameters: [String: Any] = [
            "id": userID,
            "screen_number": screenNumber
        ]
        
        let headers:HTTPHeaders = ["Accept":"application/json",
                                   "Authorization": token]
        
        
        AF.request(update_screen_number, method: .post, parameters: parameters, headers: headers).response { response in
            switch response.result {
            case .success(let response):
                print("Screen number updated successfully: \(screenNumber)")
                
            case .failure(let error):
                print("Error updating screen number: \(error.localizedDescription)")
            }
        }
    }

    class func syncUserToFirestore(userModel: UserModel) {
        guard let data = userModel.data else { return }
        let db = Firestore.firestore()
        
        let userId = "\(data.id)"
        let userData: [String: Any] = [
            "name": data.name,
            "selfie": data.user_image.first?.image ?? "",
            "id": data.id,
            "fcm_token": UserDefaults.standard.string(forKey: "fcm_devicetoken") ?? ""
        ]
        
        // merge: true ensures we don't delete existing conversation sub-collections
        db.collection("users").document(userId).setData(userData, merge: true)
    }

    class func getRoomId(id1: Int, id2: Int) -> String {
        let first = min(id1, id2)
        let second = max(id1, id2)
        return "room_\(first)_\(second)"
    }
}

class ImageLoader
{
    func imageLoad(imgView :UIImageView,url :String) {
        //print(url)
        imgView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "ic_appstore"))
    }
}
