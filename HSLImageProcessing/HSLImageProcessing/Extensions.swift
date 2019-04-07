//
//  Extensions.swift
//  HSLImageProcessing
//
//  Created by 1 on 03.04.2019.
//  Copyright © 2019 azharkova. All rights reserved.
//

import Foundation
import UIKit
import CoreImage


extension UIColor
{
    convenience  init(hue: CGFloat) {
        let correctHue = hue < 0 ? 1 + hue : hue 
        self.init(hue: correctHue, saturation: 1, lightness: 0.5)
    }
    convenience init(hue: CGFloat, saturation: CGFloat, lightness: CGFloat, alpha: CGFloat = 1)  {
        let offset = saturation * (lightness < 0.5 ? lightness : 1 - lightness)
        let brightness = lightness + offset
        let saturation = lightness > 0 ? 2 * offset / brightness : 0
        self.init(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
    func lighter(lum: CGFloat)-> UIColor? {
        return applying(lightness: lum)
    }
    
    func applying(lightness value: CGFloat) -> UIColor? {
        guard let hsl = hsl else { return nil }
        return UIColor(hue: hsl.hue, saturation: hsl.saturation, lightness: hsl.lightness, alpha: hsl.alpha)
    }
    var hsl: (hue: CGFloat, saturation: CGFloat, lightness: CGFloat, alpha: CGFloat)? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0, hue: CGFloat = 0
        guard
            getRed(&red, green: &green, blue: &blue, alpha: &alpha),
            getHue(&hue, saturation: nil, brightness: nil, alpha: nil)
            else { return nil }
        let upper = max(red, green, blue)
        let lower = min(red, green, blue)
        let range = upper - lower
        let lightness = (upper + lower) / 2
        let saturation = range == 0 ? 0 : range / (lightness < 0.5 ? lightness * 2 : 2 - lightness * 2)
        return (hue, saturation, lightness, alpha)
    }
    
   func hslColor(hue: CGFloat, sat: CGFloat, lum: CGFloat)->UIColor {
        
        return UIColor(hue: hue, saturation: sat, lightness: lum, alpha: 1.0)
    }
    
   func hslColor()->UIColor {
        if  let hsl = hsl {
            return hslColor(hue: hsl.hue, sat: hsl.saturation, lum: hsl.lightness)} else {
        return self
    }
    }
    
    func hslColor(hue: CGFloat)->UIColor {
        if  let hsl = hsl {
            return hslColor(hue: hue, sat: hsl.saturation, lum: hsl.lightness)} else {
            return self
        }
    }
    
    func hslColor(lum: CGFloat)->UIColor {
        if  let hsl = hsl {
            return hslColor(hue: hsl.hue, sat: hsl.saturation, lum: lum)} else {
            return self
        }
    }
    
    func hsb()->(CGFloat,CGFloat,CGFloat){
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        self.getHue(&hue,
                    saturation: &saturation,
                    brightness: &brightness,
                    alpha: &alpha)
        
        return (hue,saturation,brightness)
    }
    
    func hue()-> CGFloat
    {
        return hsb().0
    }
    
    func saturation()->CGFloat{
        return hsb().1
    }
    
    func brightness()->CGFloat {
        return hsb().2
    }
    
    
    func createColorSet()->[CGColor]{
       
        let hsb = self.hsb()
        
        return createColorSet(lum: hsb.2)
    }
    
    func normalizeHue(shift: CGFloat)->CGFloat {
        let currentHue = self.hue() + shift
        let normalizedHue = currentHue < 0 ? currentHue + 1.0 : currentHue > 1 ? (currentHue - 1.0) : currentHue
        return normalizedHue
    }
    
    func createColorSet(lum: CGFloat)->[CGColor]{
        
        let hsb = self.hsb()
        var colors=[CGColor]()
        let step = 30
        for var _ch in -90..<90 {
            let currentHue = CGFloat(_ch)/360.0
            let normalizedHue = normalizeHue(shift: currentHue)
            
            let color = UIColor(hue: normalizedHue, saturation: hsb.1, brightness: lum, alpha: 1)
            colors.append(color.cgColor)
            _ch += step
        }
        return colors
    }
    
    func colorWithSat(sat: CGFloat)->UIColor {
        let hsb = self.hsb()
        return UIColor(hue: hsb.0, saturation: sat, brightness: hsb.2, alpha: 1)
    }
    
    func colorWithLum(lum: CGFloat)->UIColor {
        return hslColor(lum:lum)
    }
    
    func createAlphaSet()->[CGColor] {
        return [self.withAlphaComponent(1.0).cgColor,self.withAlphaComponent(0.5).cgColor,self.withAlphaComponent(0.1).cgColor]
    }
    
    func createLumSet()->[CGColor] {
        return [self.colorWithLum(lum: 0.3).cgColor,
                self.colorWithLum(lum: 0.5).cgColor,
                self.colorWithLum(lum: 0.7).cgColor]
    }
    
    var colorGroup:Colors {
        get {
         let hue = self.hue()
           return hue.colorForHue()
        }
    }
    
   
}

extension UIView{
    static func createGradient(size: CGSize, colorSet: [CGColor])->CAGradientLayer {
        let tgl = CAGradientLayer()
        tgl.frame = CGRect.init(x:0, y:0, width:size.width, height: size.height)
        tgl.cornerRadius = tgl.frame.height / 2
        tgl.masksToBounds = false
        tgl.colors = colorSet
        tgl.startPoint = CGPoint.init(x:0.0, y:0)
        tgl.endPoint = CGPoint.init(x:1, y:0)
        return tgl
    }
}

extension Int{
    func pxToDp()->CGFloat {
        return CGFloat(self)/UIScreen.main.scale
    }
    func dpToPx()->CGFloat {
        return CGFloat(self)*UIScreen.main.scale
    }
}

extension UIImage {
  static  func gradientImage(size: CGSize, colorSet: [CGColor]) -> UIImage? {
        let tgl = UIView.createGradient(size: size, colorSet: colorSet)
        
        UIGraphicsBeginImageContextWithOptions(size, tgl.isOpaque, 0.0);
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        tgl.render(in: context)
        let image =
            
            UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets:
                UIEdgeInsets.init(top: 0, left: size.height, bottom: 0, right: size.height))
        UIGraphicsEndImageContext()
        return image
    }
    
    func resize(targetSize: CGSize) -> UIImage {
        let image = self
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        var newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func scale(scale: CGFloat) -> UIImage? {
        let image = self
        let size = image.size
        let scaledSize = CGSize(width: size.width * scale, height: size.height * scale)
        return image.resize(targetSize: scaledSize)
    }
}
