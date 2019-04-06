//
//  FilteredImageHelper.swift
//  HSLImageProcessing
//
//  Created by 1 on 06.04.2019.
//  Copyright © 2019 azharkova. All rights reserved.
//

import Foundation
import CoreImage
import UIKit
import Foundation

class FilteredImageHelper
{
    static let ciContext = CIContext(options: nil)
    var _contextFast: CIContext? = nil
    
    var ciContextFast: CIContext {
        if (_contextFast == nil) {
            if  let openGLContext = EAGLContext(api: EAGLRenderingAPI.openGLES2) {
                _contextFast = CIContext(eaglContext: openGLContext, options:  [CIContextOption.workingColorSpace: NSNull()])
            }
        }
        return _contextFast!
    }
    
    static func applyFilter(image: UIImage, color: Colors, shift:Float,saturation:Float,lum: Float) -> UIImage?
    {
        let ciFilter = AdvHSLFilter()
        if let ci = CIImage(image: image) {
            ciFilter.inputImage = ci
         }
        
        ciFilter.setupFilter(selectedColor: color, shift: CGFloat(shift))
        
        if let filteredImageData = ciFilter.value(forKey: kCIOutputImageKey) as? CIImage {
            if  let filteredImageRef = FilteredImageHelper.ciContext.createCGImage(filteredImageData, from: filteredImageData.extent) {
                return UIImage(cgImage: filteredImageRef)
            }
        }
        
        return nil
    }
}
