//
//  WebviewVC.swift
//  HalalDating
//
//  Created by Apple on 23/11/22.
//

import UIKit
import WebKit
import Alamofire

class WebviewVC: UIViewController, WKNavigationDelegate {
    
    // MARK: - Variable
    var strName = ""
    
    // MARK: - IBOutlet
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var webview: WKWebView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var imgBack: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setLanguageUI()
        setupUI()
        getUrlAPI()
    }
    
    
    // MARK: - Function
    
    func setupUI() {
        
        self.tabBarController?.tabBar.isHidden = true
        
        webview.navigationDelegate = self
        
        if strName == "terms" {
            lblTitle.text = "Terms & Conditions".localizableString(lang: Helper.shared.strLanguage)
        }
        if strName == "privacy" {
            lblTitle.text = "Privacy Policy".localizableString(lang: Helper.shared.strLanguage)
        }
        if strName == "tips" {
            lblTitle.text = "Safety tips".localizableString(lang: Helper.shared.strLanguage)
        }
    }
    func setLanguageUI() {
        
        if Helper.shared.strLanguage == "ar"  {
            viewBg.semanticContentAttribute = .forceRightToLeft
            lblTitle.semanticContentAttribute = .forceRightToLeft
            viewHeader.semanticContentAttribute = .forceRightToLeft
            imgBack.semanticContentAttribute = .forceRightToLeft
        }
        
    }
    func loadHTML(content:String) {
        
        let htmlStart = "<HTML><HEAD><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, shrink-to-fit=no\"><style>img {max-width:100%;}</style></HEAD><BODY>"
        let htmlEnd = "</BODY></HTML>"
        let htmlString = "\(htmlStart)\(content)\(htmlEnd)"
        
        webview.loadHTMLString(htmlString, baseURL: nil)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        //webView.scrollView.isScrollEnabled = false
        webView.evaluateJavaScript("document.documentElement.scrollHeight", completionHandler: { (height, error) in
            self.heightConstraint?.constant = height as! CGFloat
        })
        
    }
    
    
    // MARK: - Webservice
    func getUrlAPI() {
        
        if NetworkReachabilityManager()!.isReachable == false
        {
            return
        }
        AppHelper.showLinearProgress()
        
        let dicParams:[String:String] = ["lang_code":Helper.shared.strLanguage]
        
        var strUrl = ""
        if strName == "terms" {
            strUrl = terms
        }
        if strName == "privacy" {
            strUrl = privacy
        }
        if strName == "tips" {
            strUrl = safety_tips
        }
        
        
        let headers:HTTPHeaders = ["Accept":"application/json"]
        
        AF.request(strUrl, method: .post, parameters: dicParams, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            
            print(response)
            
            if let json = response.value as? [String:Any] {
                
                if json["status"] as? String == "Success" {
                    
                    let dict = json["data"] as? [String:Any]
                    
                    self.loadHTML(content: (dict?["pages_detail"] as? [[String:Any]])?[0]["description"] as? String ?? "")
                }
            }
            
            AppHelper.hideLinearProgress()
        }
    }
    
    // MARK: - IBAction
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
