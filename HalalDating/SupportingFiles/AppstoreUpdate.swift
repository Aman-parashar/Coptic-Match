//
//  AppstoreUpdate.swift
// 
//
//  Created by Apple on 30/06/23.
//

import Foundation
import UIKit

enum VersionError: Error {
    case invalidResponse, invalidBundleInfo
}

class AppStoreUpdate: NSObject {
    
    static let shared = AppStoreUpdate()
    
    func checkNewAppVersionAvailableOnAppstore(isForceUpdate: Bool) {
        
        _ = try? isUpdateAvailable { (update, version, currentVersion, error) in
            if let error = error {
                print(error)
            } else if let update = update {
                print(update)
                
                if update == true && (version > currentVersion) {
                    
                    DispatchQueue.main.async {
                        //self.tabBarController?.tabBar.isHidden = true
                        
                        
                        //
                        
                        self.showAppUpdateView(appVersion: "\(version)", isForceUpdate: isForceUpdate)
                    }
                    
                } else {
                    //self.checkCreditInfoAPI()
                }
            }
        }
        
    }
    func isUpdateAvailable(completion: @escaping (Bool?, Float, Float, Error?) -> Void) throws -> URLSessionDataTask {
        guard let info = Bundle.main.infoDictionary,
            let currentVersion = info["CFBundleShortVersionString"] as? String,
            let identifier = info["CFBundleIdentifier"] as? String,
            let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(identifier)") else {
                throw VersionError.invalidBundleInfo
        }
        print(currentVersion)
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                if let error = error { throw error }
                guard let data = data else { throw VersionError.invalidResponse }
                let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any]
                guard let result = (json?["results"] as? [Any])?.first as? [String: Any], let version = result["version"] as? String else {
                    throw VersionError.invalidResponse
                }
                completion(version != currentVersion, Float(version)!, Float(currentVersion)!, nil)
            } catch {
                completion(nil,0.0,0.0,error)
            }
        }
        task.resume()
        return task
    }
    

    func showAppUpdateView(appVersion:String, isForceUpdate: Bool) {
        
        let customView = Bundle.main.loadNibNamed("AppUpdateView", owner: self, options: nil)?.first as? AppUpdateView
        
        customView?.lblVersion.text = "V \(appVersion)"
        if isForceUpdate {
            customView?.btnCancel.isHidden = true
        } else {
            customView?.btnCancel.isHidden = false
        }
        
        //customView?.frame = self.view.bounds
        //self.view.addSubview(customView!)
        
        let applicationDelegate = UIApplication.shared.delegate as? AppDelegate
        customView?.frame = (applicationDelegate?.window?.bounds)!
        applicationDelegate?.window?.addSubview(customView!)
    }
}

