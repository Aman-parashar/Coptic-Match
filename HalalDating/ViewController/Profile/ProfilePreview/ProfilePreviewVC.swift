//
//  ProfilePreviewVC.swift
//  HalalDating
//
//  Created by Maulik Vora on 27/11/21.
//

import UIKit
import AlamofireImage
import Alamofire

class ProfilePreviewVC: UIViewController {

    //MARK: - @IBOutlet
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var imgMain: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblAboutme_title: UILabel!
    @IBOutlet weak var collectionAboutMe: UICollectionView!
    @IBOutlet weak var imgSecond: UIImageView!
    @IBOutlet weak var lblMyLifeStyle_title: UILabel!
    @IBOutlet weak var collectionMylifeStyle: UICollectionView!
    @IBOutlet weak var lblMarriagegoals_title: UILabel!
    @IBOutlet weak var collectionMarriagegoals: UICollectionView!
    @IBOutlet weak var lblLanguage_title: UILabel!
    @IBOutlet weak var collectionLanguage: UICollectionView!
    @IBOutlet weak var heightCollLang: NSLayoutConstraint!
    @IBOutlet weak var collectionImage: UICollectionView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var heightCollectionImage: NSLayoutConstraint!
    @IBOutlet weak var aboutMeCollHeight: NSLayoutConstraint!
    @IBOutlet weak var myLifestyleCollHeight: NSLayoutConstraint!
    
    
    
    
    //MARK: - Veriable
    var userModel = UserModel()
    var arrAbout:[String] = []
    var arrLanguage:[String] = []
    var arrMylifeStyle:[String] = []
    var arrMarriageGoals:[String] = []
    var isFromProfile = true
    var strUserId = ""
    var arrOthePhotos:[User_Image] = []
    
//    var arrIcons: [String] = ["iconHeart", "iconKid", "iconSearch", "iconEducation", "iconHeight", "iconPlayer", "iconReligion", "iconStar"]
    var arrIcons: [String] = ["ic_maritial_status", "ic_kids", "ic_education", "ic_looking_for", "ic_height", "ic_religious", "ic_denomination", "ic_star"]

    
    //MARK: - func
    override func viewDidLoad() {
        super.viewDidLoad()
        setLanguageUI()
        setHeaderView()
        setCell()
        //--
        if isFromProfile {
            userModel = Login_LocalDB.getLoginUserModel()
            setProfile()
        } else {
            getUserDetailsAPI()
        }
        
        self.tabBarController?.tabBar.isHidden = true
    }
    func setLanguageUI() {
        
        if Helper.shared.strLanguage == "ar"  {
            headerView.semanticContentAttribute = .forceRightToLeft
            headerView.lblTitle.semanticContentAttribute = .forceRightToLeft
            lblTitle.semanticContentAttribute = .forceRightToLeft
            lblDetail.semanticContentAttribute = .forceRightToLeft
            lblAboutme_title.semanticContentAttribute = .forceRightToLeft
            lblLanguage_title.semanticContentAttribute = .forceRightToLeft
            lblMarriagegoals_title.semanticContentAttribute = .forceRightToLeft
            lblMyLifeStyle_title.semanticContentAttribute = .forceRightToLeft
            collectionAboutMe.semanticContentAttribute = .forceRightToLeft
            collectionLanguage.semanticContentAttribute = .forceRightToLeft
            collectionMarriagegoals.semanticContentAttribute = .forceRightToLeft
            collectionMylifeStyle.semanticContentAttribute = .forceRightToLeft
        }
        lblAboutme_title.text = "About me".localizableString(lang: Helper.shared.strLanguage)
        lblLanguage_title.text = "Language I speak".localizableString(lang: Helper.shared.strLanguage)
        lblMarriagegoals_title.text = "Dating goals".localizableString(lang: Helper.shared.strLanguage)
        lblMyLifeStyle_title.text = "My lifestyle".localizableString(lang: Helper.shared.strLanguage)
    }
    func setHeaderView(){
        headerView.delegate_HeaderView = self
        headerView.progressBar.isHidden = true
        headerView.imgAppIcon.isHidden = true
        headerView.lblTitle.isHidden = false
        headerView.lblTitle.text = "Profile preview".localizableString(lang: Helper.shared.strLanguage)
    }
    func setCell(){
        collectionAboutMe.register(UINib(nibName: TagListCell.className, bundle: nil), forCellWithReuseIdentifier: TagListCell.className)
        collectionLanguage.register(UINib(nibName: TagListCell.className, bundle: nil), forCellWithReuseIdentifier: TagListCell.className)
        collectionMylifeStyle.register(UINib(nibName: TagListCell.className, bundle: nil), forCellWithReuseIdentifier: TagListCell.className)
        collectionMarriagegoals.register(UINib(nibName: TagListCell.className, bundle: nil), forCellWithReuseIdentifier: TagListCell.className)
        collectionImage.register(UINib(nibName: ImageCell.className, bundle: nil), forCellWithReuseIdentifier: ImageCell.className)

        
        if let layout = collectionAboutMe.collectionViewLayout as? UICollectionViewFlowLayout {
            let rightAlignedLayout = LeftAlignedFlowLayout()
            rightAlignedLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize  // Enable automatic sizing
            rightAlignedLayout.minimumInteritemSpacing = 8  // Adjust for your desired spacing
            rightAlignedLayout.minimumLineSpacing = 8
            collectionAboutMe.setCollectionViewLayout(rightAlignedLayout, animated: false)
        }
        
        if let layout = collectionLanguage.collectionViewLayout as? UICollectionViewFlowLayout {
            let rightAlignedLayout = LeftAlignedFlowLayout()
            rightAlignedLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize  // Enable automatic sizing
            rightAlignedLayout.minimumInteritemSpacing = 8  // Adjust for your desired spacing
            rightAlignedLayout.minimumLineSpacing = 8
            collectionLanguage.setCollectionViewLayout(rightAlignedLayout, animated: false)
        }
        
        if let layout = collectionMylifeStyle.collectionViewLayout as? UICollectionViewFlowLayout {
            let rightAlignedLayout = LeftAlignedFlowLayout()
            rightAlignedLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize  // Enable automatic sizing
            rightAlignedLayout.minimumInteritemSpacing = 8  // Adjust for your desired spacing
            rightAlignedLayout.minimumLineSpacing = 8
            collectionMylifeStyle.setCollectionViewLayout(rightAlignedLayout, animated: false)
        }
        
        if let layout = collectionMarriagegoals.collectionViewLayout as? UICollectionViewFlowLayout {
            let rightAlignedLayout = LeftAlignedFlowLayout()
            rightAlignedLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize  // Enable automatic sizing
            rightAlignedLayout.minimumInteritemSpacing = 8  // Adjust for your desired spacing
            rightAlignedLayout.minimumLineSpacing = 8
            collectionMarriagegoals.setCollectionViewLayout(rightAlignedLayout, animated: false)
        }

        
    }
    
