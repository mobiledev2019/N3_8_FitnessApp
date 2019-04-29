//
//  Extension.swift
//  fulfii
//
//  Created by Vu Quang Dung on 10/22/18.
//  Copyright © 2018 日本グリーンパックス株式会社. All rights reserved.
//

import Foundation
import UIKit

// Extension color for app
extension UIColor {
    
    struct Custom {
        static let AppGreen = UIColor.init(hexValue: 0x20956B)
        static let AppLightRed = UIColor.init(hexValue: 0xf49999)
        static let AppGray = UIColor.init(hexValue: 0x95989A)
        static let AppFacebook = UIColor.init(hexValue: 0x3b5998)
        static let AppTwitter = UIColor.init(hexValue: 0x00aced)
        static let AppLine = UIColor.init(hexValue: 0x02b801)
        static let GrayContentView = UIColor.init(hexValue: 0xf8f8f8)
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hexValue: Int) {
        self.init(red:(hexValue >> 16) & 0xff, green:(hexValue >> 8) & 0xff, blue:hexValue & 0xff)
    }
    
    convenience init(hexa: String) {
        let hex = hexa.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    func alpha(_ value: CGFloat) -> UIColor {
        return self.withAlphaComponent(value)
    }
}

extension AppDelegate {
    
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var rootViewController: UIViewController? {
        return window!.rootViewController
    }
}

extension UINavigationController {
    var rootViewController : UIViewController? {
        return viewControllers.first
    }
}

extension UIViewController {
    
    //get view controller with storyboard identifier
    static func newControllerFromStoryboard(withStoryboardIdentifier storyboardIdentifier: String, storyboardName: String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: storyboardIdentifier)
    }
    
    //get view controller with storyboard identifier and navigation
    static func 
         newNavigationControllerFromStoryboard(withStoryboardIdentifier storyboardIdentifier: String, storyboardName: String) -> UINavigationController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: storyboardIdentifier)
        return UINavigationController(rootViewController: viewController)
    }
    
    /// setup color for navigation
    ///
    /// - Parameters:
    ///   - barTintColor: navigation background color
    ///   - tintColor: navigation item color
    func setupNavigationColor(barTintColor: UIColor, tintColor: UIColor) {
        
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = tintColor
        navigationBarAppearace.barTintColor = barTintColor
        //navigationBarAppearace.barStyle = .blackOpaque
        //navigationBarAppearace.isTranslucent = false
        
        navigationBarAppearace.titleTextAttributes = [NSAttributedString.Key.foregroundColor:tintColor]
    }
    
    func shouldRemoveShadow(_ value: Bool) -> Void {
        if value {
            self.navigationController?.navigationBar.shadowImage = UIImage()
        } else {
            self.navigationController?.navigationBar.shadowImage = nil
        }
    }
    
    func showProfileBarButton(imageURL: String, selector: Selector?) {
        
        let imageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 24, height: 24))
        imageView.roundViewWith(cornerRadius: 12)
        imageView.borderViewWith(borderWidth: 0.5, borderColor: UIColor.black)
        imageView.contentMode = .scaleAspectFill
//        imageView.imageFromUrl(urlString: imageURL, defaultImage: "ic_https_24px")
        
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: selector)
        singleTap.numberOfTapsRequired = 1;
        imageView.addGestureRecognizer(singleTap)
        
        let profileButton = UIBarButtonItem(customView: imageView)
        if #available(iOS 11.0, *) {
            let currWidth = profileButton.customView?.widthAnchor.constraint(equalToConstant: 24)
            currWidth?.isActive = true
            let currHeight = profileButton.customView?.heightAnchor.constraint(equalToConstant: 24)
            currHeight?.isActive = true
        }
        self.navigationItem.leftBarButtonItem = profileButton
    }
    
    func setupBackBarButtonItem() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"icArrowLeft"), style: .plain, target: self, action: #selector(popViewController))
    }
    
    func setupRightBarButton(image: UIImage, action: Selector?) {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: action)
    }
    
    @objc func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func dismissViewControllerWithAnimationBackButton(backButton: UIButton) {
        
        UIView.animate(withDuration: 0.3, animations: {
            backButton.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2))
        }) { _ in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    var hasTopNotch: Bool {
        
        if #available(iOS 11.0,  *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        
        return false
    }
    
}

