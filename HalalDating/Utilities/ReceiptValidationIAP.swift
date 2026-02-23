//
//  ReceiptValidationIAP.swift
//  HalalDating
//
//  Created by Apple on 14/06/24.
//

import UIKit
import SwiftyJSON
import Alamofire

class ReceiptValidationIAP: NSObject {

    static let shared = ReceiptValidationIAP()
    
    var verifyReceiptURL = ""//"https://sandbox.itunes.apple.com/verifyReceipt"//"https://buy.itunes.apple.com/verifyReceipt"
    
    func receiptValidation() {
        
        //
        if let isRunningTestFlightBeta = Bundle.main.appStoreReceiptURL?.lastPathComponent as? String {
            
            if isRunningTestFlightBeta == "sandboxReceipt" {//testflight&device(debug)
                
                verifyReceiptURL = "https://sandbox.itunes.apple.com/verifyReceipt"//test
            } else if isRunningTestFlightBeta == "receipt" {//simulator & Live app
                
                verifyReceiptURL = "https://buy.itunes.apple.com/verifyReceipt"//live
            } else {
                verifyReceiptURL = "https://buy.itunes.apple.com/verifyReceipt"//live
            }
            
        }
        
        
        //
        
        let receiptFileURL = Bundle.main.appStoreReceiptURL
        let receiptData = try? Data(contentsOf: receiptFileURL!)
        let recieptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        
        
        if recieptString == nil {
            
            //recieptString comes nil, if user never subscribe or if user has active subscription but app gets uninstalled and then reinstalled. So in that case, we need to show Subscribe UI so user can buy plan or restore purchase respectively
            
            Helper.shared.isSubscriptionActive = "0"
            self.userSubscribeUnsubscribeAPI(flag: "0")
            return
        }
        
        
        let jsonDict: [String: AnyObject] = ["receipt-data" : recieptString! as AnyObject,
                                             "password" : "95e9212eb3f44fbe954e8f559b677bef" as AnyObject]
        
        do {
            let requestData = try JSONSerialization.data(withJSONObject: jsonDict, options: JSONSerialization.WritingOptions.prettyPrinted)
            let storeURL = URL(string: verifyReceiptURL)!
            var storeRequest = URLRequest(url: storeURL)
            storeRequest.httpMethod = "POST"
            storeRequest.httpBody = requestData
            
            //AppHelper.showLinearProgress()
            let session = URLSession(configuration: URLSessionConfiguration.default)
            let task = session.dataTask(with: storeRequest, completionHandler: { [weak self] (data, response, error) in
                
                DispatchQueue.main.async {
                    //AppHelper.hideLinearProgress()
                }
                
                if data == nil {
                    return
                }
                
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                    print("=======>",print(JSON.init(jsonResponse)))
                    
                    if (jsonResponse as? [String:Any])?["status"] as? Int == 0 {
                        
                        if let date = self?.getExpirationDateFromResponse(jsonResponse as! [String:Any]) {
                            print(date)
                            
                            if date < (Helper.shared.getCurrentDateGMT()) {
                                Helper.shared.isSubscriptionActive = "0"
                                self?.userSubscribeUnsubscribeAPI(flag: "0")
                            } else {
                                Helper.shared.isSubscriptionActive = "1"
                                self?.userSubscribeUnsubscribeAPI(flag: "1")
                            }
                            
                        }
                        
                        if let receiptInfo = ((jsonResponse as? [String:Any])?["receipt"] as? [String:Any])?["in_app"] as? [[String:Any]] {
                            //for backend side use
                            if receiptInfo.count > 0 {
                                self?.saveRenewalTransactionAPI(receiptInfo: receiptInfo.last!)
                            }
                            
                        }
                        
                    } else {
                        print((jsonResponse as? [String:Any])?["status"] as? Int)
                    }
                    
                } catch let parseError {
                    print(parseError)
                }
            })
            task.resume()
        } catch let parseError {
            print(parseError)
        }
    }
    
    func getExpirationDateFromResponse(_ jsonResponse: [String:Any]) -> Date? {
        
        if let receiptInfo = (jsonResponse["receipt"] as? [String:Any])?["in_app"] as? [[String:Any]] {//["latest_receipt_info"] as? [[String:Any]] {
            
            let lastReceipt = receiptInfo.last
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
            
            if let expiresDate = lastReceipt?["expires_date"] as? String {
                return formatter.date(from: expiresDate)
            }
            
            return nil
        }
        else {
            return nil
        }
    }
    
    func userSubscribeUnsubscribeAPI(flag:String) {
        
        if NetworkReachabilityManager()!.isReachable == false
        {
            return
        }
        
        let dicParams:[String:String] = ["flag":flag]
        //AppHelper.showLinearProgress()
        
        let userModel = Login_LocalDB.getLoginUserModel()
        
        let headers:HTTPHeaders = ["Accept":"application/json",
                                   "Authorization":userModel.data?.api_token ?? ""]
        
        AF.request(users_sub_or_unsubscribes, method: .post, parameters: dicParams, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            
            print(response)
            
            if let json = response.value as? [String:Any] {
                
                if json["status"] as? String == "Success" {
                    
                    let dict = json["data"] as? [String:Any]
                    
                    
                }
            }
            
            //AppHelper.hideLinearProgress()
        }
    }
    
    func saveRenewalTransactionAPI(receiptInfo:[String:Any]) {
        
        if NetworkReachabilityManager()!.isReachable == false
        {
            return
        }
        
        
        //AppHelper.showLinearProgress()
        
        let dicParams:[String:Any] = ["original_transaction_id":receiptInfo["original_transaction_id"] as? String ?? "",
                                      "transaction_id":receiptInfo["transaction_id"] as? String ?? "",
                                      "expires_date":receiptInfo["expires_date"] as? String ?? "",
                                      "purchase_date":receiptInfo["purchase_date"] as? String ?? "",
                                      "product_id":receiptInfo["product_id"] as? String ?? ""]
        
        let userModel = Login_LocalDB.getLoginUserModel()
        
        let headers:HTTPHeaders = ["Accept":"application/json",
                                   "Authorization":userModel.data?.api_token ?? ""]
        
        AF.request(save_renewal_transaction, method: .post, parameters: dicParams, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            
            print(response)
            
            if let json = response.value as? [String:Any] {
                
                if json["status"] as? String == "Success" {
                    
                    
                    
                }
            }
            
            //AppHelper.hideLinearProgress()
        }
    }
}

