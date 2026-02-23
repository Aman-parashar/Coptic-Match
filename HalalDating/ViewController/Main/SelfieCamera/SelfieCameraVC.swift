//
//  SelfieCameraVC.swift
//  HalalDating
//
//  Created by Maulik Vora on 26/11/21.
//

import UIKit
import AVFoundation
import FaceSDK

class SelfieCameraVC: UIViewController {
    //MARK: - @IBOutlet
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var viewbgCamera: UIView!
    
    
    //MARK: - Veriable
    var userModel = UserModel()
    var arrSelectedImage = NSMutableArray()
    
    //--
//    var captureSession: AVCaptureSession!
//    var stillImageOutput: AVCapturePhotoOutput!
//    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    
    
    //MARK: - func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        openFaceDetector()
        setHeaderView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
       
        /*captureSession = AVCaptureSession()
        captureSession.sessionPreset = .medium
//        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
//            else {
//                print("Unable to access back camera!")
//                return
//        }
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(
                deviceTypes: [ .builtInWideAngleCamera ],
                mediaType: .video,
                position: .front
            )
        guard let backCamera = deviceDiscoverySession.devices.first else { return }

        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            //Step 9
            stillImageOutput = AVCapturePhotoOutput()
            if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                
                setupLivePreview()
            }
        }
        catch let error  {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }*/
        
       
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.captureSession.stopRunning()
    }
    func setHeaderView(){
        headerView.delegate_HeaderView = self
        headerView.progressBar.isHidden = true
        headerView.imgAppIcon.isHidden = true
        headerView.lblTitle.isHidden = false
        headerView.lblTitle.text = "Selfie"
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
//    func setupLivePreview() {
//
//        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//
//        videoPreviewLayer.videoGravity = .resizeAspectFill
//        videoPreviewLayer.connection?.videoOrientation = .portrait
//        viewbgCamera.layer.addSublayer(videoPreviewLayer)
//
//        //Step12
//        DispatchQueue.global(qos: .userInitiated).async { //[weak self] in
//            self.captureSession.startRunning()
//            //Step 13
//            DispatchQueue.main.async {
//                self.videoPreviewLayer.frame = self.viewbgCamera.bounds
//            }
//        }
//    }
    
    //MARK: - @IBAction
//    @IBAction func btnTakePhoto(_ sender: Any) {
//        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
//        stillImageOutput.capturePhoto(with: settings, delegate: self)
//    }
    


}

//extension SelfieCameraVC: AVCapturePhotoCaptureDelegate {
//
//
//    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
//
//        guard let imageData = photo.fileDataRepresentation()
//            else { return }
//
//        let image = UIImage(data: imageData)
//        //captureImageView.image = image
//        print(image)
//
//        //--
//        if let img_ = image{
//            let vc = SelfieConfirmVC(nibName: "SelfieConfirmVC", bundle: nil)
//            vc.imgSelfieSelect = img_
//            vc.userModel = userModel
//            vc.arrSelectedImage = arrSelectedImage
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//    }
//}
//
extension SelfieCameraVC: HeaderView_Protocol{
    func btnBack() {
        self.navigationController?.popViewController(animated: true)
    }
}
