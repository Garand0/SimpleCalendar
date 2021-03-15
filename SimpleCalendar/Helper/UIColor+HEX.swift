// UIColor+HEX.swift
// Copyright © PJSC Bank Otkritie. All rights reserved.

import UIKit

extension UIColor {
    public convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    public convenience init(netHex: Int) {
        self.init(red: (netHex >> 16) & 0xFF, green: (netHex >> 8) & 0xFF, blue: netHex & 0xFF)
    }

    public convenience init(_ hexString: String) {
        var hexString = hexString.replacingOccurrences(of: "#", with: "")
        let maxChars = 6

        if hexString.count > maxChars {
            let index = hexString.index(hexString.startIndex, offsetBy: maxChars)
            hexString = String(hexString[hexString.startIndex ..< index])
        }

        self.init(netHex: Int(strtoul(hexString, nil, 16)))
    }

    public var hexString: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        getRed(&r, green: &g, blue: &b, alpha: &a)

        let rgb: Int = (Int)(r * 255) << 16 | (Int)(g * 255) << 8 | (Int)(b * 255) << 0

        return String(format: "#%06x", rgb)
    }
}
