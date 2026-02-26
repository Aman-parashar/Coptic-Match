//
//  Helper.swift
//  Chat
//
//  Created by Apple on 13/10/22.
//

import UIKit
import QuickbloxWebRTC
import Quickblox

class Helper: NSObject {

    static let shared = Helper()
    
    var google_clientID = "730670905873-tne2nq6csvac5mmj4trqsfd0v8l81k72.apps.googleusercontent.com"
    
    var strLanguage = "en"
    
    var strUserPhone = ""
    var email = ""
    
    var isSubscriptionActive = ""
    var currentCountry = ""
    
    func getStringFromDate(fromFormat:String, toFormat:String, date:Date) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = fromFormat

        let myString = formatter.string(from: date) // string purpose I add here
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = toFormat
        return formatter.string(from: yourDate!)

    }
    
    func changeDateFormat(fromFormat:String, toFormat:String, date:String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = toFormat
        return dateFormatter.string(from: date!)
    }
    
    func isValidContact(testStr:String) -> Bool {
        let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: self)
    }
    
    func getUnreadMsgCount(completion:@escaping (Int)->()) {
        //EDIT
//        QBRequest.totalUnreadMessageCountForDialogs(withIDs: [], successBlock: { ( response, totalUnreadCount, dialogsDictionary) in
//
//            completion(Int(totalUnreadCount))
//        }, errorBlock: { (response) in
            
            completion(0)
        //})
        
    }
    func setUnreadMsgCount(vc:UIViewController) {
        
        if let tabItems = vc.tabBarController?.tabBar.items {
            let tabItem = tabItems[2]
            
            self.getUnreadMsgCount { count in
                
                if count == 0 {
                    tabItem.badgeValue = nil
                } else {
                    tabItem.badgeValue = "\(count)"
                }
            }
            
            
        }
    }
    
    func getCurrentDateGMT()->Date {
        
        //get current date time
        let UTCDate = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
        let defaultTimeZoneStr = formatter.string(from: UTCDate)
        
        //
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
        return dateFormatter.date(from:defaultTimeZoneStr)!
    }
    
    
