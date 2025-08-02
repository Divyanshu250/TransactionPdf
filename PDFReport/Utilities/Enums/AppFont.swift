//
//  AppFont.swift
//  PDFReport
//
//  Created by Divyanshu Jadon on 02/08/25.
//

import UIKit

enum FontFamily:String {
    case monaSansMedium = "Mona-Sans-Medium"
    case monaSansSemiBold = "Mona-Sans-SemiBold"
    case monaSansBold = "Mona-Sans-Bold"
    case monaSansLight = "Mona-Sans-Light"
    case monaSansRegular = "Mona-Sans-Regular"
    case monaSansRegularItalic = "Mona-Sans-RegularItalic"
}

enum FontSize:CGFloat {
    case size10 = 10
    case size11 = 11
    case size12 = 12
    case size15 =  15
    case size14 =  14
    case size16 =  16
    case size17 =  17
    case size18 =  18
    case size19 = 19
    case size20 = 20
    case size23 = 23
    case size24 = 24 //
    case size26 = 26
    case size28 = 28
    case size32 = 32
    case size34 = 34
    case size40 = 40
    case size22 = 22
    case size60 = 60
    case size64 = 64
    case size30 = 30
    case size45 = 45
}

extension UIFont {
    static func customFont(family: FontFamily, size: FontSize) -> UIFont {
        guard let font = UIFont(name: family.rawValue, size: size.rawValue) else {
            fatalError("Custom font not found")
        }
        return font
    }
}
