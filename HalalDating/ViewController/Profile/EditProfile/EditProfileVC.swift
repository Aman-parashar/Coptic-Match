//
//  EditProfileVC.swift
//  HalalDating
//
//  Created by Maulik Vora on 28/11/21.
//

import UIKit
import Alamofire
import FaceSDK

protocol UpdateProfileInfo {
    func updateProfileInfo(userModel_: UserModel)
}

class EditProfileVC: UIViewController {
    //MARK: - @IBOutlet
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var lblPhotoTitle: UILabel!
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
    
    @IBOutlet weak var lblBasicInfo_title: UILabel!
    @IBOutlet weak var lblTitle1: UILabel!
    @IBOutlet weak var lblDetail1: UILabel!
    @IBOutlet weak var lblTitle2: UILabel!
    @IBOutlet weak var lblDetail2: UILabel!
    @IBOutlet weak var lblTitle3: UILabel!
    @IBOutlet weak var lblDetail3: UILabel!
    @IBOutlet weak var lblTitle4: UILabel!
    @IBOutlet weak var lblDetail4: UILabel!
    @IBOutlet weak var lblTitle5: UILabel!
    @IBOutlet weak var lblDetail5: UILabel!
    
    @IBOutlet weak var lblIslamiclifestyle_title: UILabel!
    @IBOutlet weak var lblTitle6: UILabel!
    @IBOutlet weak var lblDetail6: UILabel!
    @IBOutlet weak var lblTitle7: UILabel!
    @IBOutlet weak var lblDetail7: UILabel!
    @IBOutlet weak var lblTitle8: UILabel!
    @IBOutlet weak var lblDetail8: UILabel!
    @IBOutlet weak var lblTitle9: UILabel!
    @IBOutlet weak var lblDetail9: UILabel!
    @IBOutlet weak var lblTitle10: UILabel!
    @IBOutlet weak var lblDetail10: UILabel!
    
    @IBOutlet weak var lblMoreAboutMe_title: UILabel!
    @IBOutlet weak var lblTitle11: UILabel!
    @IBOutlet weak var lblDetail11: UILabel!
    @IBOutlet weak var lblTitle12: UILabel!
    @IBOutlet weak var lblDetail12: UILabel!
    @IBOutlet weak var lblTitle13: UILabel!
    @IBOutlet weak var lblDetail13: UILabel!
    @IBOutlet weak var lblTitle14: UILabel!
    @IBOutlet weak var lblDetail14: UILabel!
    @IBOutlet weak var lblTitle15: UILabel!
    @IBOutlet weak var lblDetail15: UILabel!
    @IBOutlet weak var lblTitle16: UILabel!
    @IBOutlet weak var lblDetail16: UILabel!
    @IBOutlet weak var lblTitle17: UILabel!
    @IBOutlet weak var lblDetail17: UILabel!
    @IBOutlet weak var lblTitle18: UILabel!
    @IBOutlet weak var lblDetail18: UILabel!
    @IBOutlet weak var lblTitle19: UILabel!
    @IBOutlet weak var lblDetail19: UILabel!
    
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view5: UIView!
    @IBOutlet weak var view6: UIView!
    @IBOutlet weak var view7: UIView!
    @IBOutlet weak var view8: UIView!
    @IBOutlet weak var view9: UIView!
    @IBOutlet weak var view10: UIView!
    @IBOutlet weak var view11: UIView!
    @IBOutlet weak var view12: UIView!
    @IBOutlet weak var view13: UIView!
    @IBOutlet weak var view14: UIView!
    @IBOutlet weak var view15: UIView!
    @IBOutlet weak var view16: UIView!
    @IBOutlet weak var view17: UIView!
    @IBOutlet weak var view18: UIView!
    @IBOutlet weak var view19: UIView!
    
    @IBOutlet weak var imgArrow1: UIImageView!
    @IBOutlet weak var imgArrow2: UIImageView!
    @IBOutlet weak var imgArrow3: UIImageView!
    @IBOutlet weak var imgArrow4: UIImageView!
    @IBOutlet weak var imgArrow5: UIImageView!
    @IBOutlet weak var imgArrow6: UIImageView!
    @IBOutlet weak var imgArrow7: UIImageView!
    @IBOutlet weak var imgArrow8: UIImageView!
    @IBOutlet weak var imgArrow9: UIImageView!
    @IBOutlet weak var imgArrow10: UIImageView!
    @IBOutlet weak var imgArrow11: UIImageView!
    @IBOutlet weak var imgArrow12: UIImageView!
    @IBOutlet weak var imgArrow13: UIImageView!
    @IBOutlet weak var imgArrow14: UIImageView!
    @IBOutlet weak var imgArrow15: UIImageView!
    @IBOutlet weak var imgArrow16: UIImageView!
    @IBOutlet weak var imgArrow17: UIImageView!
    @IBOutlet weak var imgArrow18: UIImageView!
    @IBOutlet weak var imgArrow19: UIImageView!
    @IBOutlet weak var viewHeader: UIView!
    
    
    
    //MARK: - Veriable
    var userModel = UserModel()
    var selectImageIndex = 0
    var isSelectImg1 = false
    var isSelectImg2 = false
    var isSelectImg3 = false
    var isSelectImg4 = false
    var isSelectImg5 = false
    var isSelectImg6 = false
    

