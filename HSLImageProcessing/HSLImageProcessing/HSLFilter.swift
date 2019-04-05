//
//  HSLFilter.swift
//  HSLImageProcessing
//
//  Created by 1 on 05.04.2019.
//  Copyright © 2019 azharkova. All rights reserved.
//

import UIKit

class HSLFilter: CIFilter {
    let dif = CGFloat(60/360.0)
    private var leftColor = CGFloat(0)
    private var rightColor = CGFloat(0)
    private var filterColor = CGFloat(0)
    private var sense = 1.0*0.15
    private var shift = CGFloat(0)
    
   var inputImage: CIImage?
    
    override var outputImage: CIImage!
    {
        let hslData = Bundle.main.path(forResource: "hsl_custom", ofType: "cikernel")
        
        guard let path = hslData,
            let code = try? String(contentsOfFile: path),
            let kernel = CIKernel(source: code) else { return nil }
        guard let inputImage = inputImage else { return nil }
        
        let extent = inputImage.extent
        let currentLeftColor = shift < 0 ? leftColor : filterColor
        let currentRightColor = shift > 0 ? rightColor : filterColor
        let arguments = [inputImage,filterColor as Any, currentLeftColor as Any,currentRightColor as Any,
                         shift as Any,
                         sense as Any]
        
        return kernel.apply(extent: extent, roiCallback:
            { (index, rect) in
                return rect
        }, arguments: arguments)
    }
    
    func setupFilterColor(filterColor: UIColor, shift: CGFloat = 0) {
        self.filterColor = filterColor.hue() + shift
        self.shift = shift
        leftColor = (filterColor.hue() - dif) < 0 ? 1.0 + (filterColor.hue() - dif) : (filterColor.hue() - dif)
        rightColor = (filterColor.hue() + dif) > 1.0 ? (filterColor.hue() + dif) - 1.0 : (filterColor.hue() + dif)
        
    }
    
}