//    
//    func timeAgoSinceDate(_ dateString: String) -> String {
//        // Define the date formatter to handle the full date format including microseconds and "Z"
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0) // Parse as UTC
//        
//        // Convert the string to a Date object
//        guard let date = dateFormatter.date(from: dateString) else { return "Invalid Date" }
//        
//        let now = Date()
//        let calendar = Calendar.current
//        
//        // Get the difference in components between the current time and the input date
//        let components = calendar.dateComponents([.minute, .hour, .day, .weekOfYear, .month, .year], from: date, to: now)
//        
//        // Define the time ago logic checking larger units first
//        if let year = components.year, year >= 1 {
//            if let month = components.month, month >= 1 {
//                let monthName = DateFormatter().monthSymbols[calendar.component(.month, from: date) - 1]
//                return "\(monthName) \(calendar.component(.year, from: date))"
//            }
//        } else if let month = components.month, month >= 1 {
//            let monthName = DateFormatter().monthSymbols[calendar.component(.month, from: date) - 1]
//            return monthName
//        } else if let week = components.weekOfYear, week >= 1 {
//            return "\(week) week\(week == 1 ? "" : "s") ago"
//        } else if let day = components.day, day >= 2 {
//            return "\(day) days ago"
//        } else if let day = components.day, day == 1 {
//            return "Yesterday"
//        } else if let hour = components.hour, hour >= 1 {
//            return "\(hour) hour\(hour == 1 ? "" : "s") ago"
//        } else if let minute = components.minute, minute >= 1 {
//            return "\(minute) minute\(minute == 1 ? "" : "s") ago"
//        } else {
//            return "Now"
//        }
//        
//        return "Unknown"
//    }
    
    
//    func timeAgoSinceDate(_ dateString: String) -> String {
//        // Define the date formatter to handle the full date format including microseconds and "Z"
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0) // Parse as UTC
//        
//        // Convert the string to a Date object
//        guard let date = dateFormatter.date(from: dateString) else { return "Invalid Date" }
//        
//        let now = Date()
//        let calendar = Calendar.current
//        
//        // Get the difference in components between the current time and the input date
//        let components = calendar.dateComponents([.minute, .hour, .day, .month, .year], from: date, to: now)
//        
//        // Check if the date is later than yesterday
//        if let day = components.day, day >= 1 {
//            let monthName = DateFormatter().monthSymbols[calendar.component(.month, from: date) - 1]
//            let year = calendar.component(.year, from: date)
//            return "\(calendar.component(.day, from: date)) \(monthName) \(year)"
//        }
//
//        // Define the time ago logic checking larger units first
//        if let year = components.year, year >= 1 {
//            let monthName = DateFormatter().monthSymbols[calendar.component(.month, from: date) - 1]
//            return "\(calendar.component(.day, from: date)) \(monthName) \(calendar.component(.year, from: date))"
//        } else if let month = components.month, month >= 1 {
//            let monthName = DateFormatter().monthSymbols[calendar.component(.month, from: date) - 1]
//            return "\(calendar.component(.day, from: date)) \(monthName) \(calendar.component(.year, from: date))"
//        } else if let day = components.day, day == 1 {
//            return "Yesterday"
//        } else if let hour = components.hour, hour >= 1 {
//            return "\(hour) hour\(hour == 1 ? "" : "s") ago"
//        } else if let minute = components.minute, minute >= 1 {
//            return "\(minute) minute\(minute == 1 ? "" : "s") ago"
//        } else {
//            return "Now"
//        }
//        
//        return "Unknown"
//    }
    
    func timeAgoSinceDate(_ dateString: String) -> String {
        let formats = [
            "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ",
            "yyyy-MM-dd'T'HH:mm:ss.SSSSSZ",
            "yyyy-MM-dd'T'HH:mm:ssZ",
            "yyyy-MM-dd HH:mm:ss"
        ]
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        var parsedDate: Date?
        for format in formats {
            dateFormatter.dateFormat = format
            if let date = dateFormatter.date(from: dateString) {
                parsedDate = date
                break
            }
        }
        
        guard let date = parsedDate else { return "" }
        
        let now = Date()
        let calendar = Calendar.current
        
        // Check if the date is today
        if calendar.isDateInToday(date) {
            return "Today"
        }
        
        // Get the difference in components between the current time and the input date
        let components = calendar.dateComponents([.minute, .hour, .day, .month, .year], from: date, to: now)
        
        // Check if the date is earlier than today
        if let day = components.day, day >= 1 {
            let monthName = DateFormatter().monthSymbols[calendar.component(.month, from: date) - 1]
            let year = calendar.component(.year, from: date)
            return "\(calendar.component(.day, from: date)) \(monthName) \(year)"
        }
        
        // Define the time ago logic checking larger units first
        if let year = components.year, year >= 1 {
            let monthName = DateFormatter().monthSymbols[calendar.component(.month, from: date) - 1]
            return "\(calendar.component(.day, from: date)) \(monthName) \(calendar.component(.year, from: date))"
        } else if let month = components.month, month >= 1 {
            let monthName = DateFormatter().monthSymbols[calendar.component(.month, from: date) - 1]
            return "\(calendar.component(.day, from: date)) \(monthName) \(calendar.component(.year, from: date))"
        } else if let day = components.day, day == 1 {
            return "Yesterday"
        } else {
            return ""
        }
    }

    func isSmallDevice() -> Bool {
        // Get the screen height
        let screenHeight = UIScreen.main.bounds.height
        
        // Check if the device is small based on common heights of small devices
        if screenHeight <= 667 {
            // This includes iPhone SE (2020 and 2022), iPhone 8, iPhone 7, etc.
            return true
        } else {
            // For larger devices like iPhone 11, 12, XR, 13 Pro, etc.
            return false
        }
    }

        
}
