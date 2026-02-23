//
//  NetworkManager.swift
//  HalalDating
//
//  Created by Apple on 18/10/22.
//

import UIKit
import Alamofire

class NetworkManager: NSObject {
    
    static let shared = NetworkManager()
    
    
    func webserviceCallPostMethod(url:String, parameters:[String:Any], headers:HTTPHeaders, completion:@escaping ([String:Any])->()) {
        
        if NetworkReachabilityManager()!.isReachable {
            
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                
                print(response)
                
                print("URL:\(url) PARAM:\(parameters)")
                print(response as Any)
                    
                //completion(response)
                
            }
            
//            AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { response in
//
//                print("URL:\(url) PARAM:\(parameters)")
//                print(response.result as Any)
//                if let _ = response.result as? [String:Any] {
//
//                    completion(response.result)
//                } else {
//                    completion([:])
//                }
//            }
        }else{
            print("Internet Connection not Available!")
        }
        
    }
//    func webserviceCallCommonGetMethod(url:String, headers:HTTPHeaders, completion:@escaping (CommonResponse)->()) {
//        
//        if Reachability.isConnectedToNetwork(){
//            
//            Alamofire.request(url, method: .get, encoding: URLEncoding.default, headers: headers).responseObject { (response: DataResponse<CommonResponse>) in
//                
//                print("URL:\(url)")
//                print(response.result.value as Any)
//                if let _ = response.result.value {
//                    if response.result.value?.ResponseCode == 401 {
//                        
//                        Helper.shared.logout()
//                    }
//                    completion(response.result.value!)
//                } else {
//                    
//                }
//            }
//        }else{
//            print("Internet Connection not Available!")
//        }
//        
//    }

}
