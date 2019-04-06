//
//  ColorHelper.swift
//  HSLImageProcessing
//
//  Created by 1 on 06.04.2019.
//  Copyright © 2019 azharkova. All rights reserved.
//

import Foundation
import UIKit

class ColorHelper{
    static let red = UIColor.red
    static let orange = UIColor(red: 0.901961, green: 0.584314, blue: 0.270588, alpha: 1)
    static let yellow = UIColor(red: 0.901961, green: 0.901961, blue: 0.270588, alpha: 1)
    static let green = UIColor(red: 0.270588, green: 0.901961, blue: 0.270588, alpha: 1)
    static let aqua = UIColor(red: 0.270588, green: 0.901961, blue: 0.901961, alpha: 1)
    static let blue = UIColor(red: 0.270588, green: 0.270588, blue: 0.901961, alpha: 1)
   static let purple = UIColor(red: 0.584314, green: 0.270588, blue: 0.901961, alpha: 1)
   static let magenta = UIColor(red: 0.901961, green: 0.270588, blue: 0.901961, alpha: 1)
}

enum Colors : String{
    case red, orange, yellow, green, aqua, blue, purple, magenta
    
    func getColor()->UIColor {
        switch (self) {
        case .red:
            return ColorHelper.red
        case .orange:
            return ColorHelper.orange
        case .yellow:
            return ColorHelper.yellow
        case .green:
            return ColorHelper.green
        case .aqua:
            return ColorHelper.aqua
        case .blue:
            return ColorHelper.blue
        case .purple:
            return ColorHelper.purple
        case .magenta:
            return ColorHelper.magenta
        }
    }
}
