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
    var defaultColor: Colors
    var selectedHue: CGFloat = CGFloat(0)
    var selectedSat: CGFloat = CGFloat(1)
    var selectedLum: CGFloat = CGFloat(1)
    
    var shift:CIVector {
        get {
            return CIVector(x: selectedHue/360.0, y: selectedSat,z: 1)
        }
    }
    
    init(color: Colors) {
        self.defaultColor = color
    }
    
}
