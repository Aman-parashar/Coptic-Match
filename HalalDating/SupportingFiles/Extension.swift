//
//  Extension.swift
//  BeeCrops
//
//  Created by Maulik Vinodbhai Vora on 24/07/19.
//  Copyright © 2019 Maulik Vora. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController {
    func Logout(){
        let logoutAlert = UIAlertController(title: kAlertTitle, message: "Your session has timed out.", preferredStyle: UIAlertController.Style.alert)
        logoutAlert.addAction(UIAlertAction(title: "Ok".localizableString(lang: Helper.shared.strLanguage), style: .default, handler: { (action: UIAlertAction!) in
            
            //--
            AppHelper.removeAllNsUserDefault()
            
            //--
            //let vc = objMainSB.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            //let appDelegate = UIApplication.shared.delegate as! AppDelegate
            //appDelegate.window?.rootViewController = UINavigationController.init(rootViewController: vc)
            //appDelegate.window?.makeKeyAndVisible()
        }))
        
        //        logoutAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
        //            print("Handle Cancel Logic here")
        //        }))
        
        self.present(logoutAlert, animated: true, completion: nil)
    }
}

extension Double {
    
    private var formatter: DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }
    
    func secondsToString() -> String {
        return formatter.string(from: self) ?? ""
    }
    
}


extension UIWindow {
func topViewController() -> UIViewController? {
    var top = self.rootViewController
    while true {
        if let presented = top?.presentedViewController {
            top = presented
        } else if let nav = top as? UINavigationController {
            top = nav.visibleViewController
        } else if let tab = top as? UITabBarController {
            top = tab.selectedViewController
        } else {
            break
        }
    }
    return top
}
}


extension String {
    // 2) ascii array to map our string
    var asciiArray: [UInt32] {
        return unicodeScalars.filter{$0.isASCII}.map{$0.value}
    }

    // this is our hashCode function, which produces equal output to the Java or Android hash function
    func hashCode() -> Int32 {
        var h : Int32 = 0
        for i in self.asciiArray {
            h = 31 &* h &+ Int32(i) // Be aware of overflow operators,
        }
        return h
    }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 1.0)
    }
}

extension UIView {
    /* Usage Example
     * bgView.addBottomRoundedEdge(desiredCurve: 1.5)
     */
    func addBottomRoundedEdge(desiredCurve: CGFloat?) {
        let offset: CGFloat = self.frame.width / desiredCurve!
        let bounds: CGRect = self.bounds
        
        let rectBounds: CGRect = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.size.width, height: bounds.size.height / 2)
        let rectPath: UIBezierPath = UIBezierPath(rect: rectBounds)
        let ovalBounds: CGRect = CGRect(x: bounds.origin.x - offset / 2, y: bounds.origin.y, width: bounds.size.width + offset, height: bounds.size.height)
        let ovalPath: UIBezierPath = UIBezierPath(ovalIn: ovalBounds)
        rectPath.append(ovalPath)
        
        // Create the shape layer and set its path
        let maskLayer: CAShapeLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = rectPath.cgPath
        
        // Set the newly created shape layer as the mask for the view's layer
        self.layer.mask = maskLayer
    }
    
    
    //-- CAGradientLayer background
    func applyGradient(colours: [UIColor]) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = [0,0.5]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.layer.insertSublayer(gradient, at: 0)
        
       // self.applyGradient(colours: colours, locations: [0,0.5])
    }
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> Void {
        
    }
    
    //-- border
    func applyGradient_border(cgSize: CGSize, cgRect:CGRect, cornerRadious:CGFloat,borderWidth:CGFloat, colors:[CGColor]) -> Void {
        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(origin: CGPoint.zero, size: cgSize)
        gradient.colors = colors//[DatingColor.red.cgColor, DatingColor.orrange.cgColor]
        gradient.cornerRadius = cornerRadious
        gradient.locations = [0,0.5]
        
        
        let shape = CAShapeLayer()
        shape.lineWidth = borderWidth
        shape.strokeColor = UIColor.white.cgColor
        shape.fillColor = UIColor.clear.cgColor
        shape.path = UIBezierPath(roundedRect: cgRect, cornerRadius: cornerRadious).cgPath
        gradient.mask = shape
        
        self.layer.addSublayer(gradient)
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }

    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}

extension Date {
    var ticks: UInt64 {
        return UInt64(self.timeIntervalSince1970)
    }
}


