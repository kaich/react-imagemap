//
//  UIColorExtension.swift
//  AMPopTip
//
//  Created by mk on 2017/12/2.
//

import Foundation

import UIKit
extension UIColor {
    class func hexrgbAlpha(_ rgbValue: String,alpha: CGFloat) -> UIColor {
        let t = UIColor.hexTorgb(rgbValue, alpha: alpha)
        return UIColor(red: t[0], green: t[1], blue: t[2], alpha: t[3])
    }
    
    class func hexTorgb(_ rgbValue: String,alpha: CGFloat) -> [CGFloat] {
        var  Str :NSString = rgbValue.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) as NSString
        if rgbValue.hasPrefix("0x"){
            Str=(rgbValue as NSString).substring(from: 2) as NSString
        }else if rgbValue.hasPrefix("#"){
            Str=(rgbValue as NSString).substring(from: 1) as NSString
        }else{
            return [0, 0, 0, 0]
        }
        if Str.length != 6 {
            return [0, 0, 0, 0]
        }
        let red = (Str as NSString ).substring(to: 2)
        let green = ((Str as NSString).substring(from: 2) as NSString).substring(to: 2)
        let blue = ((Str as NSString).substring(from: 4) as NSString).substring(to: 2)
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string:red).scanHexInt32(&r)
        Scanner(string: green).scanHexInt32(&g)
        Scanner(string: blue).scanHexInt32(&b)
        return [CGFloat(r)/255.0, CGFloat(g)/255.0, CGFloat(b)/255.0, alpha]
    }
    
    func rgbString(_ rgbValue: String) -> UIColor
    {
        let colorAry:Array = rgbValue.components(separatedBy: ",")
        var r:Int = 0, g:Int = 0, b:Int = 0;
        Scanner(string:colorAry[0]).scanInt(&r)
        Scanner(string: colorAry[1]).scanInt(&g)
        Scanner(string: colorAry[2]).scanInt(&b)
        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1)
    }
    func rgbString(_ rgbValue: String, alpha: CGFloat) -> UIColor
    {
        let colorAry:Array = rgbValue.components(separatedBy: ",")
        var r:Int = 0, g:Int = 0, b:Int = 0;
        Scanner(string:colorAry[0]).scanInt(&r)
        Scanner(string: colorAry[1]).scanInt(&g)
        Scanner(string: colorAry[2]).scanInt(&b)
        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: alpha)
    }
    class func hexrgb(_ rgbValue: String) -> UIColor {
        
        return hexrgbAlpha(rgbValue, alpha: 1)
    }
    
    func hexrgbAlpha(_ rgbValue: String,alpha: CGFloat) -> UIColor {
        return UIColor.hexrgbAlpha(rgbValue, alpha: alpha)
    }
    
    func hexrgb(_ rgbValue: String) -> UIColor {
        return hexrgbAlpha(rgbValue, alpha: 1)
    }
}
