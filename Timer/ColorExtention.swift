//
//  ColorExtention.swift
//  tempapp
//
//  Created by Jake O´Donnell on 2018-11-29.
//  Copyright © 2018 Jake O´Donnell. All rights reserved.
//

import UIKit

extension UIColor {
    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
    static let bluebackground = UIColor.rgb(r: 21, g: 22, b: 33)
    static let backgroundColorTwo = UIColor.rgb(r: 21, g: 22, b: 100)
    static let outlineStrokeColor = UIColor.rgb(r: 234, g: 46, b: 111)
    static let highTempPulsatingInner = UIColor.rgb(r: 56, g: 25, b: 49)
    static let highTempPulsating = UIColor.rgb(r: 86, g: 30, b: 63)
    static let lowTempPulsating = UIColor.rgb(r: 0, g: 100 , b: 0)
    static let lowTempPulsatingInner = UIColor.rgb(r: 0, g: 70 , b: 0)
    static let grayBackground = UIColor.rgb(r:128,g:130,b:133)
}
