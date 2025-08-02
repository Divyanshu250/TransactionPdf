//
//  AppColors.swift
//  PDFReport
//
//  Created by Divyanshu Jadon on 02/08/25.
//

import UIKit

enum Colors: String {
    var color: UIColor {
        return UIColor.colorWith(hexString: self.rawValue)
    }
    
    case backGroundColor = "#FBF8F3"
    case blackColor = "#000000"
    case greyColor = "#D9D9D9"
    case lightGreyColor  = "#F3F0FA"
    
}

extension UIColor {
    class func colorWith(hexString: String, alpha: CGFloat = 1.0) -> UIColor {
        var cString = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        guard cString.count == 6 else {
            return UIColor.gray
        }

        var rgbValue: UInt64 = 0
        let scanner = Scanner(string: cString)
        guard scanner.scanHexInt64(&rgbValue) else {
            return UIColor.gray
        }

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}

extension String {
    var length: Int {
        get {
            return self.count
        }
    }
}

