//
//  SelfieContainVC.swift
//  HalalDating
//
//  Created by Maulik Vora on 26/11/21.
//

import UIKit
import FaceSDK

class SelfieContainVC: UIViewController {
    //MARK: - @IBOutlet
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var btnVerifyPerson: UIButton!
    @IBOutlet weak var lbl3: UILabel!
    @IBOutlet weak var lbl4: UILabel!
    @IBOutlet weak var viewBg: UIView!
    
    
    
    //MARK: - Veriable
    var userModel = UserModel()
    var arrSelectedImage = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setLanguageUI()
    }

    func setLanguageUI() {
        
        if Helper.shared.strLanguage == "ar" {
            
            lbl3.semanticContentAttribute = .forceRightToLeft
            lbl4.semanticContentAttribute = .forceRightToLeft
            viewBg.semanticContentAttribute = .forceRightToLeft
        }
        lbl1.text = "Take a selfie".localizableString(lang: Helper.shared.strLanguage)
        //lbl2.text = "Please take a quick selfie to confirm you're a real person. Your selfie won't appear on your profile and will not be seen by our team.".localizableString(lang: Helper.shared.strLanguage)
        lbl3.text = "Show your face clearly".localizableString(lang: Helper.shared.strLanguage)
        lbl4.text = "Make sure you're in a well it area and have both eyes clearly visible.".localizableString(lang: Helper.shared.strLanguage)
        btnVerifyPerson.setTitle("Verify person".localizableString(lang: Helper.shared.strLanguage), for: .normal)
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
                    let vc = SelfieConfirmVC(nibName: "SelfieConfirmVC", bundle: nil)
                    vc.imgSelfieSelect = (response.image?.image)!
                    vc.userModel = self.userModel
                    vc.arrSelectedImage = self.arrSelectedImage
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            },
            completion: nil
        )

    }

    //MARK: - @IBAction
    @IBAction func btnVerifyPerson(_ sender: Any) {
       
        openFaceDetector()
    }
    
}