    func setProfile() {
        
        //
        arrOthePhotos.removeAll()
        
        //--
        var index = 1
        userModel.data?.user_image.forEach({ user_Image in
            let imgName = "\(kImageBaseURL)\(user_Image.image)".replacingOccurrences(of: " ", with: "%20")
            if index == 1{
                ImageLoader().imageLoad(imgView: imgMain, url: imgName)
                
            }else if index == 2{
                ImageLoader().imageLoad(imgView: imgSecond, url: imgName)
                
            } else {
                arrOthePhotos.append((userModel.data?.user_image[index-1])!)
            }
            index = index + 1
        })
        
        pageController.numberOfPages = arrOthePhotos.count
        collectionImage.reloadData()
        
        
        //
        if let dob_ = userModel.data?.dob{
            let dob_ = AppHelper.stringToDate(strDate: dob_, strFormate: "yyyy-MM-dd")
            
            lblTitle.text = "\(userModel.data?.name ?? ""), \(Date().years(from: dob_))"
        }
        lblDetail.text = "\(userModel.data?.city ?? ""), \(userModel.data?.country ?? "")"
        
        
        //About
        arrAbout.append("\(userModel.data?.relation_status ?? "")")
        arrAbout.append("\(userModel.data?.kids ?? "")")
        arrAbout.append("\(userModel.data?.education ?? "")")
        arrAbout.append("\(userModel.data?.looking_for ?? "")")
        arrAbout.append("\((userModel.data?.height ?? "").replacingOccurrences(of: "\"", with: "''"))")
        arrAbout.append("\(userModel.data?.religious ?? "")")
        let deno = "\(((userModel.data?.denomination_id ?? "").replacingOccurrences(of: "[", with: "")).replacingOccurrences(of: "]", with: ""))"
        arrAbout.append("\(deno)")
        //arrAbout.append("\(userModel.data?.your_zodiac ?? "")") -- Removed Zodiac
        collectionAboutMe.reloadData()
        
        //Language
        let lang = "\(((userModel.data?.language_id ?? "").replacingOccurrences(of: "[", with: "")).replacingOccurrences(of: "]", with: ""))"
        arrLanguage = lang.components(separatedBy: ", ")
        collectionLanguage.reloadData()
        
        //Life
        arrMylifeStyle.append("\(userModel.data?.pray ?? "")")
        arrMylifeStyle.append("\(userModel.data?.go_church ?? "")")
        arrMylifeStyle.append("\(userModel.data?.smoke ?? "")")
        arrMylifeStyle.append("\(userModel.data?.work_out ?? "")")
        arrMylifeStyle.append("\(userModel.data?.alcohol ?? "")")
        //arrMylifeStyle.append("\(userModel.data?.eating ?? "")")
         collectionMylifeStyle.reloadData()
        