    //MARK: - func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLanguageUI()
        //--
        userModel = Login_LocalDB.getLoginUserModel()
        setProfile()
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
    }
    func setLanguageUI() {
        
        if Helper.shared.strLanguage == "ar"  {
            
            lblTitle1.semanticContentAttribute = .forceRightToLeft
            lblTitle2.semanticContentAttribute = .forceRightToLeft
            lblTitle3.semanticContentAttribute = .forceRightToLeft
            lblTitle4.semanticContentAttribute = .forceRightToLeft
            lblTitle5.semanticContentAttribute = .forceRightToLeft
            lblTitle6.semanticContentAttribute = .forceRightToLeft
            lblTitle7.semanticContentAttribute = .forceRightToLeft
            lblTitle8.semanticContentAttribute = .forceRightToLeft
            lblTitle9.semanticContentAttribute = .forceRightToLeft
            lblTitle10.semanticContentAttribute = .forceRightToLeft
            lblTitle11.semanticContentAttribute = .forceRightToLeft
            lblTitle12.semanticContentAttribute = .forceRightToLeft
            lblTitle13.semanticContentAttribute = .forceRightToLeft
            lblTitle14.semanticContentAttribute = .forceRightToLeft
            lblTitle15.semanticContentAttribute = .forceRightToLeft
            lblTitle16.semanticContentAttribute = .forceRightToLeft
            lblTitle17.semanticContentAttribute = .forceRightToLeft
            lblTitle18.semanticContentAttribute = .forceRightToLeft
            lblTitle19.semanticContentAttribute = .forceRightToLeft
            
            lblDetail1.semanticContentAttribute = .forceRightToLeft
            lblDetail2.semanticContentAttribute = .forceRightToLeft
            lblDetail3.semanticContentAttribute = .forceRightToLeft
            lblDetail4.semanticContentAttribute = .forceRightToLeft
            lblDetail5.semanticContentAttribute = .forceRightToLeft
            lblDetail6.semanticContentAttribute = .forceRightToLeft
            lblDetail7.semanticContentAttribute = .forceRightToLeft
            lblDetail8.semanticContentAttribute = .forceRightToLeft
            lblDetail9.semanticContentAttribute = .forceRightToLeft
            lblDetail10.semanticContentAttribute = .forceRightToLeft
            lblDetail11.semanticContentAttribute = .forceRightToLeft
            lblDetail12.semanticContentAttribute = .forceRightToLeft
            lblDetail13.semanticContentAttribute = .forceRightToLeft
            lblDetail14.semanticContentAttribute = .forceRightToLeft
            lblDetail15.semanticContentAttribute = .forceRightToLeft
            lblDetail16.semanticContentAttribute = .forceRightToLeft
            lblDetail17.semanticContentAttribute = .forceRightToLeft
            lblDetail18.semanticContentAttribute = .forceRightToLeft
            lblDetail19.semanticContentAttribute = .forceRightToLeft
            
            view1.semanticContentAttribute = .forceRightToLeft
            view2.semanticContentAttribute = .forceRightToLeft
            view3.semanticContentAttribute = .forceRightToLeft
            view4.semanticContentAttribute = .forceRightToLeft
            view5.semanticContentAttribute = .forceRightToLeft
            view6.semanticContentAttribute = .forceRightToLeft
            view7.semanticContentAttribute = .forceRightToLeft
            view8.semanticContentAttribute = .forceRightToLeft
            view9.semanticContentAttribute = .forceRightToLeft
            view10.semanticContentAttribute = .forceRightToLeft
            view11.semanticContentAttribute = .forceRightToLeft
            view12.semanticContentAttribute = .forceRightToLeft
            view13.semanticContentAttribute = .forceRightToLeft
            view14.semanticContentAttribute = .forceRightToLeft
            view15.semanticContentAttribute = .forceRightToLeft
            view16.semanticContentAttribute = .forceRightToLeft
            view17.semanticContentAttribute = .forceRightToLeft
            view18.semanticContentAttribute = .forceRightToLeft
            view19.semanticContentAttribute = .forceRightToLeft
            
            imgArrow1.semanticContentAttribute = .forceRightToLeft
            imgArrow2.semanticContentAttribute = .forceRightToLeft
            imgArrow3.semanticContentAttribute = .forceRightToLeft
            imgArrow4.semanticContentAttribute = .forceRightToLeft
            imgArrow5.semanticContentAttribute = .forceRightToLeft
            imgArrow6.semanticContentAttribute = .forceRightToLeft
            imgArrow7.semanticContentAttribute = .forceRightToLeft
            imgArrow8.semanticContentAttribute = .forceRightToLeft
            imgArrow9.semanticContentAttribute = .forceRightToLeft
            imgArrow10.semanticContentAttribute = .forceRightToLeft
            imgArrow11.semanticContentAttribute = .forceRightToLeft
            imgArrow12.semanticContentAttribute = .forceRightToLeft
            imgArrow13.semanticContentAttribute = .forceRightToLeft
            imgArrow14.semanticContentAttribute = .forceRightToLeft
            imgArrow15.semanticContentAttribute = .forceRightToLeft
            imgArrow16.semanticContentAttribute = .forceRightToLeft
            imgArrow17.semanticContentAttribute = .forceRightToLeft
            imgArrow18.semanticContentAttribute = .forceRightToLeft
            imgArrow19.semanticContentAttribute = .forceRightToLeft
            
            viewHeader.semanticContentAttribute = .forceRightToLeft
            scrollview.semanticContentAttribute = .forceRightToLeft
            lblHeaderTitle.semanticContentAttribute = .forceRightToLeft
            lblPhotoTitle.semanticContentAttribute = .forceRightToLeft
            lblIslamiclifestyle_title.semanticContentAttribute = .forceRightToLeft
            lblBasicInfo_title.semanticContentAttribute = .forceRightToLeft
            lblMoreAboutMe_title.semanticContentAttribute = .forceRightToLeft
            imgBack.semanticContentAttribute = .forceRightToLeft
            
        }
        btnUpdate.setTitle("Update".localizableString(lang: Helper.shared.strLanguage), for: .normal)
        lblHeaderTitle.text = "Edit profile".localizableString(lang: Helper.shared.strLanguage)
        lblPhotoTitle.text = "Photos".localizableString(lang: Helper.shared.strLanguage)
        //lblIslamiclifestyle_title.text = "Islamic lifestyle".localizableString(lang: Helper.shared.strLanguage)
        lblBasicInfo_title.text = "Basic info".localizableString(lang: Helper.shared.strLanguage)
        lblMoreAboutMe_title.text = "More about me".localizableString(lang: Helper.shared.strLanguage)
        
        lblTitle1.text = "Name".localizableString(lang: Helper.shared.strLanguage)
        lblTitle2.text = "Date of Birth".localizableString(lang: Helper.shared.strLanguage)
        lblTitle3.text = "Gender".localizableString(lang: Helper.shared.strLanguage)
        lblTitle4.text = "Education".localizableString(lang: Helper.shared.strLanguage)
        lblTitle5.text = "Language".localizableString(lang: Helper.shared.strLanguage)
        lblTitle6.text = "Religiosity".localizableString(lang: Helper.shared.strLanguage)
        lblTitle7.text = "Praying".localizableString(lang: Helper.shared.strLanguage)
        lblTitle8.text = "Halal food".localizableString(lang: Helper.shared.strLanguage)
        lblTitle9.text = "Alcohol".localizableString(lang: Helper.shared.strLanguage)
        lblTitle10.text = "Smoke".localizableString(lang: Helper.shared.strLanguage)
        lblTitle11.text = "Height".localizableString(lang: Helper.shared.strLanguage)
        lblTitle12.text = "Marital status".localizableString(lang: Helper.shared.strLanguage)
        lblTitle13.text = "Kids".localizableString(lang: Helper.shared.strLanguage)
        lblTitle14.text = "Workout".localizableString(lang: Helper.shared.strLanguage)
        lblTitle15.text = "Marriage plan".localizableString(lang: Helper.shared.strLanguage)
        
    }
    func setProfile(){
        
        //--
        var index = 1
        userModel.data?.user_image.forEach({ user_Image in
            let imgName = "\(kImageBaseURL)\(user_Image.image)".replacingOccurrences(of: " ", with: "%20")
            if index == 1{
                ImageLoader().imageLoad(imgView: img1, url: imgName)
                isSelectImg1 = true
            }else if index == 2{
                ImageLoader().imageLoad(imgView: img2, url: imgName)
                isSelectImg2 = true
            }else if index == 3{
                ImageLoader().imageLoad(imgView: img3, url: imgName)
                isSelectImg3 = true
                //btnClear3.isHidden = false
            }else if index == 4{
                ImageLoader().imageLoad(imgView: img4, url: imgName)
                isSelectImg4 = true
                btnClear4.isHidden = false
            }else if index == 5{
                ImageLoader().imageLoad(imgView: img5, url: imgName)
                isSelectImg5 = true
                btnClear5.isHidden = false
            }else if index == 6{
                ImageLoader().imageLoad(imgView: img6, url: imgName)
                isSelectImg6 = true
                btnClear6.isHidden = false
            }
            
            index = index + 1
        })
            
        
        lblDetail1.text = "\(userModel.data?.name ?? "")".localizableString(lang: Helper.shared.strLanguage)
        lblDetail2.text = AppHelper.datetoconvertSpecificFormate(dateOldFTR: k_DateFormate_Date, dateNewFTR: "MM-dd-yyyy", strDate: "\(userModel.data?.dob ?? "")")
        
        if (userModel.data?.gender ?? "") == "Man" || (userModel.data?.gender ?? "") == "ذكر" {
            lblDetail3.text = "Man".localizableString(lang: Helper.shared.strLanguage)
        } else if (userModel.data?.gender ?? "") == "Woman" || (userModel.data?.gender ?? "") == "انثى" {
            lblDetail3.text = "Woman".localizableString(lang: Helper.shared.strLanguage)
        } 
        
        //lblDetail3.text = "\(userModel.data?.gender ?? "")".localizableString(lang: Helper.shared.strLanguage)
        
        if (userModel.data?.education ?? "") == "High School" || (userModel.data?.education ?? "") == "مدرسة ثانوية" {
            lblDetail4.text = "High School".localizableString(lang: Helper.shared.strLanguage)
        } else if (userModel.data?.education ?? "") == "Bachelors" || (userModel.data?.education ?? "") == "غير حاصل على شهادة" {
            lblDetail4.text = "Bachelors".localizableString(lang: Helper.shared.strLanguage)
        } else if (userModel.data?.education ?? "") == "Masters" || (userModel.data?.education ?? "") == "درجة جامعية" {
            lblDetail4.text = "Masters".localizableString(lang: Helper.shared.strLanguage)
        } else if (userModel.data?.education ?? "") == "Post graduate" || (userModel.data?.education ?? "") == "دراسات عليا" {
            lblDetail4.text = "Post graduate".localizableString(lang: Helper.shared.strLanguage)
        } else if (userModel.data?.education ?? "") == "Prefer not to say" || (userModel.data?.education ?? "") == "افضل عدم القول" {
            lblDetail4.text = "Prefer not to say".localizableString(lang: Helper.shared.strLanguage)
        }
        
        
        //lblDetail4.text = "\(userModel.data?.education ?? "")".localizableString(lang: Helper.shared.strLanguage)
        
        let lang = "\(((userModel.data?.language_id ?? "").replacingOccurrences(of: "[", with: "")).replacingOccurrences(of: "]", with: ""))"

        var str = ""
        let arr = lang.components(separatedBy: ", ")
        for i in 0..<arr.count {
            
            if arr[i] == "Korean" || arr[i] == "الكورية" {
                str += "\("Korean".localizableString(lang: Helper.shared.strLanguage)), "
            } else if arr[i] == "Russian" || arr[i] == "الروسية"{
                str += "\("Russian".localizableString(lang: Helper.shared.strLanguage)), "
            } else if arr[i] == "Japanese" || arr[i] == "ليابانية" {
                str += "\("Japanese".localizableString(lang: Helper.shared.strLanguage)), "
            } else if arr[i] == "Irish" || arr[i] == "إيرلندي" {
                str += "\("Irish".localizableString(lang: Helper.shared.strLanguage)), "
            } else if arr[i] == "French" || arr[i] == "فرنسي" {
                str += "\("French".localizableString(lang: Helper.shared.strLanguage)), "
            }  else if arr[i] == "German" || arr[i] == "ألمانية" {
                str += "\("German".localizableString(lang: Helper.shared.strLanguage)), "
            }  else if arr[i] == "English" || arr[i] == "إنجليزي" {
                str += "\("English".localizableString(lang: Helper.shared.strLanguage)), "
            }  else if arr[i] == "Arabic" || arr[i] == "عربي" {
                str += "\("Arabic".localizableString(lang: Helper.shared.strLanguage)), "
            }  else if arr[i] == "Italian" || arr[i] == "إيطالي" {
                str += "\("Italian".localizableString(lang: Helper.shared.strLanguage)), "
            } else if arr[i] == "Somali" || arr[i] == "صومالي" {
                str += "\("Somali".localizableString(lang: Helper.shared.strLanguage)), "
            } else if arr[i] == "Serbian" || arr[i] == "الصربية" {
                str += "\("Serbian".localizableString(lang: Helper.shared.strLanguage)), "
            } else if arr[i] == "Chinese" || arr[i] == "صينى" {
                str += "\("Chinese".localizableString(lang: Helper.shared.strLanguage)), "
            } else if arr[i] == "Spanish" || arr[i] == "لاتيني" {
                str += "\("Spanish".localizableString(lang: Helper.shared.strLanguage)), "
            } else if arr[i] == "Swedish" || arr[i] == "السويدية" {
                str += "\("Swedish".localizableString(lang: Helper.shared.strLanguage)), "
            } else if arr[i] == "Amharic" || arr[i] == "الأمهرية" {
                str += "\("Amharic".localizableString(lang: Helper.shared.strLanguage)), "
            } else if arr[i] == "Portuguese" || arr[i] == "البرتغالية" {
                str += "\("Portuguese".localizableString(lang: Helper.shared.strLanguage)), "
            } else if arr[i] == "Igbo" || arr[i] == "الإيغبو" {
                str += "\("Igbo".localizableString(lang: Helper.shared.strLanguage)), "
            } else if arr[i] == "Kannada" || arr[i] == "الكانادا" {
                str += "\("Kannada".localizableString(lang: Helper.shared.strLanguage)), "
            } else if arr[i] == "Telugu" || arr[i] == "التيلجو" {
                str += "\("Telugu".localizableString(lang: Helper.shared.strLanguage)), "
            } else if arr[i] == "Gujarati" || arr[i] == "الغوجاراتية" {
                str += "\("Gujarati".localizableString(lang: Helper.shared.strLanguage)), "
            } else if arr[i] == "Thai" || arr[i] == "التايلاندية" {
                str += "\("Thai".localizableString(lang: Helper.shared.strLanguage)), "
            } else if arr[i] == "Khmer" || arr[i] == "الخمير" {
                str += "\("Khmer".localizableString(lang: Helper.shared.strLanguage)), "
            } else if arr[i] == "Slovenian" || arr[i] == "السلوفينية" {
                str += "\("Slovenian".localizableString(lang: Helper.shared.strLanguage)), "
            } else if arr[i] == "Kazakh" || arr[i] == "الكازاخستانية" {
                str += "\("Kazakh".localizableString(lang: Helper.shared.strLanguage)), "
            } else if arr[i] == "Ukrainian" || arr[i] == "الأوكرانية" {
                str += "\("Ukrainian".localizableString(lang: Helper.shared.strLanguage)), "
            } else if arr[i] == "Kurdish" || arr[i] == "كردي" {
                str += "\("Kurdish".localizableString(lang: Helper.shared.strLanguage)), "
            }
        }
        
        lblDetail5.text = "\(str.dropLast(2))"
        
        
        //lblDetail5.text = "\(((userModel.data?.language_id ?? "").replacingOccurrences(of: "[", with: "")).replacingOccurrences(of: "]", with: ""))"
        
        
        if (userModel.data?.religious ?? "") == "Not Practising" || (userModel.data?.religious ?? "") == "لا امارس" {
            lblDetail6.text = "Not Practising".localizableString(lang: Helper.shared.strLanguage)
        } else if (userModel.data?.religious ?? "") == "Moderately practising" || (userModel.data?.religious ?? "") == "متدين" {
            lblDetail6.text = "Moderately practising".localizableString(lang: Helper.shared.strLanguage)
        } else if (userModel.data?.religious ?? "") == "Practising" || (userModel.data?.religious ?? "") == "امارس" {
            lblDetail6.text = "Practising".localizableString(lang: Helper.shared.strLanguage)
        } else if (userModel.data?.religious ?? "") == "Very practising" || (userModel.data?.religious ?? "") == "اصلى احيانا" {
            lblDetail6.text = "Very practising".localizableString(lang: Helper.shared.strLanguage)
        }
        
        
        //lblDetail6.text = "\(userModel.data?.religious ?? "")".localizableString(lang: Helper.shared.strLanguage)
        
        if (userModel.data?.pray ?? "") == "Never pray" || (userModel.data?.pray ?? "") == "لا اصلى" {
            lblDetail7.text = "Never pray".localizableString(lang: Helper.shared.strLanguage)
        } else if (userModel.data?.pray ?? "") == "Sometimes pray" || (userModel.data?.pray ?? "") == "بعض الاحيان اصلى" {
            lblDetail7.text = "Sometimes pray".localizableString(lang: Helper.shared.strLanguage)
        } else if (userModel.data?.pray ?? "") == "Usually pray" || (userModel.data?.pray ?? "") == "عادة اصلى" {
            lblDetail7.text = "Usually pray".localizableString(lang: Helper.shared.strLanguage)
        } else if (userModel.data?.pray ?? "") == "Always pray" || (userModel.data?.pray ?? "") == "دائما اصلى" {
            lblDetail7.text = "Always pray".localizableString(lang: Helper.shared.strLanguage)
        }
        
        
        //lblDetail7.text = "\(userModel.data?.pray ?? "")".localizableString(lang: Helper.shared.strLanguage)
        
        if (userModel.data?.eating ?? "") == "Yes" || (userModel.data?.eating ?? "") == "نعم" {
            lblDetail8.text = "Yes".localizableString(lang: Helper.shared.strLanguage)
        } else if (userModel.data?.eating ?? "") == "No" || (userModel.data?.eating ?? "") == "رقم" {
            lblDetail8.text = "No".localizableString(lang: Helper.shared.strLanguage)
        }
        
        
        //lblDetail8.text = "\(userModel.data?.eating ?? "")".localizableString(lang: Helper.shared.strLanguage)
        
        if (userModel.data?.alcohol ?? "") == "Yes" || (userModel.data?.alcohol ?? "") == "نعم" {
            lblDetail9.text = "Yes".localizableString(lang: Helper.shared.strLanguage)
        } else if (userModel.data?.alcohol ?? "") == "No" || (userModel.data?.alcohol ?? "") == "رقم" {
            lblDetail9.text = "No".localizableString(lang: Helper.shared.strLanguage)
        } else if (userModel.data?.alcohol ?? "") == "Sometimes" || (userModel.data?.alcohol ?? "") == "بعض الاحيان" {
            lblDetail9.text = "Sometimes".localizableString(lang: Helper.shared.strLanguage)
        }
        
        
        //lblDetail9.text = "\(userModel.data?.alcohol ?? "")".localizableString(lang: Helper.shared.strLanguage)
        
        if (userModel.data?.smoke ?? "") == "Yes" || (userModel.data?.smoke ?? "") == "نعم" {
            lblDetail10.text = "Yes".localizableString(lang: Helper.shared.strLanguage)
        } else if (userModel.data?.smoke ?? "") == "No" || (userModel.data?.smoke ?? "") == "رقم" {
            lblDetail10.text = "No".localizableString(lang: Helper.shared.strLanguage)
        } else if (userModel.data?.smoke ?? "") == "Sometimes" || (userModel.data?.smoke ?? "") == "بعض الاحيان" {
            lblDetail10.text = "Sometimes".localizableString(lang: Helper.shared.strLanguage)
        }
        
        
        //lblDetail10.text = "\(userModel.data?.smoke ?? "")".localizableString(lang: Helper.shared.strLanguage)
        
        let height = "\((userModel.data?.height ?? "").replacingOccurrences(of: "\"", with: "''"))"
        
        if height == "4'0'' (122 cm)" || height == "0'4 (122 سم)" {
            lblDetail11.text = "4'0'' (122 cm)".localizableString(lang: Helper.shared.strLanguage)
        } else if height == "4'1'' (125 cm)" || height == "1'4 (125 سم)" {
            lblDetail11.text = "4'1'' (125 cm)".localizableString(lang: Helper.shared.strLanguage)
        } else if height == "4'2'' (127 cm)" || height == "2'4 (127 سم)" {
            lblDetail11.text = "4'2'' (127 cm)".localizableString(lang: Helper.shared.strLanguage)
        } else if height == "4'3'' (130 cm)" || height == "3'4 (130 سم)" {
            lblDetail11.text = "4'3'' (130 cm)".localizableString(lang: Helper.shared.strLanguage)
        } else if height == "4'4'' (132 cm)" || height == "4'4 (132 سم)" {
            lblDetail11.text = "4'4'' (132 cm)".localizableString(lang: Helper.shared.strLanguage)
        } else if height == "4'5'' (135 cm)" || height == "5'4 (135 سم)" {
            lblDetail11.text = "4'5'' (135 cm)".localizableString(lang: Helper.shared.strLanguage)
        } else if height == "4'6'' (137 cm)" || height == "6'4 (137 سم)" {
            lblDetail11.text = "4'6'' (137 cm)".localizableString(lang: Helper.shared.strLanguage)
        } else if height == "4'7'' (140 cm)" || height == "7'4 (140 سم)" {
            lblDetail11.text = "4'7'' (140 cm)".localizableString(lang: Helper.shared.strLanguage)
        } else if height == "4'8'' (142 cm)" || height == "8'4 (142 سم)" {
            lblDetail11.text = "4'8'' (142 cm)".localizableString(lang: Helper.shared.strLanguage)
        } else if height == "4'9'' (145 cm)" || height == "9'4 (145 سم)" {
            lblDetail11.text = "4'9'' (145 cm)".localizableString(lang: Helper.shared.strLanguage)
        } else if height == "4'10'' (147 cm)" || height == "10'4 (147 سم)" {
            lblDetail11.text = "4'10'' (147 cm)".localizableString(lang: Helper.shared.strLanguage)
        } else if height == "4'11'' (150 cm)" || height == "11'4 (150 سم)" {
            lblDetail11.text = "4'11'' (150 cm)".localizableString(lang: Helper.shared.strLanguage)
        }  else if height == "4'12'' (152 cm)" || height == "12'4 (152 سم)" {
            lblDetail11.text = "4'12'' (152 cm)".localizableString(lang: Helper.shared.strLanguage)
        } else if height == "5'0'' (153 cm)" || height == "0'5 (153 سم)" {
            lblDetail11.text = "5'0'' (153 cm)".localizableString(lang: Helper.shared.strLanguage)
        } else if height == "5'1'' (155 cm)" || height == "1'5 (155 سم)" {
            lblDetail11.text = "5'1'' (155 cm)".localizableString(lang: Helper.shared.strLanguage)
        } else if height == "5'2'' (157 cm)" || height == "2'5 (157 سم)" {
            lblDetail11.text = "5'2'' (157 cm)".localizableString(lang: Helper.shared.strLanguage)
        } else if height == "5'3'' (160 cm)" || height == "3'5 (160 سم)" {
            lblDetail11.text = "5'3'' (160 cm)".localizableString(lang: Helper.shared.strLanguage)
        } else if height == "5'4'' (162 cm)" || height == "4'5 (162 سم)" {
            lblDetail11.text = "5'4'' (162 cm)".localizableString(lang: Helper.shared.strLanguage)
        } else if height == "5'5'' (165 cm)" || height == "5'5 (165 سم)" {
            lblDetail11.text = "5'5'' (165 cm)".localizableString(lang: Helper.shared.strLanguage)
        } else if height == "5'6'' (167 cm)" || height == "6'5 (167 سم)" {
            lblDetail11.text = "5'6'' (167 cm)".localizableString(lang: Helper.shared.strLanguage)
        } else if height == "5'7'' (170 cm)" || height == "7'5 (170 سم)" {
            lblDetail11.text = "5'7'' (170 cm)".localizableString(lang: Helper.shared.strLanguage)
        } else if height == "5'8'' (172 cm)" || height == "8'5 (172 سم)" {
            lblDetail11.text = "5'8'' (172 cm)".localizableString(lang: Helper.shared.strLanguage)
        } else if height == "5'9'' (175 cm)" || height == "9'5 (175 سم)" {
            lblDetail11.text = "5'9'' (175 cm)".localizableString(lang: Helper.shared.strLanguage)
        } else if height == "5'10'' (177 cm)" || height == "10'5 (177 سم)" {
            lblDetail11.text = "5'10'' (177 cm)".localizableString(lang: Helper.shared.strLanguage)
        } else if height == "5'11'' (180 cm)" || height == "11'5 (180 سم)" {
            lblDetail11.text = "5'11'' (180 cm)".localizableString(lang: Helper.shared.strLanguage)
        } else if height == "5'12'' (182 cm)" || height == "12'5 (182 سم)" {
            lblDetail11.text = "5'12'' (182 cm)".localizableString(lang: Helper.shared.strLanguage)
        } else if height == "6'0'' (183 cm)" || height == "0'6 (183 سم)" {
            lblDetail11.text = "6'0'' (183 cm)".localizableString(lang: Helper.shared.strLanguage)
        } else if height == "6'1'' (186 cm)" || height == "1'6 (186 سم)" {
            lblDetail11.text = "6'1'' (186 cm)".localizableString(lang: Helper.shared.strLanguage)
        } else if height == "6'2'' (188 cm)" || height == "2'6 (188 سم)" {
            lblDetail11.text = "6'2'' (188 cm)".localizableString(lang: Helper.shared.strLanguage)
        } else if height == "6'3'' (190 cm)" || height == "3'6 (190 سم)" {
            lblDetail11.text = "6'3'' (190 cm)".localizableString(lang: Helper.shared.strLanguage)
        } else if height == "6'4'' (193 cm)" || height == "4'6 (193 سم)" {
            lblDetail11.text = "6'4'' (193 cm)".localizableString(lang: Helper.shared.strLanguage)
        } else if height == "6'5'' (195 cm)" || height == "5'6 (195 سم)" {
            lblDetail11.text = "6'5'' (195 cm)".localizableString(lang: Helper.shared.strLanguage)
        } else if height == "6'6'' (198 cm)" || height == "6'6 (198 سم)" {
            lblDetail11.text = "6'6'' (198 cm)".localizableString(lang: Helper.shared.strLanguage)
        } else if height == "6'7'' (200 cm)" || height == "7'6 (200 سم)" {
            lblDetail11.text = "6'7'' (200 cm)".localizableString(lang: Helper.shared.strLanguage)
        } else if height == "6'8'' (202 cm)" || height == "8'6 (202 سم)" {
            lblDetail11.text = "6'8'' (202 cm)".localizableString(lang: Helper.shared.strLanguage)
        } else if height == "6'9'' (205 cm)" || height == "9'6 (205 سم)" {
            lblDetail11.text = "6'9'' (205 cm)".localizableString(lang: Helper.shared.strLanguage)
        } else if height == "6'10'' (207 cm)" || height == "10'6 (207 سم)" {
            lblDetail11.text = "6'10'' (207 cm)".localizableString(lang: Helper.shared.strLanguage)
        } else if height == "6'11'' (210 cm)" || height == "11'6 بوصة (210 سم)" {
            lblDetail11.text = "6'11'' (210 cm)".localizableString(lang: Helper.shared.strLanguage)
        } else if height == "6'12'' (212 cm)" || height == "12'6 (212 سم)" {
            lblDetail11.text = "6'12'' (212 cm)".localizableString(lang: Helper.shared.strLanguage)
        }
        //lblDetail11.text = "\((userModel.data?.height ?? "").replacingOccurrences(of: "\"", with: "''"))".localizableString(lang: Helper.shared.strLanguage)
        
        if (userModel.data?.relation_status ?? "") == "Never married" || (userModel.data?.relation_status ?? "") == "لم يسبق الزواج" {
            lblDetail12.text = "Never married".localizableString(lang: Helper.shared.strLanguage)
        } else if (userModel.data?.relation_status ?? "") == "Single" || (userModel.data?.relation_status ?? "") == "أعزب" {
            lblDetail12.text = "Single".localizableString(lang: Helper.shared.strLanguage)
        } else if (userModel.data?.relation_status ?? "") == "Separated" || (userModel.data?.relation_status ?? "") == "منفصل" {
            lblDetail12.text = "Separated".localizableString(lang: Helper.shared.strLanguage)
        } else if (userModel.data?.relation_status ?? "") == "Divorced" || (userModel.data?.relation_status ?? "") == "مطلق" {
            lblDetail12.text = "Divorced".localizableString(lang: Helper.shared.strLanguage)
        } else if (userModel.data?.relation_status ?? "") == "Widowed" || (userModel.data?.relation_status ?? "") == "ارمل" {
            lblDetail12.text = "Widowed".localizableString(lang: Helper.shared.strLanguage)
        }
        
        
        //lblDetail12.text = "\(userModel.data?.relation_status ?? "")".localizableString(lang: Helper.shared.strLanguage)
        
        if (userModel.data?.kids ?? "") == "Have kids" || (userModel.data?.kids ?? "") == "نعم" {
            lblDetail13.text = "Have kids".localizableString(lang: Helper.shared.strLanguage)
        } else if (userModel.data?.kids ?? "") == "Don't have kids" || (userModel.data?.kids ?? "") == "ليس لديهم اطفال" {
            lblDetail13.text = "Don't have kids".localizableString(lang: Helper.shared.strLanguage)
        }
        
        
        //lblDetail13.text = "\(userModel.data?.kids ?? "")".localizableString(lang: Helper.shared.strLanguage)
        
        if (userModel.data?.work_out ?? "") == "Active" || (userModel.data?.work_out ?? "") == "نعم" {
            lblDetail14.text = "Active".localizableString(lang: Helper.shared.strLanguage)
        } else if (userModel.data?.work_out ?? "") == "Sometimes" || (userModel.data?.work_out ?? "") == "بعض الاحيان" {
            lblDetail14.text = "Sometimes".localizableString(lang: Helper.shared.strLanguage)
        } else if (userModel.data?.work_out ?? "") == "Almost never" || (userModel.data?.work_out ?? "") == "على الاغلب ل" {
            lblDetail14.text = "Almost never".localizableString(lang: Helper.shared.strLanguage)
        }
        
        //lblDetail14.text = "\(userModel.data?.work_out ?? "")".localizableString(lang: Helper.shared.strLanguage)
        
        if (userModel.data?.married_year ?? "") == "Marriage within a year" || (userModel.data?.married_year ?? "") == "الزواج خلال عام" {
            lblDetail15.text = "Marriage within a year".localizableString(lang: Helper.shared.strLanguage)
        } else if (userModel.data?.married_year ?? "") == "Marriage in 1-2 Years" || (userModel.data?.married_year ?? "") == "الزواج خلال 1-2 اعوام" {
            lblDetail15.text = "Marriage in 1-2 Years".localizableString(lang: Helper.shared.strLanguage)
        } else if (userModel.data?.married_year ?? "") == "Marriage in 3-4 Years" || (userModel.data?.married_year ?? "") == "الزواج خلال 3-4 اعوام" {
            lblDetail15.text = "Marriage in 3-4 Years".localizableString(lang: Helper.shared.strLanguage)
        } else if (userModel.data?.married_year ?? "") == "Marriage in 4+ Years" || (userModel.data?.married_year ?? "") == "الزواج خلال اكثر من 4 اعوام" {
            lblDetail15.text = "Marriage in 4+ Years".localizableString(lang: Helper.shared.strLanguage)
        } else if (userModel.data?.married_year ?? "") == "Don’t know yet" || (userModel.data?.married_year ?? "") == "لا أعرف بعد" {
            lblDetail15.text = "Don’t know yet".localizableString(lang: Helper.shared.strLanguage)
        } else {
            lblDetail15.text = (userModel.data?.married_year ?? "").localizableString(lang: Helper.shared.strLanguage)
        }
        //lblDetail15.text = "\(userModel.data?.married_year ?? "")".localizableString(lang: Helper.shared.strLanguage)
        
        //
        let deno = "\(((userModel.data?.denomination_id ?? "").replacingOccurrences(of: "[", with: "")).replacingOccurrences(of: "]", with: ""))"
        
        lblDetail16.text = deno
        
        //
        if (userModel.data?.go_church ?? "") == "Every week" || (userModel.data?.go_church ?? "") == "نعم" {
            lblDetail17.text = "Every week"
        } else if (userModel.data?.go_church ?? "") == "Every other week" || (userModel.data?.go_church ?? "") == "رقم" {
            lblDetail17.text = "Every other week"
        } else if (userModel.data?.go_church ?? "") == "Every month" || (userModel.data?.go_church ?? "") == "رقم" {
            lblDetail17.text = "Every month"
        } else if (userModel.data?.go_church ?? "") == "Once in a while" || (userModel.data?.go_church ?? "") == "رقم" {
            lblDetail17.text = "Once in a while"
        }
        
        
        //
        if (userModel.data?.looking_for ?? "") == "Marriage" || (userModel.data?.looking_for ?? "") == "الزواج" {
            lblDetail18.text = "Marriage"
        } else if (userModel.data?.looking_for ?? "") == "Relationship" {
            lblDetail18.text = "Relationship"
        }  else {
            lblDetail18.text = userModel.data?.looking_for ?? ""
        }
        
        //
        if (userModel.data?.your_zodiac ?? "") == "Leo" {
            lblDetail19.text = "Leo"
        } else if (userModel.data?.your_zodiac ?? "") == "Virgo" {
            lblDetail19.text = "Virgo"
        } else if (userModel.data?.your_zodiac ?? "") == "Libra" {
            lblDetail19.text = "Libra"
        } else if (userModel.data?.your_zodiac ?? "") == "Scorpio" {
            lblDetail19.text = "Scorpio"
        } else if (userModel.data?.your_zodiac ?? "") == "Sagittarius" {
            lblDetail19.text = "Sagittarius"
        } else if (userModel.data?.your_zodiac ?? "") == "Capricorn" {
            lblDetail19.text = "Capricorn"
        } else if (userModel.data?.your_zodiac ?? "") == "Aquarius" {
            lblDetail19.text = "Aquarius"
        } else if (userModel.data?.your_zodiac ?? "") == "Pisces" {
            lblDetail19.text = "Pisces"
        } else {
            lblDetail19.text = "Not set"
        }
    }
    
    func matchProfileImage(img:UIImage, image_id:String) {
        
        AppHelper.showLinearProgress()
        
        let user_Image = userModel.data?.user_image[0]
        let imgName = "\(kImageBaseURL)\(user_Image?.image ?? "")".replacingOccurrences(of: " ", with: "%20")
            
        let url = URL(string: imgName)
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        
        let images = [
            MatchFacesImage(image: img, imageType: .printed),
            MatchFacesImage(image: UIImage(data: data!)!, imageType: .printed),
        ]
        let request = MatchFacesRequest(images: images)

        FaceSDK.service.matchFaces(request, completion: { response in
            // ... check response.results for results with score and similarity values.
            //print(response)
            
            let doubleSimilarity = Double(String(format: "%.2f", Double(truncating: response.results[0].similarity ?? 0.0000000)))
            
            print("\(img)=\(doubleSimilarity!)")
            
            if (doubleSimilarity ?? 0.0) < 0.60 {//0.10 {
                
                AppHelper.returnTopNavigationController().view.makeToast("Image doesn't match")
                AppHelper.hideLinearProgress()
                return
            }
            
            
            print("Image matched")
            AppHelper.hideLinearProgress()
            
            //
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
                
            self.apiCall_updateImage(img_: img, image_id: image_id)
            
        })
    }
    
    //MARK: - ApiCall
    func apiCall_updateImage(img_: UIImage, image_id: String)  {
        if NetworkReachabilityManager()!.isReachable == false
        {
            let alert = UIAlertController(title: internetConnectedTitle.localizableString(lang: Helper.shared.strLanguage), message: internetConnected.localizableString(lang: Helper.shared.strLanguage), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK".localizableString(lang: Helper.shared.strLanguage), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            //--
            let dicParam:[String:AnyObject] = ["image":img_ as AnyObject,
                                               "image_id":image_id as AnyObject]
            
            AppHelper.showLinearProgress()
            self.view.isUserInteractionEnabled = false
            HttpWrapper.requestMultipartFormDataWithImageAndFile(a_updateImage, dicsParams: dicParam, headers: ["Authorization":userModel.data?.api_token ?? ""], completion: { (response) in
                self.view.isUserInteractionEnabled = true
                AppHelper.hideLinearProgress()
                let dicsResponseFinal = response.replaceNulls(with: "")
                print(dicsResponseFinal as Any)
                
                let userListModel_ = UserModel(JSON: dicsResponseFinal as! [String : Any])!
                if userListModel_.code == 200{
                    //--
                    if let userListModel_ = UserModel(JSON: dicsResponseFinal as! [String : Any])!.toJSONString(){
                        Login_LocalDB.saveLoginInfo(strData: userListModel_)
                        
                        //
                        self.userModel = Login_LocalDB.getLoginUserModel()
                        self.setProfile()
                    }
                    
                    //--
                    //AppHelper.returnTopNavigationController().view.makeToast(dicsResponseFinal?.object(forKey: "message") as? String ?? "")
                    //self.navigationController?.popViewController(animated: true)
                    
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

    func apiCall_updateProfile()  {
        if NetworkReachabilityManager()!.isReachable == false
        {
            let alert = UIAlertController(title: internetConnectedTitle.localizableString(lang: Helper.shared.strLanguage), message: internetConnected.localizableString(lang: Helper.shared.strLanguage), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK".localizableString(lang: Helper.shared.strLanguage), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            //--
            let devicetoken = UserDefaults.standard.object(forKey: "fcm_devicetoken") as? String ?? "ios"
            
            //--
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
                                               "email":userModel.data?.email as AnyObject,
                                               "quickbox_id":userModel.data?.quickbox_id as AnyObject,
                                               "update_profile":"1" as AnyObject]
            
            AppHelper.showLinearProgress()
            self.view.isUserInteractionEnabled = false
            HttpWrapper.requestMultipartFormDataWithImageAndFile(a_updateProfile, dicsParams: dicParam, headers: ["Authorization":userModel.data?.api_token ?? ""], completion: { (response) in
                self.view.isUserInteractionEnabled = true
                AppHelper.hideLinearProgress()
                let dicsResponseFinal = response.replaceNulls(with: "")
                print(dicsResponseFinal as Any)
                
                let userListModel_ = UserModel(JSON: dicsResponseFinal as! [String : Any])!
                if userListModel_.code == 200{
                    //--
                    if let userListModel_ = UserModel(JSON: dicsResponseFinal as! [String : Any])!.toJSONString(){
                        Login_LocalDB.saveLoginInfo(strData: userListModel_)
                    }
                    
                    //--
                    self.navigationController?.popViewController(animated: true)
                        
                    //--
                    AppHelper.returnTopNavigationController().view.makeToast(dicsResponseFinal?.object(forKey: "message") as? String ?? "")
                    
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
    func deleteImageAPI(image_id:String) {
        
        if NetworkReachabilityManager()!.isReachable == false
        {
            return
        }
        AppHelper.showLinearProgress()
        
        let dicParams:[String:AnyObject] = ["image_id":image_id as AnyObject]
        
        HttpWrapper.requestWithparamdictParamPostMethodwithHeader(url: image_delete, dicsParams: dicParams, headers: ["Authorization":userModel.data?.api_token ?? ""], completion: { [self] (response) in
            self.view.isUserInteractionEnabled = true
            AppHelper.hideLinearProgress()
            let dicsResponseFinal = response.replaceNulls(with: "")
            print(dicsResponseFinal as Any)
            
            let userListModel_ = UserModel(JSON: dicsResponseFinal as! [String : Any])!
            if userListModel_.code == 200{
                //--
                if let userListModel_ = UserModel(JSON: dicsResponseFinal as! [String : Any])!.toJSONString(){
                    Login_LocalDB.saveLoginInfo(strData: userListModel_)
                }
                
                //--
                AppHelper.returnTopNavigationController().view.makeToast(dicsResponseFinal?.object(forKey: "message") as? String ?? "")
                self.navigationController?.popViewController(animated: true)
                
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
    
    func apiCall_UseAsMainPhoto(image_id: String)  {
        if NetworkReachabilityManager()!.isReachable == false
        {
            let alert = UIAlertController(title: internetConnectedTitle.localizableString(lang: Helper.shared.strLanguage), message: internetConnected.localizableString(lang: Helper.shared.strLanguage), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK".localizableString(lang: Helper.shared.strLanguage), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            //--
            let dicParam:[String:AnyObject] = ["image_id":image_id as AnyObject]
            
            //AppHelper.showLinearProgress()
            self.view.isUserInteractionEnabled = false
            HttpWrapper.requestMultipartFormDataWithImageAndFile(set_as_main_image, dicsParams: dicParam, headers: ["Authorization":userModel.data?.api_token ?? ""], completion: { (response) in
                self.view.isUserInteractionEnabled = true
                //AppHelper.hideLinearProgress()
                let dicsResponseFinal = response.replaceNulls(with: "")
                print(dicsResponseFinal as Any)
                
                let userListModel_ = UserModel(JSON: dicsResponseFinal as! [String : Any])!
                if userListModel_.code == 200{
                    //--
                    if let userListModel_ = UserModel(JSON: dicsResponseFinal as! [String : Any])!.toJSONString(){
                        Login_LocalDB.saveLoginInfo(strData: userListModel_)
                        
                        //
                        self.userModel = Login_LocalDB.getLoginUserModel()
                        self.setProfile()
                    }
                    
                    //--
                    //AppHelper.returnTopNavigationController().view.makeToast(dicsResponseFinal?.object(forKey: "message") as? String ?? "")
                    //self.navigationController?.popViewController(animated: true)
                    
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

    //MARK: - @IBAction
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
        
//        let alert = UIAlertController(title: kAlertTitle, message: "Are you sure, you want to delete an image?", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
//
//            //
//            self.isSelectImg3 = false
//            self.img3.image = nil
//            self.btnClear3.isHidden = true
//
//            self.deleteImageAPI(image_id: "\(self.userModel.data?.user_image[2].id ?? 0)")
//        }))
//        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func btnClearImg4(_ sender: Any) {
        
        let alert = UIAlertController(title: kAlertTitle, message: "Are you sure, you want to delete an image?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            
            //
            self.isSelectImg4 = false
            self.img4.image = nil
            self.btnClear4.isHidden = true
            
            self.deleteImageAPI(image_id: "\(self.userModel.data?.user_image[3].id ?? 0)")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func btnClearImg5(_ sender: Any) {
        
        let alert = UIAlertController(title: kAlertTitle, message: "Are you sure, you want to delete an image?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            
            //
            self.isSelectImg5 = false
            self.img5.image = nil
            self.btnClear5.isHidden = true
            
            self.deleteImageAPI(image_id: "\(self.userModel.data?.user_image[4].id ?? 0)")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func btnClearImg6(_ sender: Any) {
        
        let alert = UIAlertController(title: kAlertTitle, message: "Are you sure, you want to delete an image?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            
            //
            self.isSelectImg6 = false
            self.img6.image = nil
            self.btnClear6.isHidden = true
            
            self.deleteImageAPI(image_id: "\(self.userModel.data?.user_image[5].id ?? 0)")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnQ1(_ sender: Any) {
        //--
        let vc = NameVC(nibName: "NameVC", bundle: nil)
        vc.isComeProfile = true
        vc.userModel = userModel
        vc.delegateUpdateProfileInfo = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnQ2(_ sender: Any) {
        //--
        let vc = DobVC(nibName: "DobVC", bundle: nil)
        vc.isComeProfile = true
        vc.userModel = userModel
        vc.delegateUpdateProfileInfo = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnQ3(_ sender: Any) {
        //--
        let vc = IamaVC(nibName: "IamaVC", bundle: nil)
        vc.isComeProfile = true
        vc.userModel = userModel
        vc.delegateUpdateProfileInfo = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnQ4(_ sender: Any) {
        //--
        let vc = EducationVC(nibName: "EducationVC", bundle: nil)
        vc.isComeProfile = true
        vc.userModel = userModel
        vc.delegateUpdateProfileInfo = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnQ5(_ sender: Any) {
        //--
        let vc = SelectlangVC(nibName: "SelectlangVC", bundle: nil)
        vc.isComeProfile = true
        vc.userModel = userModel
        vc.delegateUpdateProfileInfo = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnQ6(_ sender: Any) {
        //--
        let vc = ReligiousVC(nibName: "ReligiousVC", bundle: nil)
        vc.isComeProfile = true
        vc.userModel = userModel
        vc.delegateUpdateProfileInfo = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnQ7(_ sender: Any) {
        //--
        let vc = YouPrayVC(nibName: "YouPrayVC", bundle: nil)
        vc.isComeProfile = true
        vc.userModel = userModel
        vc.delegateUpdateProfileInfo = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnQ8(_ sender: Any) {
        //--
        let vc = EatHalalVC(nibName: "EatHalalVC", bundle: nil)
        vc.isComeProfile = true
        vc.userModel = userModel
        vc.delegateUpdateProfileInfo = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnQ9(_ sender: Any) {
        //--
        let vc = AlcoholVC(nibName: "AlcoholVC", bundle: nil)
        vc.isComeProfile = true
        vc.userModel = userModel
        vc.delegateUpdateProfileInfo = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnQ10(_ sender: Any) {
        //--
        let vc = YouSmokeVC(nibName: "YouSmokeVC", bundle: nil)
        vc.isComeProfile = true
        vc.userModel = userModel
        vc.delegateUpdateProfileInfo = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnQ11(_ sender: Any) {
        //--
        let vc = YourHeightVC(nibName: "YourHeightVC", bundle: nil)
        vc.isComeProfile = true
        vc.userModel = userModel
        vc.delegateUpdateProfileInfo = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnQ12(_ sender: Any) {
        //--
        let vc = RelationshipStatusVC(nibName: "RelationshipStatusVC", bundle: nil)
        vc.isComeProfile = true
        vc.userModel = userModel
        vc.delegateUpdateProfileInfo = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnQ13(_ sender: Any) {
        //--
        let vc = HaveKidsVC(nibName: "HaveKidsVC", bundle: nil)
        vc.isComeProfile = true
        vc.userModel = userModel
        vc.delegateUpdateProfileInfo = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnQ14(_ sender: Any) {
        //--
        let vc = WorkOutVC(nibName: "WorkOutVC", bundle: nil)
        vc.isComeProfile = true
        vc.userModel = userModel
        vc.delegateUpdateProfileInfo = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnQ15(_ sender: Any) {
        //--
        let vc = GetmarriedVC(nibName: "GetmarriedVC", bundle: nil)
        vc.isComeProfile = true
        vc.userModel = userModel
        vc.delegateUpdateProfileInfo = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnQ16(_ sender: Any) {
        //--
        let vc = DenominationVC(nibName: "DenominationVC", bundle: nil)
        vc.isComeProfile = true
        vc.userModel = userModel
        vc.delegateUpdateProfileInfo = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnQ17(_ sender: Any) {
        //--
        let vc = GoChurchVC(nibName: "GoChurchVC", bundle: nil)
        vc.isComeProfile = true
        vc.userModel = userModel
        vc.delegateUpdateProfileInfo = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnQ18(_ sender: Any) {
        //--
        let vc = LookingForVC(nibName: "LookingForVC", bundle: nil)
        vc.isComeProfile = true
        vc.userModel = userModel
        vc.delegateUpdateProfileInfo = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnQ19(_ sender: Any) {
        //--
        let vc = ZodiacVC(nibName: "ZodiacVC", bundle: nil)
        vc.isComeProfile = true
        vc.userModel = userModel
        vc.delegateUpdateProfileInfo = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func btnDone_UpdateProfile(_ sender: Any) {
        apiCall_updateProfile()
    }
}

extension EditProfileVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    //MARK:- ImagePicker delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            
            if userModel.data?.user_image.count ?? 0 >= selectImageIndex {
                
                for i in 0..<(userModel.data?.user_image.count ?? 0) {
                    
                    if i == selectImageIndex-1 {
                        
//                        matchProfileImage(img: image, image_id: "\(userModel.data?.user_image[i].id ?? 0)")
                        self.apiCall_updateImage(img_: image, image_id: "\(userModel.data?.user_image[i].id ?? 0)")
                    }
                }
            } else {
//                matchProfileImage(img: image, image_id: "")
                self.apiCall_updateImage(img_: image, image_id: "")
            }
            
            
//            if selectImageIndex == 1{
//                img1.image = image
//                isSelectImg1 = true
//            }
//            if selectImageIndex == 2{
//                img2.image = image
//                isSelectImg2 = true
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
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func onTapImage() {
        
        let alert = UIAlertController(title: "Choose Image".localizableString(lang: Helper.shared.strLanguage), message: nil, preferredStyle: .actionSheet)
        
        if selectImageIndex != 1 {
            
            if selectImageIndex == 2 || selectImageIndex == 3 || (selectImageIndex == 4 && self.img4.image != nil) || (selectImageIndex == 5 && self.img5.image != nil) || (selectImageIndex == 6 && self.img6.image != nil) {
                alert.addAction(UIAlertAction(title: "Use as main photo", style: .default, handler: { [self] _ in
                    self.apiCall_UseAsMainPhoto(image_id: "\(userModel.data?.user_image[selectImageIndex-1].id ?? 0)")
                }))
            }
            
        }
        
        alert.addAction(UIAlertAction(title: "Replace from camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Replace from gallery", style: .default, handler: { _ in
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

extension EditProfileVC: UpdateProfileInfo{
    func updateProfileInfo(userModel_: UserModel){
        userModel = userModel_
        setProfile()
    }
}
