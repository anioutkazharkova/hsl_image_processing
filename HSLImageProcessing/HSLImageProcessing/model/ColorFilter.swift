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
    var selectedLum: CGFloat = CGFloat(0.5)
    
    init(color: Colors) {
        self.defaultColor = color
    }
}