extension UIImage {
    
    /// init uiimage with received color
    ///
    /// - Parameters:
    ///   - color: color
    ///   - size: size
//    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
//
//        let rect = CGRect(origin: .zero, size: size)
//        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
//        color.setFill()
//        UIRectFill(rect)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//
//        guard let cgImage = image?.cgImage else { return nil }
//        self.init(cgImage: cgImage)
//    }
    
    func compressTo(_ expectedSizeInMb: Double) -> Data? {
        
        let sizeInBytes = Int(expectedSizeInMb * 1024 * 1024)
        var needCompress:Bool = true
        var imgData:Data?
        var compressingValue:CGFloat = 1.0
        while (needCompress && compressingValue > 0.0) {
            if let data:Data = self.jpegData(compressionQuality: compressingValue) {
                if data.count < sizeInBytes {
                    needCompress = false
                    imgData = data
                } else {
                    compressingValue -= 0.1
                }
            }
        }
        
        if let data = imgData {
            if (data.count < sizeInBytes) {
                return data
            }
        }
        
        return nil
    }
    
}


extension UIView {
    
    func roundViewWith(cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
    }
    
    func borderViewWith(borderWidth: CGFloat, borderColor: UIColor) {
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
    
    func dropShadow(size: CGSize, opacity: Float, radius: CGFloat, color: CGColor) {
        self.layer.shadowOffset = size
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
        self.layer.shadowColor = color
        self.layer.masksToBounds = false
    }
}

extension String {
    
    func isValidEmail() -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
//    func isValidPassword() -> Bool {
//
//        if self.count < 6 || self.count > 16 {
//            return false
//        }
//
//        return true
//    }
    
    func isValidPasswordFormat() -> Bool {
        let passwordRegex = "^[a-zA-Z0-9@%+,/'!#$^?:.(){}\\[\\]~`-]+"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
    
    func isIncludCharacter() -> Bool {
        let passwordRegex = ".*[A-Za-z]+.*"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
    
    func isIncludeNumber() -> Bool {
        let passwordRegex = ".*[0-9]+.*"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
    
    func isValidNickname() -> Bool {
        
        if self.trim().count < 6 || self.trim().count > 30 {
            return false
        }
        
        return true
    }
    
    func trim() -> String {
        return  self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func attributedString(_ font: UIFont, color: UIColor) -> NSMutableAttributedString {
        
        let termConditionAttributed: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: color]
        return NSMutableAttributedString(string: self, attributes: termConditionAttributed)
    }
    
    func toDate(format: String = "yyyy-MM-dd") -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self) ?? ("1990-01-01").toDate()
    }
    
}



extension NSLocale {
    
    class func isJapanese() -> Bool {
        return self.preferredLanguages[0].range(of:"ja") != nil
    }
    
    class func isEnglish() -> Bool {
        return self.preferredLanguages[0].range(of:"en") != nil
    }
    
    class func isVietnamese() -> Bool {
        return self.preferredLanguages[0].range(of:"vi") != nil
    }
}

extension Date {
    func toString(format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func toStringForLanguage() -> String {
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        
        var format = ""
        if NSLocale.isJapanese() {
            format = "yyyy年MM月dd日"
        } else if NSLocale.isVietnamese(){
            format = "dd/MM/yyyy"
        } else {
            format = "dd MMMM yyyy"
        }
        
        formatter.dateFormat = format
        return formatter.string(from: self)
        
    }
    
    
    /// Returns a Date with the specified amount of components added to the one it is called with
    func add(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date? {
        let components = DateComponents(year: years, month: months, day: days, hour: hours, minute: minutes, second: seconds)
        return Calendar.current.date(byAdding: components, to: self)
    }
    
    /// Returns a Date with the specified amount of components subtracted from the one it is called with
    func subtract(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date? {
        return add(years: -years, months: -months, days: -days, hours: -hours, minutes: -minutes, seconds: -seconds)
    }
}

extension UIDevice {
    
    var isIPhone5SizeBelow: Bool {
        return UIScreen.main.nativeBounds.height <= 1136
    }
}
