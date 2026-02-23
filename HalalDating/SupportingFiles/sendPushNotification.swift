//
//  sendPushNotification.swift
//  BeeCrops
//
//  Created by Maulik Vinodbhai Vora on 26/09/19.
//  Copyright © 2019 Maulik Vora. All rights reserved.
//

import Foundation

class PushNotificationSender {
    func sendPushNotification(to token: String, title: String, body: String, device_type: String, chat_type: String) {
        
        
        let notification = ["sound":"1","vibrate":"1","title" : title, "body" : body]
        let data_ = ["sound":"1", "vibrate":"1", "title" : title, "body" : body,"message": body, "chat_type": chat_type]
        
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        var paramString: [String : Any] = [:]
        if device_type == "ios"{
            paramString = ["to" : token,
                           "notification" : notification,
                           "data" : ["notification": notification, "data":data_]
            ]
        }else{
            paramString = ["to" : token,
                           "data" : ["data":data_]
            ]
        }
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.setValue("key=AAAAfB8ZXKQ:APA91bG-VZl-1XI1SGVYVzTuLCyES3FB9_wR8SEUBAWxQK0-tviiENSgT_n1DVXKyNnaOjzamJBHsTFUdNfiHFhBRD1WrfrKR6r7aErcAZ7FUifqvcYBqrwMlKkVx-oC2Qwudp2D5ZNS", forHTTPHeaderField: "Authorization")
        
        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            DispatchQueue.global(qos: .background).async {
                do {
                    if let jsonData = data {
                        if let jsonDataDict = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                            NSLog("Received data:\n\(jsonDataDict))")
                        }
                    }
                } catch let err as NSError {
                    print(err.debugDescription)
                }
            }
        }
        task.resume()
    }
}
