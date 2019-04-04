//
//  CustomHSVFilter.swift
//  HSLImageProcessing
//
//  Created by 1 on 03.04.2019.
//  Copyright © 2019 azharkova. All rights reserved.
//

import Foundation
import CoreImage
import UIKit

class CustomHSLFilter:CIFilter {
    
    var inputImage: CIImage?
    var filterColor: UIColor = UIColor.green
    var saturation: CGFloat = 0.8
    var lightness: CGFloat = 0.2
    
    override var outputImage: CIImage!
    {
        let hslData = Bundle.main.path(forResource: "hsl", ofType: "cikernel")
        
        guard let path = hslData,
            let code = try? String(contentsOfFile: path),
            let kernel = CIKernel(source: code) else { return nil }
        guard let inputImage = inputImage else { return nil }
        
        let extent = inputImage.extent
        let arguments = [inputImage,CIColor(color: filterColor),saturation as Any,lightness as Any]
        
        return kernel.apply(extent: extent, roiCallback:
            { (index, rect) in
                return rect
        }, arguments: arguments)
    }
}

