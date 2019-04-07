//
//  ColorHelper.swift
//  HSLImageProcessing
//
//  Created by 1 on 06.04.2019.
//  Copyright © 2019 azharkova. All rights reserved.
//

import Foundation
import UIKit

class ColorUtility{
    static let red = UIColor.red
    static let orange = UIColor(red: 0.901961, green: 0.584314, blue: 0.270588, alpha: 1)
    static let yellow = UIColor(red: 0.901961, green: 0.901961, blue: 0.270588, alpha: 1)
    static let green = UIColor(red: 0.270588, green: 0.901961, blue: 0.270588, alpha: 1)
    static let aqua = UIColor(red: 0.270588, green: 0.901961, blue: 0.901961, alpha: 1)
    static let blue = UIColor(red: 0.270588, green: 0.270588, blue: 0.901961, alpha: 1)
   static let purple = UIColor(red: 0.584314, green: 0.270588, blue: 0.901961, alpha: 1)
   static let magenta = UIColor(red: 0.901961, green: 0.270588, blue: 0.901961, alpha: 1)

}

enum Colors : CGFloat{
    case red, orange, yellow, green, aqua, blue, purple, magenta
}

extension Colors {
    var hue: CGFloat {
        get {
         return self.getColor().hue()
        }
    }
    
    func getColor()->UIColor {
        switch (self) {
        case .red:
            return ColorUtility.red
        case .orange:
            return ColorUtility.orange
        case .yellow:
            return ColorUtility.yellow
        case .green:
            return ColorUtility.green
        case .aqua:
            return ColorUtility.aqua
        case .blue:
            return ColorUtility.blue
        case .purple:
            return ColorUtility.purple
        case .magenta:
            return ColorUtility.magenta
        }
    }
    
}

extension CGFloat {
    func colorForHue()->Colors{
        let step:CGFloat = 15/360.0
        let correctHue = self < 0 ? 1 + self : self
        switch(correctHue){
        case Colors.magenta.hue+step..<1.0, Colors.red.hue..<Colors.orange.hue:
            return .red
        case Colors.orange.hue..<Colors.orange.hue+step/2:
            return .orange
        case Colors.yellow.hue-step/2..<Colors.green.hue-step:
            return .yellow
        case Colors.green.hue-step..<Colors.aqua.hue - step:
            return .green
        case Colors.aqua.hue-step..<Colors.blue.hue-step:
            return .aqua
        case Colors.blue.hue-step..<Colors.purple.hue-step/2:
            return .blue
        case Colors.purple.hue-step/2..<Colors.magenta.hue-step/2:
            return .purple
        case Colors.magenta.hue-step/2..<Colors.magenta.hue+step:
            return .magenta
        default:
            return .red
        }
    }
}
