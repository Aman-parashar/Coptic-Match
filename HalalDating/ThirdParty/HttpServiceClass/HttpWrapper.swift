//
//  HttpWrapper.swift
//  Deputize America
//
//  Created by Vishal on 24/05/17.
//  Copyright © 2017 darshak. All rights reserved.
//

import UIKit
import Alamofire
//import Reachability
import SystemConfiguration


protocol HttpWrapperDelegate
{
    func HttpWrapperfetchDataSuccess(wrapper : HttpWrapper,dicsResponse : NSMutableDictionary)
    func HttpWrapperfetchDataFail(wrapper : HttpWrapper,error : NSError);
}

class HttpWrapper: NSObject
{
    var delegate:HttpWrapperDelegate? = nil
    
    // MARK:- requestWithparamdictParam
    
    func requestWithparamdictParam(_ url : String)
    {
        //        let newURL = url.replacingOccurrences(of: " ", with: "%")
        
        if !HttpWrapper.checkInternetConnection()
        {
            return
        }
        
        (AF.request(url)).responseString { response in
            if((response.error) != nil)
            {
                // print("\nRequestURL: \((response.request?.url)!)\n")
                // print("Sucees But Error: \(response.result.error!)")
            }
        }
        .responseJSON { response in
            // print("\nRequestURL: \((response.request?.url)!)\n")
            // print("Response JSON: \n \(response.result.value!)")
            if((response.error) == nil)
            {
                if let JSON = response.value {
                    var mydict = NSDictionary()
                    mydict = JSON as! NSDictionary
                    
                    if (self.delegate != nil){
                        self.delegate?.HttpWrapperfetchDataSuccess(wrapper: self, dicsResponse: mydict.mutableCopy() as! NSMutableDictionary)
                    }
                }
                else
                {
                    AppHelper.showAlert("Alert", message: "Please try again.")
                    // print("response not converted to JSON")
                }
            }
            else
            {
                if (self.delegate != nil){
                    self.delegate?.HttpWrapperfetchDataFail(wrapper: self, error: response.error! as NSError);
                }
            }
        }
    }
    
    
    // MARK:- requestWithparamdictParamPostMethodwithHeader
//    class func requestWithparamdictParamPostMethodwithHeader(url : String ,dicsParams : [String: AnyObject], headers: [String: String], completion: @escaping (_ response:NSMutableDictionary)->Void, errorBlock: @escaping (_ response:Error)->Void)
//    /*func requestWithparamdictParamPostMethodwithHeader(url : String ,dicsParams : [String: AnyObject],  headers: [String: String])*/
//    {
//        if !self.checkInternetConnection()
//        {
//            return
//        }
//        
//        AF.request(url, method: .post, parameters: dicsParams, encoding:  JSONEncoding.default , headers: HTTPHeaders(headers))
//        .responseString(completionHandler: { (string) in
//            print(dicsParams)
//            //print(string)
//        })
//        .responseJSON { response in
//            //print("Response JSON: \n \(String(describing: response.value))")
//            if((response.error) == nil)
//            {
//                if let JSON = response.value
//                {
//                    var mydict = NSDictionary()
//                    mydict = JSON as! NSDictionary
//                    
//                    completion(NSMutableDictionary(dictionary: mydict))
//                    /*if (self.delegate != nil){
//                     self.delegate?.HttpWrapperfetchDataSuccess(wrapper: self, dicsResponse: mydict.mutableCopy() as! NSMutableDictionary)
//                     }*/
//                }
//                else
//                {
//                    // print("response not converted to JSON")
//                    //                        SharedUtility.showAlert("Alert", message: "Please try again.")
//                }
//            }
//            else
//            {
//                if let error_ = response.error{
//                    errorBlock(error_)
//                }
//                /*if (self.delegate != nil){
//                 self.delegate?.HttpWrapperfetchDataFail(wrapper: self, error: response.error! as NSError);
//                 }*/
//            }
//        }
//        
//    }
    
    class func requestWithparamdictParamPostMethodwithHeader(url : String ,dicsParams : [String: AnyObject], headers: [String: String], completion: @escaping (_ response:NSMutableDictionary)->Void, errorBlock: @escaping (_ response:Error)->Void) {
        // Check internet connectivity first
        guard checkInternetConnection() else {
            // Create and return network error
            let error = NSError(domain: "NetworkError", code: -1009, userInfo: [NSLocalizedDescriptionKey: "No internet connection"])
            errorBlock(error)
            return
        }
        