        //Marrige
        arrMarriageGoals.append("\(userModel.data?.married_year ?? "")")
        collectionMarriagegoals.reloadData()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        DispatchQueue.main.async {
            
            self.aboutMeCollHeight.constant = self.collectionAboutMe.collectionViewLayout.collectionViewContentSize.height
            self.myLifestyleCollHeight.constant = self.collectionMylifeStyle.collectionViewLayout.collectionViewContentSize.height
            self.heightCollLang.constant = self.collectionLanguage.collectionViewLayout.collectionViewContentSize.height
            self.heightCollectionImage.constant = self.collectionImage.collectionViewLayout.collectionViewContentSize.height
            
            self.view.layoutIfNeeded()
        }
        
    }
    
    //MARK: - Webservice
    
    func getUserDetailsAPI() {
        
        if NetworkReachabilityManager()!.isReachable == false
        {
            let alert = UIAlertController(title: internetConnectedTitle.localizableString(lang: Helper.shared.strLanguage), message: internetConnected.localizableString(lang: Helper.shared.strLanguage), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK".localizableString(lang: Helper.shared.strLanguage), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        let dicParams:[String:AnyObject] = ["user_id":strUserId as AnyObject]
        AppHelper.showLinearProgress()
        
        let userModel = Login_LocalDB.getLoginUserModel()
        
        HttpWrapper.requestMultipartFormDataWithImageAndFile(detail_by_user_id, dicsParams: dicParams, headers: ["Authorization":userModel.data?.api_token ?? ""], completion: { (response) in
            self.view.isUserInteractionEnabled = true
            AppHelper.hideLinearProgress()
            let dicsResponseFinal = response.replaceNulls(with: "")
            print(dicsResponseFinal as Any)
            
            let userListModel_ = UserModel(JSON: dicsResponseFinal as! [String : Any])!
            if userListModel_.code == 200{
                //--
                self.userModel = userListModel_
                self.setProfile()
                
            }else if userListModel_.code == 401{
                AppHelper.Logout(navigationController: self.navigationController!)
            }else{
                self.view.makeToast(dicsResponseFinal?.object(forKey: "message") as? String ?? "")
            }
        }) { (error) in
            print(error)
            self.view.isUserInteractionEnabled = true
            AppHelper.hideLinearProgress()
        }
    }
    

}

extension ProfilePreviewVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if collectionView == collectionImage{
//            return CGSize(width: UIScreen.main.bounds.width-30, height: 600)
//        } else if collectionView == collectionAboutMe{
//            let width = collectionView.frame.size.width
//            //let height = collectionView.frame.size.height
//            return CGSize(width: (width/2)-5, height: 52)
//        } else if collectionView == collectionLanguage{
//            let width = collectionView.frame.size.width
//            //let height = collectionView.frame.size.height
//            return CGSize(width: (width/2)-5, height: 50)
//        } else if collectionView == collectionMylifeStyle{
//            let width = collectionView.frame.size.width
//            //let height = collectionView.frame.size.height
//            return CGSize(width: (width/2)-5, height: 50)
//        }else{
//            let width = collectionView.frame.size.width
//            //let height = collectionView.frame.size.height
//            return CGSize(width: (width/2)-5, height: 52)
//        }
//
        
        if collectionView == collectionImage {
            return CGSize(width: collectionView.frame.width, height: 600)
            
        } else {
            
            let text = arrAbout[indexPath.row]
            let width = estimateFrameForText(text).width + 20  // Add padding
            return CGSize(width: width, height: 55)
        }

        

        //        if #available(iOS 11.0, *) {
        //            let window = UIApplication.shared.keyWindow
        //            let topPadding = window?.safeAreaInsets.top
        //            let bottomPadding = window?.safeAreaInsets.bottom
        //
        //
        //            _ = UIScreen.main.bounds.size.height - topPadding! - bottomPadding! - 60//100.0
        //            return CGSize(width: width, height: collectionView.frame.size.height)
        //
        //        }else{
        //            let height = UIScreen.main.bounds.size.height - 122
        //
        //        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionImage{
            
            if arrOthePhotos.count == 0 {
                heightCollectionImage.constant = 1
            } else {
                heightCollectionImage.constant = 600
            }
            return arrOthePhotos.count
        } else if collectionView == collectionAboutMe{
            return arrAbout.count
        }else if collectionView == collectionLanguage{
            return arrLanguage.count
        }else if collectionView == collectionMylifeStyle{
            return arrMylifeStyle.count
        }else{
            return arrMarriageGoals.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collectionImage{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.className, for: indexPath) as! ImageCell
            
            var imgName = arrOthePhotos[indexPath.row].image
            imgName = "\(kImageBaseURL)\(imgName)".replacingOccurrences(of: " ", with: "%20")
            ImageLoader().imageLoad(imgView: cell.imgMain, url: imgName)
            
            return cell
        } else if collectionView == collectionAboutMe{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagListCell.className, for: indexPath) as! TagListCell
            cell.lblTitl.numberOfLines = 2
            if indexPath.row == 0{
                if arrAbout[indexPath.row] == "Never married" || arrAbout[indexPath.row] == "لم يسبق الزواج" {
                    cell.lblTitl.text = "Never married".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "Single" || arrAbout[indexPath.row] == "أعزب" {
                    cell.lblTitl.text = "Single".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "Separated" || arrAbout[indexPath.row] == "منفصل" {
                    cell.lblTitl.text = "Separated".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "Divorced" || arrAbout[indexPath.row] == "مطلق" {
                    cell.lblTitl.text = "Divorced".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "Widowed" || arrAbout[indexPath.row] == "ارمل" {
                    cell.lblTitl.text = "Widowed".localizableString(lang: Helper.shared.strLanguage)
                }
            }else if indexPath.row == 1{
                if arrAbout[indexPath.row] == "Have kids" || arrAbout[indexPath.row] == "نعم" {
                    cell.lblTitl.text = "Have kids".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "Don't have kids" || arrAbout[indexPath.row] == "ليس لديهم اطفال" {
                    cell.lblTitl.text = "Don't have kids".localizableString(lang: Helper.shared.strLanguage)
                }
            }else if indexPath.row == 2{
                if arrAbout[indexPath.row] == "High School" || arrAbout[indexPath.row] == "مدرسة ثانوية" {
                    cell.lblTitl.text = "High School".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "Bachelors" || arrAbout[indexPath.row] == "غير حاصل على شهادة" {
                    cell.lblTitl.text = "Bachelors".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "Masters" || arrAbout[indexPath.row] == "درجة جامعية" {
                    cell.lblTitl.text = "Masters".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "Post graduate" || arrAbout[indexPath.row] == "دراسات عليا" {
                    cell.lblTitl.text = "Post graduate".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "Prefer not to say" || arrAbout[indexPath.row] == "افضل عدم القول" {
                    cell.lblTitl.text = "Prefer not to say".localizableString(lang: Helper.shared.strLanguage)
                }
            }else if indexPath.row == 3{
                if arrAbout[indexPath.row] == "Serious Relationship" {
                    cell.lblTitl.text = "Serious Relationship".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "Marriage" || arrAbout[indexPath.row] == "الزواج" {
                    cell.lblTitl.text = "Marriage".localizableString(lang: Helper.shared.strLanguage)
                } 
            }else if indexPath.row == 4{
                if arrAbout[indexPath.row] == "4'0'' (122 cm)" || arrAbout[indexPath.row] == "0'4 (122 سم)" {
                    cell.lblTitl.text = "4'0'' (122 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "4'1'' (125 cm)" || arrAbout[indexPath.row] == "1'4 (125 سم)" {
                    cell.lblTitl.text = "4'1'' (125 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "4'2'' (127 cm)" || arrAbout[indexPath.row] == "2'4 (127 سم)" {
                    cell.lblTitl.text = "4'2'' (127 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "4'3'' (130 cm)" || arrAbout[indexPath.row] == "3'4 (130 سم)" {
                    cell.lblTitl.text = "4'3'' (130 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "4'4'' (132 cm)" || arrAbout[indexPath.row] == "4'4 (132 سم)" {
                    cell.lblTitl.text = "4'4'' (132 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "4'5'' (135 cm)" || arrAbout[indexPath.row] == "5'4 (135 سم)" {
                    cell.lblTitl.text = "4'5'' (135 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "4'6'' (137 cm)" || arrAbout[indexPath.row] == "6'4 (137 سم)" {
                    cell.lblTitl.text = "4'6'' (137 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "4'7'' (140 cm)" || arrAbout[indexPath.row] == "7'4 (140 سم)" {
                    cell.lblTitl.text = "4'7'' (140 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "4'8'' (142 cm)" || arrAbout[indexPath.row] == "8'4 (142 سم)" {
                    cell.lblTitl.text = "4'8'' (142 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "4'9'' (145 cm)" || arrAbout[indexPath.row] == "9'4 (145 سم)" {
                    cell.lblTitl.text = "4'9'' (145 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "4'10'' (147 cm)" || arrAbout[indexPath.row] == "10'4 (147 سم)" {
                    cell.lblTitl.text = "4'10'' (147 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "4'11'' (150 cm)" || arrAbout[indexPath.row] == "11'4 (150 سم)" {
                    cell.lblTitl.text = "4'11'' (150 cm)".localizableString(lang: Helper.shared.strLanguage)
                }  else if arrAbout[indexPath.row] == "4'12'' (152 cm)" || arrAbout[indexPath.row] == "12'4 (152 سم)" {
                    cell.lblTitl.text = "4'12'' (152 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "5'0'' (153 cm)" || arrAbout[indexPath.row] == "0'5 (153 سم)" {
                    cell.lblTitl.text = "5'0'' (153 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "5'1'' (155 cm)" || arrAbout[indexPath.row] == "1'5 (155 سم)" {
                    cell.lblTitl.text = "5'1'' (155 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "5'2'' (157 cm)" || arrAbout[indexPath.row] == "2'5 (157 سم)" {
                    cell.lblTitl.text = "5'2'' (157 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "5'3'' (160 cm)" || arrAbout[indexPath.row] == "3'5 (160 سم)" {
                    cell.lblTitl.text = "5'3'' (160 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "5'4'' (162 cm)" || arrAbout[indexPath.row] == "4'5 (162 سم)" {
                    cell.lblTitl.text = "5'4'' (162 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "5'5'' (165 cm)" || arrAbout[indexPath.row] == "5'5 (165 سم)" {
                    cell.lblTitl.text = "5'5'' (165 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "5'6'' (167 cm)" || arrAbout[indexPath.row] == "6'5 (167 سم)" {
                    cell.lblTitl.text = "5'6'' (167 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "5'7'' (170 cm)" || arrAbout[indexPath.row] == "7'5 (170 سم)" {
                    cell.lblTitl.text = "5'7'' (170 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "5'8'' (172 cm)" || arrAbout[indexPath.row] == "8'5 (172 سم)" {
                    cell.lblTitl.text = "5'8'' (172 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "5'9'' (175 cm)" || arrAbout[indexPath.row] == "9'5 (175 سم)" {
                    cell.lblTitl.text = "5'9'' (175 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "5'10'' (177 cm)" || arrAbout[indexPath.row] == "10'5 (177 سم)" {
                    cell.lblTitl.text = "5'10'' (177 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "5'11'' (180 cm)" || arrAbout[indexPath.row] == "11'5 (180 سم)" {
                    cell.lblTitl.text = "5'11'' (180 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "5'12'' (182 cm)" || arrAbout[indexPath.row] == "12'5 (182 سم)" {
                    cell.lblTitl.text = "5'12'' (182 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "6'0'' (183 cm)" || arrAbout[indexPath.row] == "0'6 (183 سم)" {
                    cell.lblTitl.text = "6'0'' (183 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "6'1'' (186 cm)" || arrAbout[indexPath.row] == "1'6 (186 سم)" {
                    cell.lblTitl.text = "6'1'' (186 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "6'2'' (188 cm)" || arrAbout[indexPath.row] == "2'6 (188 سم)" {
                    cell.lblTitl.text = "6'2'' (188 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "6'3'' (190 cm)" || arrAbout[indexPath.row] == "3'6 (190 سم)" {
                    cell.lblTitl.text = "6'3'' (190 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "6'4'' (193 cm)" || arrAbout[indexPath.row] == "4'6 (193 سم)" {
                    cell.lblTitl.text = "6'4'' (193 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "6'5'' (195 cm)" || arrAbout[indexPath.row] == "5'6 (195 سم)" {
                    cell.lblTitl.text = "6'5'' (195 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "6'6'' (198 cm)" || arrAbout[indexPath.row] == "6'6 (198 سم)" {
                    cell.lblTitl.text = "6'6'' (198 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "6'7'' (200 cm)" || arrAbout[indexPath.row] == "7'6 (200 سم)" {
                    cell.lblTitl.text = "6'7'' (200 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "6'8'' (202 cm)" || arrAbout[indexPath.row] == "8'6 (202 سم)" {
                    cell.lblTitl.text = "6'8'' (202 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "6'9'' (205 cm)" || arrAbout[indexPath.row] == "9'6 (205 سم)" {
                    cell.lblTitl.text = "6'9'' (205 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "6'10'' (207 cm)" || arrAbout[indexPath.row] == "10'6 (207 سم)" {
                    cell.lblTitl.text = "6'10'' (207 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "6'11'' (210 cm)" || arrAbout[indexPath.row] == "11'6 بوصة (210 سم)" {
                    cell.lblTitl.text = "6'11'' (210 cm)".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "6'12'' (212 cm)" || arrAbout[indexPath.row] == "12'6 (212 سم)" {
                    cell.lblTitl.text = "6'12'' (212 cm)".localizableString(lang: Helper.shared.strLanguage)
                }
            }else if indexPath.row == 5{
                if arrAbout[indexPath.row] == "Not Practising" || arrAbout[indexPath.row] == "لا امارس" {
                    cell.lblTitl.text = "Not Practising".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "Moderately practising" || arrAbout[indexPath.row] == "متدين" {
                    cell.lblTitl.text = "Moderately practising".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "Practising" || arrAbout[indexPath.row] == "امارس" {
                    cell.lblTitl.text = "Practising".localizableString(lang: Helper.shared.strLanguage)
                } else if arrAbout[indexPath.row] == "Very practising" || arrAbout[indexPath.row] == "اصلى احيانا" {
                    cell.lblTitl.text = "Very practising".localizableString(lang: Helper.shared.strLanguage)
                }
            } else if indexPath.row == 6{
                
                cell.lblTitl.text = arrAbout[indexPath.row]
            } else if indexPath.row == 7 {
                
                if arrAbout[indexPath.row] == "Leo" {
                    cell.lblTitl.text = "Leo"
                } else if arrAbout[indexPath.row] == "Virgo" {
                    cell.lblTitl.text = "Virgo"
                } else if arrAbout[indexPath.row] == "Libra" {
                    cell.lblTitl.text = "Libra"
                } else if arrAbout[indexPath.row] == "Scorpio" {
                    cell.lblTitl.text = "Scorpio"
                } else if arrAbout[indexPath.row] == "Sagittarius" {
                    cell.lblTitl.text = "Sagittarius"
                } else if arrAbout[indexPath.row] == "Capricorn" {
                    cell.lblTitl.text = "Capricorn"
                } else if arrAbout[indexPath.row] == "Aquarius" {
                    cell.lblTitl.text = "Aquarius"
                } else if arrAbout[indexPath.row] == "Pisces" {
                    cell.lblTitl.text = "Pisces"
                }
            }
            //cell.lblTitl.text = arrAbout[indexPath.row].localizableString(lang: Helper.shared.strLanguage)
            
            cell.ic_cat.image = UIImage(named: arrIcons[indexPath.row])
//            if indexPath.row == 0{
//                cell.ic_cat.image = UIImage(named: "ic_maritial_status")
//            }else if indexPath.row == 1{
//                cell.ic_cat.image = UIImage(named: "ic_kids")
//            }else if indexPath.row == 2{
//                cell.ic_cat.image = UIImage(named: "ic_education")
//            }else if indexPath.row == 3{
//                cell.ic_cat.image = UIImage(named: "ic_looking_for")
//            }else if indexPath.row == 4{
//                cell.ic_cat.image = UIImage(named: "ic_height")
//            }else if indexPath.row == 5{
//                cell.ic_cat.image = UIImage(named: "ic_religious")
//            }else if indexPath.row == 6{
//                cell.ic_cat.image = UIImage(named: "ic_denomination")
//            }else if indexPath.row == 7{
//                cell.ic_cat.image = UIImage(named: "ic_star")
//            }
            
            return cell
        } else if collectionView == collectionLanguage{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagListCell.className, for: indexPath) as! TagListCell
            
            
            if arrLanguage[indexPath.row] == "Korean" || arrLanguage[indexPath.row] == "الكورية" {
                cell.lblTitl.text = "\("Korean".localizableString(lang: Helper.shared.strLanguage))"
            } else if arrLanguage[indexPath.row] == "Russian" || arrLanguage[indexPath.row] == "الروسية"{
                cell.lblTitl.text = "\("Russian".localizableString(lang: Helper.shared.strLanguage))"
            } else if arrLanguage[indexPath.row] == "Japanese" || arrLanguage[indexPath.row] == "ليابانية" {
                cell.lblTitl.text = "\("Japanese".localizableString(lang: Helper.shared.strLanguage))"
            } else if arrLanguage[indexPath.row] == "Irish" || arrLanguage[indexPath.row] == "إيرلندي" {
                cell.lblTitl.text = "\("Irish".localizableString(lang: Helper.shared.strLanguage))"
            } else if arrLanguage[indexPath.row] == "French" || arrLanguage[indexPath.row] == "فرنسي" {
                cell.lblTitl.text = "\("French".localizableString(lang: Helper.shared.strLanguage))"
            }  else if arrLanguage[indexPath.row] == "German" || arrLanguage[indexPath.row] == "ألمانية" {
                cell.lblTitl.text = "\("German".localizableString(lang: Helper.shared.strLanguage))"
            }  else if arrLanguage[indexPath.row] == "English" || arrLanguage[indexPath.row] == "إنجليزي" {
                cell.lblTitl.text = "\("English".localizableString(lang: Helper.shared.strLanguage))"
            }  else if arrLanguage[indexPath.row] == "Arabic" || arrLanguage[indexPath.row] == "عربي" {
                cell.lblTitl.text = "\("Arabic".localizableString(lang: Helper.shared.strLanguage))"
            } else if arrLanguage[indexPath.row] == "Italian" || arrLanguage[indexPath.row] == "إيطالي" {
                cell.lblTitl.text = "\("Italian".localizableString(lang: Helper.shared.strLanguage))"
            } else if arrLanguage[indexPath.row] == "Somali" || arrLanguage[indexPath.row] == "صومالي" {
                cell.lblTitl.text = "\("Somali".localizableString(lang: Helper.shared.strLanguage))"
            } else if arrLanguage[indexPath.row] == "Serbian" || arrLanguage[indexPath.row] == "الصربية" {
                cell.lblTitl.text = "\("Serbian".localizableString(lang: Helper.shared.strLanguage))"
            } else if arrLanguage[indexPath.row] == "Chinese" || arrLanguage[indexPath.row] == "صينى" {
                cell.lblTitl.text = "\("Chinese".localizableString(lang: Helper.shared.strLanguage))"
            } else if arrLanguage[indexPath.row] == "Spanish" || arrLanguage[indexPath.row] == "لاتيني" {
                cell.lblTitl.text = "\("Spanish".localizableString(lang: Helper.shared.strLanguage))"
            } else if arrLanguage[indexPath.row] == "Swedish" || arrLanguage[indexPath.row] == "السويدية" {
                cell.lblTitl.text = "\("Swedish".localizableString(lang: Helper.shared.strLanguage))"
            } else if arrLanguage[indexPath.row] == "Amharic" || arrLanguage[indexPath.row] == "الأمهرية" {
                cell.lblTitl.text = "\("Amharic".localizableString(lang: Helper.shared.strLanguage))"
            } else if arrLanguage[indexPath.row] == "Portuguese" || arrLanguage[indexPath.row] == "البرتغالية" {
                cell.lblTitl.text = "\("Portuguese".localizableString(lang: Helper.shared.strLanguage))"
            } else if arrLanguage[indexPath.row] == "Igbo" || arrLanguage[indexPath.row] == "الإيغبو" {
                cell.lblTitl.text = "\("Igbo".localizableString(lang: Helper.shared.strLanguage))"
            } else if arrLanguage[indexPath.row] == "Kannada" || arrLanguage[indexPath.row] == "الكانادا" {
                cell.lblTitl.text = "\("Kannada".localizableString(lang: Helper.shared.strLanguage))"
            } else if arrLanguage[indexPath.row] == "Telugu" || arrLanguage[indexPath.row] == "التيلجو" {
                cell.lblTitl.text = "\("Telugu".localizableString(lang: Helper.shared.strLanguage))"
            } else if arrLanguage[indexPath.row] == "Gujarati" || arrLanguage[indexPath.row] == "الغوجاراتية" {
                cell.lblTitl.text = "\("Gujarati".localizableString(lang: Helper.shared.strLanguage))"
            } else if arrLanguage[indexPath.row] == "Thai" || arrLanguage[indexPath.row] == "التايلاندية" {
                cell.lblTitl.text = "\("Thai".localizableString(lang: Helper.shared.strLanguage))"
            } else if arrLanguage[indexPath.row] == "Khmer" || arrLanguage[indexPath.row] == "الخمير" {
                cell.lblTitl.text = "\("Khmer".localizableString(lang: Helper.shared.strLanguage))"
            } else if arrLanguage[indexPath.row] == "Slovenian" || arrLanguage[indexPath.row] == "السلوفينية" {
                cell.lblTitl.text = "\("Slovenian".localizableString(lang: Helper.shared.strLanguage))"
            } else if arrLanguage[indexPath.row] == "Kazakh" || arrLanguage[indexPath.row] == "الكازاخستانية" {
                cell.lblTitl.text = "\("Kazakh".localizableString(lang: Helper.shared.strLanguage))"
            } else if arrLanguage[indexPath.row] == "Ukrainian" || arrLanguage[indexPath.row] == "الأوكرانية" {
                cell.lblTitl.text = "\("Ukrainian".localizableString(lang: Helper.shared.strLanguage))"
            } else if arrLanguage[indexPath.row] == "Kurdish" || arrLanguage[indexPath.row] == "كردي" {
                cell.lblTitl.text = "\("Kurdish".localizableString(lang: Helper.shared.strLanguage))"
            }
            cell.ic_cat.image = UIImage(named: "ic_language")

            return cell
        } else if collectionView == collectionMylifeStyle{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagListCell.className, for: indexPath) as! TagListCell
            
            if indexPath.row == 0 {
                
                if arrMylifeStyle[indexPath.row] == "Never pray" || arrMylifeStyle[indexPath.row] == "لا اصلى" {
                    cell.lblTitl.text = "Never pray".localizableString(lang: Helper.shared.strLanguage)
                } else if arrMylifeStyle[indexPath.row] == "Sometimes pray" || arrMylifeStyle[indexPath.row] == "بعض الاحيان اصلى" {
                    cell.lblTitl.text = "Sometimes pray".localizableString(lang: Helper.shared.strLanguage)
                } else if arrMylifeStyle[indexPath.row] == "Usually pray" || arrMylifeStyle[indexPath.row] == "عادة اصلى" {
                    cell.lblTitl.text = "Usually pray".localizableString(lang: Helper.shared.strLanguage)
                } else if arrMylifeStyle[indexPath.row] == "Always pray" || arrMylifeStyle[indexPath.row] == "دائما اصلى" {
                    cell.lblTitl.text = "Always pray".localizableString(lang: Helper.shared.strLanguage)
                }
                
            } else if indexPath.row == 1{
                
                if arrMylifeStyle[indexPath.row] == "Every week" || arrMylifeStyle[indexPath.row] == "نعم" {
                    cell.lblTitl.text = "Every week"
                } else if arrMylifeStyle[indexPath.row] == "Every other week" || arrMylifeStyle[indexPath.row] == "رقم" {
                    cell.lblTitl.text = "Every other week"
                } else if arrMylifeStyle[indexPath.row] == "Every month" || arrMylifeStyle[indexPath.row] == "رقم" {
                    cell.lblTitl.text = "Every month"
                } else if arrMylifeStyle[indexPath.row] == "Once in a while" || arrMylifeStyle[indexPath.row] == "رقم" {
                    cell.lblTitl.text = "Once in a while"
                } else {
                    cell.lblTitl.text = arrMylifeStyle[indexPath.row].localizableString(lang: Helper.shared.strLanguage)
                }
                
            }else if indexPath.row == 2{
                if arrMylifeStyle[indexPath.row] == "Yes" || arrMylifeStyle[indexPath.row] == "نعم" {
                    cell.lblTitl.text = "Yes".localizableString(lang: Helper.shared.strLanguage)
                } else if arrMylifeStyle[indexPath.row] == "No" || arrMylifeStyle[indexPath.row] == "رقم" {
                    cell.lblTitl.text = "No".localizableString(lang: Helper.shared.strLanguage)
                } else if arrMylifeStyle[indexPath.row] == "Sometimes" || arrMylifeStyle[indexPath.row] == "بعض الاحيان" {
                    cell.lblTitl.text = "Sometimes".localizableString(lang: Helper.shared.strLanguage)
                }
            }else if indexPath.row == 3{
                
                
                if arrMylifeStyle[indexPath.row] == "Active" || arrMylifeStyle[indexPath.row] == "نعم" {
                    cell.lblTitl.text = "Active".localizableString(lang: Helper.shared.strLanguage)
                } else if arrMylifeStyle[indexPath.row] == "Sometimes" || arrMylifeStyle[indexPath.row] == "بعض الاحيان" {
                    cell.lblTitl.text = "Sometimes".localizableString(lang: Helper.shared.strLanguage)
                } else if arrMylifeStyle[indexPath.row] == "Almost never" || arrMylifeStyle[indexPath.row] == "على الاغلب ل" {
                    cell.lblTitl.text = "Almost never".localizableString(lang: Helper.shared.strLanguage)
                }
                
                
//                if arrMylifeStyle[indexPath.row] == "Yes" || arrMylifeStyle[indexPath.row] == "نعم" {
//                    cell.lblTitl.text = "Yes".localizableString(lang: Helper.shared.strLanguage)
//                } else if arrMylifeStyle[indexPath.row] == "No" || arrMylifeStyle[indexPath.row] == "رقم" {
//                    cell.lblTitl.text = "No".localizableString(lang: Helper.shared.strLanguage)
//                }
            }else if indexPath.row == 4{
                if arrMylifeStyle[indexPath.row] == "Yes" || arrMylifeStyle[indexPath.row] == "نعم" {
                    cell.lblTitl.text = "Yes".localizableString(lang: Helper.shared.strLanguage)
                } else if arrMylifeStyle[indexPath.row] == "No" || arrMylifeStyle[indexPath.row] == "رقم" {
                    cell.lblTitl.text = "No".localizableString(lang: Helper.shared.strLanguage)
                } else if arrMylifeStyle[indexPath.row] == "Sometimes" || arrMylifeStyle[indexPath.row] == "بعض الاحيان" {
                    cell.lblTitl.text = "Sometimes".localizableString(lang: Helper.shared.strLanguage)
                }
            }
            
            //cell.lblTitl.text = arrMylifeStyle[indexPath.row].localizableString(lang: Helper.shared.strLanguage)
            if indexPath.row == 0{
                cell.ic_cat.image = UIImage(named: "ic_pray")
            }else if indexPath.row == 1{
                cell.ic_cat.image = UIImage(named: "ic_church")
            }else if indexPath.row == 2{
                cell.ic_cat.image = UIImage(named: "ic_smoke")
            }else if indexPath.row == 3{
                cell.ic_cat.image = UIImage(named: "ic_workout")
                //cell.ic_cat.image = UIImage(named: "ic_eat")
            }else if indexPath.row == 4{
                cell.ic_cat.image = UIImage(named: "ic_drink")
            }
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagListCell.className, for: indexPath) as! TagListCell
            cell.lblTitl.numberOfLines = 2
            if arrMarriageGoals[indexPath.row] == "Marriage within a year" || arrMarriageGoals[indexPath.row] == "الزواج خلال عام" {
                cell.lblTitl.text = "Marriage within a year".localizableString(lang: Helper.shared.strLanguage)
            } else if arrMarriageGoals[indexPath.row] == "Marriage in 1-2 Years" || arrMarriageGoals[indexPath.row] == "الزواج خلال 1-2 اعوام" {
                cell.lblTitl.text = "Marriage in 1-2 Years".localizableString(lang: Helper.shared.strLanguage)
            } else if arrMarriageGoals[indexPath.row] == "Marriage in 3-4 Years" || arrMarriageGoals[indexPath.row] == "الزواج خلال 3-4 اعوام" {
                cell.lblTitl.text = "Marriage in 3-4 Years".localizableString(lang: Helper.shared.strLanguage)
            } else if arrMarriageGoals[indexPath.row] == "Marriage in 4+ Years" || arrMarriageGoals[indexPath.row] == "الزواج خلال اكثر من 4 اعوام" {
                cell.lblTitl.text = "Marriage in 4+ Years".localizableString(lang: Helper.shared.strLanguage)
            } else if arrMarriageGoals[indexPath.row] == "Don’t know yet" || arrMarriageGoals[indexPath.row] == "لا أعرف بعد" {
                cell.lblTitl.text = "Don’t know yet".localizableString(lang: Helper.shared.strLanguage)
            } else if arrMarriageGoals[indexPath.row] == "Serious Relationship" || arrMarriageGoals[indexPath.row] == "علاقة جدية" {
                cell.lblTitl.text = "Serious Relationship".localizableString(lang: Helper.shared.strLanguage)
            } else {
                cell.lblTitl.text = arrMarriageGoals[indexPath.row].localizableString(lang: Helper.shared.strLanguage)
            }
            //cell.lblTitl.text = arrMarriageGoals[indexPath.row].localizableString(lang: Helper.shared.strLanguage)
            cell.ic_cat.image = UIImage(named: "ic_marriage_goal")
            
            
            return cell
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionAboutMe{
            
        }else if collectionView == collectionMylifeStyle{
            
        }else{
            
        }
    }
    
    func estimateFrameForText(_ text: String) -> CGRect {
        let size = CGSize(width: 2000, height: 55)
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]
        return NSString(string: text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
    }

}

extension ProfilePreviewVC: HeaderView_Protocol{
    func btnBack() {
        self.navigationController?.popViewController(animated: true)
    }
}
extension ProfilePreviewVC: UIScrollViewDelegate
{
    //--ScrollView Delegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == collectionImage{
            let pageWidth = collectionImage.frame.size.width
            let currentPage = Float(collectionImage.contentOffset.x / pageWidth)
            
            if 0.0 != fmodf(currentPage, 1.0) {
                pageController.currentPage = Int(currentPage + 1)
            } else {
                pageController.currentPage = Int(currentPage)
            }
            
        }
    }
    
}
