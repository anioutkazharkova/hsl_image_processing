//
//  ColorFilter.swift
//  HSLImageProcessing
//
//  Created by 1 on 07.04.2019.
//  Copyright © 2019 azharkova. All rights reserved.
//

import Foundation
import  UIKit

class ColorFilter {

    static let maxHue: CGFloat = 360.0
    static let step: CGFloat = 15/360.0
    static let lumDiv: CGFloat = 100.0
    static let lumStart: CGFloat = 50.0
    static let lumMin: CGFloat = 20.0
    static let lumMax: CGFloat = 80.0

    var defaultColor: Colors
    var selectedHue: CGFloat = CGFloat(0)
    var selectedSat: CGFloat = CGFloat(1)
    var selectedLum: CGFloat = CGFloat(ColorFilter.lumStart)

    var shift: CIVector {
        get {
            return CIVector(x: (selectedHue/ColorFilter.maxHue)*0.5, y: selectedSat,
                            z: normalizeLum)
        }
    }

    var normalizeLum: CGFloat {
        if (selectedLum > ColorFilter.lumStart) {
          return  1.0 + (selectedLum - ColorFilter.lumStart)/(ColorFilter.lumDiv)*0.5
        } else {
            return 1.0 - (ColorFilter.lumStart - selectedLum)/(ColorFilter.lumDiv)*0.5
        }
    }

    init(color: Colors) {
        self.defaultColor = color
    }

}