extension Date {
    
    func getElapsedInterval() -> String {
        
        let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self, to: Date())
        
        if let year = interval.year, year > 0 {
            return year == 1 ? "\(year)" + " " + "year" :
                "\(year)" + " " + "years"
        } else if let month = interval.month, month > 0 {
            return month == 1 ? "\(month)" + " " + "month" :
                "\(month)" + " " + "months"
        } else if let day = interval.day, day > 0 {
            return day == 1 ? "\(day)" + " " + "day" :
                "\(day)" + " " + "days"
        } else if let hour = interval.hour, hour > 0 {
            return hour == 1 ? "\(hour)" + " " + "hour" :
                "\(hour)" + " " + "hours"
        } else if let minute = interval.minute, minute > 0 {
            return minute == 1 ? "\(minute)" + " " + "minute" :
                "\(minute)" + " " + "minutes"
        } else if let second = interval.second, second > 0 {
            return second == 1 ? "\(second)" + " " + "second" :
                "\(second)" + " " + "seconds"
        } else {
            return "a moment"
            
        }
        
    }
}
extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
}

extension UIImage {

    func imageWithColor(color: UIColor) -> UIImage {
           UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
           color.setFill()

           let context = UIGraphicsGetCurrentContext()
           context?.translateBy(x: 0, y: self.size.height)
           context?.scaleBy(x: 1.0, y: -1.0)
           context?.setBlendMode(CGBlendMode.normal)

           let rect = CGRect(origin: .zero, size: CGSize(width: self.size.width, height: self.size.height))
           context?.clip(to: rect, mask: self.cgImage!)
           context?.fill(rect)

           let newImage = UIGraphicsGetImageFromCurrentImageContext()
           UIGraphicsEndImageContext()

           return newImage!
       }
}
extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }

        assert(hexFormatted.count == 6, "Invalid hex code used.")

        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)

        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }

}


protocol Bluring {
    func addBlur(_ alpha: CGFloat)
}

extension Bluring where Self: UIView {
    func addBlur(_ alpha: CGFloat = 0.1) {
        // create effect
        let effect = UIBlurEffect(style: .dark)
        let effectView = UIVisualEffectView(effect: effect)

        // set boundry and alpha
        effectView.frame = self.bounds
        effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        effectView.alpha = alpha

        self.addSubview(effectView)
    }
    func unBlur() {
        // create effect
        for subview in self.subviews {
        if subview is UIVisualEffectView {
            subview.removeFromSuperview()
        }
    }
    }
    
}

// Conformance
extension UIView: Bluring {}

extension String {
    var isSingleEmoji: Bool {
        return count == 1 && containsEmoji
    }

    var containsEmoji: Bool {
        return contains { $0.isEmoji }
    }

    var containsOnlyEmoji: Bool {
        return !isEmpty && !contains { !$0.isEmoji }
    }

    var emojiString: String {
        return emojis.map { String($0) }.reduce("", +)
    }

    var emojis: [Character] {
        return filter { $0.isEmoji }
    }

    var emojiScalars: [UnicodeScalar] {
        return filter{ $0.isEmoji }.flatMap { $0.unicodeScalars }
    }
}

//MARK: Character

extension Character {
    /// A simple emoji is one scalar and presented to the user as an Emoji
    var isSimpleEmoji: Bool {
        guard let firstProperties = unicodeScalars.first?.properties else {
            return false
        }
        return unicodeScalars.count == 1 &&
            (firstProperties.isEmojiPresentation ||
                firstProperties.generalCategory == .otherSymbol)
    }

    /// Checks if the scalars will be merged into an emoji
    var isCombinedIntoEmoji: Bool {
        return (unicodeScalars.count > 1 &&
               unicodeScalars.contains { $0.properties.isJoinControl || $0.properties.isVariationSelector })
            || unicodeScalars.allSatisfy({ $0.properties.isEmojiPresentation })
    }

    var isEmoji: Bool {
        return isSimpleEmoji || isCombinedIntoEmoji
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension String {
    
    var isValidPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
}

extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }

}
extension String {
    
    func localizableString(lang:String) -> String {
        
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")!
        let bundle = Bundle(path: path)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}

extension NSObject {
  var className: String {
    return String(describing: type(of: self))
  }

  class var className: String {
    return String(describing: self)
  }
}