        AF.request(url, method: .post, parameters: dicsParams, encoding: JSONEncoding.default, headers: HTTPHeaders(headers))
            .validate() // Add validation
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    // Safely handle JSON conversion
                    if let jsonDict = value as? [String: Any] {
                        let dict = NSDictionary(dictionary: jsonDict)
                        completion(NSMutableDictionary(dictionary: dict))
                    } else {
                        // Handle invalid JSON
                        let error = NSError(domain: "ParsingError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON response"])
                        errorBlock(error)
                    }
                    
                case .failure(let error):
                    // Handle network/server errors
                    errorBlock(error)
                }
            }
    }
    
    
    
    // MARK:- requestWithparamdictParamPostMethodwithHeader
    class func requestWithGet(url : String , completion: @escaping (_ response:NSMutableDictionary)->Void, errorBlock: @escaping (_ response:Error)->Void)
    {
        if !self.checkInternetConnection()
        {
            return
        }
        AF.request(url, method: .get).responseString
        { response in
            //print(dicsParams)
            if((response.error) != nil)
            {}
        }
        .responseString(completionHandler: { (string) in
        })
        .responseJSON { response in
            //print("Response JSON: \n \(String(describing: response.result.value))")
            if((response.error) == nil)
            {
                if let kJSON = response.value
                {
                    //print(kJSON)
                    let mydict = NSDictionary()
                    if mydict == kJSON as? NSDictionary
                    {
                        completion(NSMutableDictionary(dictionary: mydict))
                    }
                    else
                    {
                        if let newdata = kJSON as? NSArray
                        {
                            var mydict2 = NSDictionary()
                            
                            mydict2 = newdata[0] as! NSDictionary
                            //print(mydict2)
                            completion(NSMutableDictionary(dictionary: mydict2))
                        }
                        else
                        {
                            
                            var mydict2 = NSDictionary()
                            
                            mydict2 = kJSON as! NSDictionary
                            //print(mydict2)
                            completion(NSMutableDictionary(dictionary: mydict2))
                        }
                    }
                }
                else
                {
                    if let error_ = response.error{
                        errorBlock(error_)
                    }
                }
            }
            else
            {
                if let error_ = response.error{
                    errorBlock(error_)
                }
            }
        }
    }
    class func requestWithparamdictParamPostMethodwithHeaderGet(url : String , headers: [String: String], completion: @escaping (_ response:NSMutableDictionary)->Void, errorBlock: @escaping (_ response:Error)->Void)
    {
        if !self.checkInternetConnection()
        {
            return
        }
        AF.request(url, method: .get,headers: HTTPHeaders(headers)).responseString
        { response in
            //print(dicsParams)
            if((response.error) != nil)
            {}
        }
        .responseString(completionHandler: { (string) in
        })
        .responseJSON { response in
            //print("Response JSON: \n \(String(describing: response.result.value))")
            if((response.error) == nil)
            {
                if let kJSON = response.value
                {
                    //print(kJSON)
                    let mydict = NSDictionary()
                    if mydict == kJSON as? NSDictionary
                    {
                        completion(NSMutableDictionary(dictionary: mydict))
                    }
                    else
                    {
                        if let newdata = kJSON as? NSArray
                        {
                            var mydict2 = NSDictionary()
                            
                            mydict2 = newdata[0] as! NSDictionary
                            //print(mydict2)
                            completion(NSMutableDictionary(dictionary: mydict2))
                        }
                        else
                        {
                            
                            var mydict2 = NSDictionary()
                            
                            mydict2 = kJSON as! NSDictionary
                            //print(mydict2)
                            completion(NSMutableDictionary(dictionary: mydict2))
                        }
                    }
                }
                else
                {
                    if let error_ = response.error{
                        errorBlock(error_)
                    }
                }
            }
            else
            {
                if let error_ = response.error{
                    errorBlock(error_)
                }
            }
        }
    }
    
    
    //MARK:- requestWithparamdictParamPostMethod
    class func requestWithparamdictParamPostMethod(url : String ,dicsParams : [String: AnyObject], completion: @escaping (_ response:NSMutableDictionary)->Void, errorBlock: @escaping (_ response:Error)->Void)
    //func requestWithparamdictParamPostMethod(url : String ,dicsParams : [String: AnyObject])
    {
        if !self.checkInternetConnection()
        {
            return
        }
        AF.request(url, method: .post, parameters: dicsParams, encoding: URLEncoding.default).responseString
        { response in
            // print(dicsParams)
            if((response.error) != nil)
            {
                // print("Sucees But Error: \(String(describing: response.result.error))")
                //                    AppHelper.showAlertWithTitle("", description1: "Please try again some internet problem")
            }
        }
        .responseString(completionHandler: { (string) in
            
        })
        .responseJSON { response in
            //  print("Response JSON: \n \(String(describing: response.result.value))")
            if((response.error) == nil)
            {
                if let JSON = response.value
                {
                    var mydict = NSDictionary()
                    mydict = JSON as! NSDictionary
                    
                    completion(NSMutableDictionary(dictionary: mydict))
                    /*if (self.delegate != nil){
                     self.delegate?.HttpWrapperfetchDataSuccess(wrapper: self, dicsResponse: mydict.mutableCopy() as! NSMutableDictionary)
                     }*/
                }
                else
                {
                    // print("response not converted to JSON")
                    //                        SharedUtility.showAlert("Alert", message: "Please try again.")
                }
            }
            else
            {
                if let error_ = response.error{
                    errorBlock(error_)
                }
                /*if (self.delegate != nil){
                 self.delegate?.HttpWrapperfetchDataFail(wrapper: self, error: response.error! as NSError);
                 }*/
            }
        }
    }
    //MARK:- Image, File
    class func requestMultipartFormDataWithImageAndFile(_ url : String ,dicsParams : [String: AnyObject],headers: HTTPHeaders, completion: @escaping (_ response:NSMutableDictionary)->Void, errorBlock: @escaping (_ response:Error)->Void)
    //func requestMultipartFormDataWithImageAndFile(_ url : String ,dicsParams : [String: AnyObject],strHeader : String)
    {
        if !self.checkInternetConnection()
        {
            return
        }
        //let headers: HTTPHeaders = ["CLOUD_API_KEY":CLOUD_API_KEY, "CLOUD_API_SECRET":CLOUD_API_SECRET, "API-token":strHeader]
        
        
        AF.upload(multipartFormData: { multipartFormData in
            
            //--set file url
            for (key, value) in dicsParams
            {
                if value is URL
                {
                    
                    let pdfData = try! Data(contentsOf: value as! URL)
                    //  var data : Data = pdfData
                    
                    
                    //multipartFormData.append(pdfData, withName: key)
                    let fileName = (value as! URL).lastPathComponent
                    let pathExtension = (value as! URL).pathExtension
                    
                    if pathExtension == ".m4a"
                    {
                        multipartFormData.append(pdfData, withName: key, fileName: fileName, mimeType:"application/.mp3")
                    }
                    else
                    {
                        multipartFormData.append(pdfData, withName: key, fileName: fileName, mimeType:"application/\(pathExtension)")
                    }
                    // multipartFormData.append(value as! URL, withName: key)
                }
            }
            
            
            
            //--Set value
            for (key, value) in dicsParams
            {
                if value is NSString
                {
                    let dt = (value as! String).data(using: String.Encoding.utf8)
                    multipartFormData.append(dt!, withName: key)
                }
                if value is Int
                {
                    let dt = "\(value)".data(using: String.Encoding.utf8)
                    multipartFormData.append(dt!, withName: key)
                }
            }
            
            //-- Set image
            for (key, value) in dicsParams
            {
                if value is UIImage
                {
                    if let imageData = (value as! UIImage).jpegData(compressionQuality:0.0)
                    {
                        let format: DateFormatter = DateFormatter()
                        format.dateFormat = "yyyyMMddHHmmss"
                        let now: NSDate = NSDate()
                        let retStr: String = format.string(from: now as Date)
                        let randnumber = retStr
                        
                        //let randnumber = time(nil)
                        let random=String(format: "%d.jpeg", randnumber)
                        
                        multipartFormData.append(imageData, withName: key, fileName: random, mimeType: "image/jpeg")
                    }
                }
            }
            
            //set image in array
            for (key, value) in dicsParams
            {
                if value is NSArray
                {
                    for (image) in value as! NSArray
                    {
                        // UIImage
                        if let imgUI = image as? UIImage{
                            if  let imageData = imgUI.jpegData(compressionQuality:0.0)
                            {
                                let format: DateFormatter = DateFormatter()
                                format.dateFormat = "yyyyMMddHHmmss"
                                let now: NSDate = NSDate()
                                let retStr: String = format.string(from: now as Date)
                                let randnumber = retStr
                                
                                //let randnumber = time(nil)
                                let random=String(format: "%d.jpeg", randnumber)
                                
                                //  print(imageData)
                                //  print(key)
                                //  print(random)
                                
                                multipartFormData.append(imageData, withName: key, fileName: random, mimeType: "image/jpeg")
                            }
                        }
                        
                        // URL
                        if let url_ = image as? URL{
                            var pdfData = try! Data(contentsOf: url_)
                            if pdfData.count == 0{
                                pdfData = AppHelper.returnFileData(localUrl: url_)
                            }
                            //  var data : Data = pdfData
                            
                            
                            //multipartFormData.append(pdfData, withName: key)
                            let fileName = url_.lastPathComponent
                            let pathExtension = url_.pathExtension
                            
                            if pathExtension == "m4a"
                            {
                                multipartFormData.append(pdfData, withName: key, fileName: "fileName.mp3", mimeType:"application/.mp3")
                            }
                            else
                            {
                                multipartFormData.append(pdfData, withName: key, fileName: fileName, mimeType:"application/\(pathExtension)")
                            }
                        }
                        
                    }
                }
            }
        }, to: url, usingThreshold: UInt64.init(),method: .post, headers: headers).responseJSON { response in
//            if response.value is NSNull {
//                
//            } else {
//                if let JSON = response.value {
//                    var mydict = NSDictionary()
//                    mydict = JSON as! NSDictionary
//                    
//                    completion(NSMutableDictionary(dictionary: mydict))
//                    /*if (self.delegate != nil){
//                     self.delegate?.HttpWrapperfetchDataSuccess(wrapper: self, dicsResponse: mydict.mutableCopy() as! NSMutableDictionary)
//                     }*/
//                }
//                else
//                {
//                    if let error_ = response.error{
//                        errorBlock(error_)
//                    }
//                    /*if (self.delegate != nil){
//                     self.delegate?.HttpWrapperfetchDataFail(wrapper: self, error: response.error! as NSError);
//                     }*/
//                }
//            }
            
            switch response.result {
            case .success(let value):
                if value is NSNull {
                    let error = NSError(domain: "APIError", code: -1,
                                      userInfo: [NSLocalizedDescriptionKey: "Empty response from server"])
                    errorBlock(error)
                    return
                }
                
                guard let dict = value as? NSDictionary else {
                    let error = NSError(domain: "APIError", code: -2,
                                      userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])
                    errorBlock(error)
                    return
                }
                
                completion(NSMutableDictionary(dictionary: dict))
                
            case .failure(let error):
                errorBlock(error)
            }
        }
    }
    
    // MARK:- requestMultipartFormDataWithImageAndVideo
    class func requestMultipartFormDataWithImageAndVideo(_ url : String ,dicsParams : [String: AnyObject],headers : HTTPHeaders, completion: @escaping (_ response:NSMutableDictionary)->Void, errorBlock: @escaping (_ response:Error)->Void)
    //func requestMultipartFormDataWithImageAndVideo(_ url : String ,dicsParams : [String: AnyObject],strHeader : String)
    {
        if !self.checkInternetConnection()
        {
            return
        }
        
        //let username = ""
        //let password = ""
        //let credentialData = "\(username):\(password)".data(using: String.Encoding.utf8)!
        //        let base64Credentials = credentialData.base64EncodedString(options: [])
        //        _ = ["Authorization": "Basic \(base64Credentials)"]
        
        
        
        //let headers: HTTPHeaders = ["Authorization":strHeader]
        
        AF.upload(multipartFormData: { multipartFormData in
            
            for (key, value) in dicsParams
            {
                
                if value is NSString
                {
                    let dt = (value as! String).data(using: String.Encoding.utf8)
                    multipartFormData.append(dt!, withName: key)
                }
            }
            
            // print(dicsParams)
            
            for (key, value) in dicsParams
            {
                if value is UIImage
                {
                    if let imageData = (value as! UIImage).jpegData(compressionQuality:0.0)
                    {
                        let format: DateFormatter = DateFormatter()
                        format.dateFormat = "yyyyMMddHHmmss"
                        let now: NSDate = NSDate()
                        let retStr: String = format.string(from: now as Date)
                        let randnumber = retStr
                        
                        //let randnumber = time(nil)
                        let random=String(format: "%d.jpeg", randnumber)
                        
                        multipartFormData.append(imageData, withName: key, fileName: random, mimeType: "image/jpeg")
                    }
                }
            }
            
            for (key, value) in dicsParams
            {
                if value is NSArray
                {
                    for (image) in value as! NSArray
                    {
                        if  let imageData = (image as! UIImage).jpegData(compressionQuality:0.0)
                        {
                            let format: DateFormatter = DateFormatter()
                            format.dateFormat = "yyyyMMddHHmmss"
                            let now: NSDate = NSDate()
                            let retStr: String = format.string(from: now as Date)
                            let randnumber = retStr
                            
                            //let randnumber = time(nil)
                            let random=String(format: "%d.jpeg", randnumber)
                            
                            //  print(imageData)
                            //  print(key)
                            //  print(random)
                            
                            multipartFormData.append(imageData, withName: key, fileName: random, mimeType: "image/jpeg")
                            
                        }
                    }
                }
            }
            
        }, to: url, headers: headers).responseJSON { response in
            
            if response.value is NSNull
            {
                //                        AppHelper.showAlertWithTitle(kAleartTitle, description1: "Response nil")
            }
            else
            {
                if let JSON = response.value {
                    var mydict = NSDictionary()
                    mydict = JSON as! NSDictionary
                    
                    completion(NSMutableDictionary(dictionary: mydict))
                    /*if (self.delegate != nil){
                     self.delegate?.HttpWrapperfetchDataSuccess(wrapper: self, dicsResponse: mydict.mutableCopy() as! NSMutableDictionary)
                     }*/
                }
                else
                {
                    if let error_ = response.error{
                        errorBlock(error_)
                    }
                    //AppHelper.showAlertWithTitle(kAleartTitle, description1: "Please try again.")
                    //print("response not converted to JSON")
                }
            }
        }
        
        
        
        /* AF.upload(multipartFormData: { (multipartFormData) in
         for (key, value) in dicsParams
         {
         
         if value is NSString
         {
         let dt = (value as! String).data(using: String.Encoding.utf8)
         multipartFormData.append(dt!, withName: key)
         }
         }
         
         // print(dicsParams)
         
         for (key, value) in dicsParams
         {
         if value is UIImage
         {
         if let imageData = (value as! UIImage).jpegData(compressionQuality:0.0)
         {
         let format: DateFormatter = DateFormatter()
         format.dateFormat = "yyyyMMddHHmmss"
         let now: NSDate = NSDate()
         let retStr: String = format.string(from: now as Date)
         let randnumber = retStr
         
         //let randnumber = time(nil)
         let random=String(format: "%d.jpeg", randnumber)
         
         multipartFormData.append(imageData, withName: key, fileName: random, mimeType: "image/jpeg")
         }
         }
         }
         
         for (key, value) in dicsParams
         {
         if value is NSArray
         {
         for (image) in value as! NSArray
         {
         if  let imageData = (image as! UIImage).jpegData(compressionQuality:0.0)
         {
         let format: DateFormatter = DateFormatter()
         format.dateFormat = "yyyyMMddHHmmss"
         let now: NSDate = NSDate()
         let retStr: String = format.string(from: now as Date)
         let randnumber = retStr
         
         //let randnumber = time(nil)
         let random=String(format: "%d.jpeg", randnumber)
         
         //  print(imageData)
         //  print(key)
         //  print(random)
         
         multipartFormData.append(imageData, withName: key, fileName: random, mimeType: "image/jpeg")
         
         }
         }
         }
         }
         }, to: url) { (encodingResult) in
         switch encodingResult {
         case .success(let upload, _, _):
         upload.responseJSON { response in
         //                    debugPrint(response)
         //                    se.hideLoadingSpinner()
         if response.result.value is NSNull
         {
         //                        AppHelper.showAlertWithTitle(kAleartTitle, description1: "Response nil")
         }
         else
         {
         if let JSON = response.result.value {
         var mydict = NSDictionary()
         mydict = JSON as! NSDictionary
         
         if (self.delegate != nil){
         //                                print("response:--------------------\n %@",mydict)
         self.delegate?.HttpWrapperfetchDataSuccess(wrapper: self, dicsResponse: mydict.mutableCopy() as! NSMutableDictionary)
         }
         }
         else
         {
         //                            AppHelper.showAlertWithTitle(kAleartTitle, description1: "Please try again.")
         //print("response not converted to JSON")
         }
         
         }
         //API error
         /*
         upload.response(completionHandler: { (request, response, data, error) -> Void in
         
         //                            NSLog("upload.response : data : %@", String(data: data!, encoding: NSUTF8StringEncoding)!)
         NSLog("upload.response : response : %@", response!)
         
         
         })*/
         }
         case .failure(let encodingError):
         print(encodingError)
         if (self.delegate != nil){
         self.delegate?.HttpWrapperfetchDataFail(wrapper: self, error: encodingError as NSError);
         }
         }
         }*/
    }
    //
    class func requestMultipartFormDataWithImageAndVideoHeaderParameter(url: String, imageData: Data?, parameters: [String : Any], Header:[String: Any], completion: @escaping (_ response:NSMutableDictionary)->Void, errorBlock: @escaping (_ response:Error)->Void)
    /*func requestMultipartFormDataWithImageAndVideoHeaderParameter(url: String, imageData: Data?, parameters: [String : Any], Header:[String: Any])*/
    {
        let token = Header["apiToken"] as? String
        let headers: HTTPHeaders = [
            /* "Authorization": "your_access_token",  in case you need authorization header */
            "apiToken" : token!,
            "Content-type":"multipart/form-data"
        ]
        
        AF.upload(multipartFormData: { multipartFormData in
            
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            if let data = imageData{
                multipartFormData.append(data, withName: "userImage", fileName: "image.png", mimeType: "image/png")
            }
            
            
        }, to: url, headers: headers).responseJSON { response in
            
            if let error_ = response.error{
                errorBlock(error_)
                return
            }
            
            if response.value is NSNull
            {
                //                        AppHelper.showAlertWithTitle(kAleartTitle, description1: "Response nil")
            }
            else
            {
                if let JSON = response.value {
                    var mydict = NSDictionary()
                    mydict = JSON as! NSDictionary
                    
                    completion(NSMutableDictionary(dictionary: mydict))
                    /*if (self.delegate != nil){
                     self.delegate?.HttpWrapperfetchDataSuccess(wrapper: self, dicsResponse: mydict.mutableCopy() as! NSMutableDictionary)
                     }*/
                }
                else
                {
                    //AppHelper.showAlertWithTitle(kAleartTitle, description1: "Please try again.")
                    //print("response not converted to JSON")
                }
            }
            
        }
        /*AF.upload(multipartFormData: { (multipartFormData) in
         for (key, value) in parameters {
         multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
         }
         
         if let data = imageData{
         multipartFormData.append(data, withName: "userImage", fileName: "image.png", mimeType: "image/png")
         }
         
         }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
         switch result{
         case .success(let upload, _, _):
         upload.responseJSON { response in
         print("Succesfully uploaded")
         if let err = response.error{
         return
         }
         if response.result.value is NSNull
         {
         //                        AppHelper.showAlertWithTitle(kAleartTitle, description1: "Response nil")
         }
         else
         {
         if let JSON = response.result.value {
         var mydict = NSDictionary()
         mydict = JSON as! NSDictionary
         
         if (self.delegate != nil){
         //                                print("response:--------------------\n %@",mydict)
         self.delegate?.HttpWrapperfetchDataSuccess(wrapper: self, dicsResponse: mydict.mutableCopy() as! NSMutableDictionary)
         }
         }
         else
         {
         //                            AppHelper.showAlertWithTitle(kAleartTitle, description1: "Please try again.")
         //print("response not converted to JSON")
         }
         }
         
         }
         case .failure(let error):
         
         print("Error in upload: \(error.localizedDescription)")
         self.delegate?.HttpWrapperfetchDataFail(wrapper: self, error: error as NSError);
         }
         }*/
    }
    
    // MARK:- checkInternetConnection
    class func checkInternetConnection() -> Bool
    {
        
        /*var zeroAddress = sockaddr_in()
         zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
         zeroAddress.sin_family = sa_family_t(AF_INET)
         guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
         
         $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
         
         SCNetworkReachabilityCreateWithAddress(nil, $0)
         
         }
         
         }) else {
         
         return false
         }
         var flags = SCNetworkReachabilityFlags()
         if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
         return false
         }
         let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
         let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
         return (isReachable && !needsConnection)*/
        
        var zeroAddress = sockaddr()
        zeroAddress.sa_len = UInt8(MemoryLayout<sockaddr>.size)
        zeroAddress.sa_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }) else { return false }
        
        var flags = SCNetworkReachabilityFlags()
        guard SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) else { return false }
        
        return flags.contains(.reachable) && !flags.contains(.connectionRequired)
        //
        //                let reachability = Reachability.forInternetConnection() as Reachability;
        //                let internetStatus : Int = reachability.currentReachabilityStatus().rawValue
        //                if ((internetStatus == 0) || (reachability.connectionRequired() == true)) {
        //                    return false;
        //                }
        //                return true;
    }
}
