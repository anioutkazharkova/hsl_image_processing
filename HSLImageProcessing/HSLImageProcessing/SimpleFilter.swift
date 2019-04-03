//
//  SimpleFilter.swift
//  HSLImageProcessing
//
//  Created by 1 on 03.04.2019.
//  Copyright © 2019 azharkova. All rights reserved.
//

import UIKit
import CoreImage

class SimpleFilter: CIFilter {
    
    let kernel: CIColorKernel? = {
        let kernelString =
            "kernel vec4 RGB_to_GBR(__sample pixel)\n" +
                "{\n" +
                "vec4 twistedColor = pixel.gbra;\n" +
                
                "return twistedColor;\n" +
        "}\n"
        
        return CIColorKernel(source: kernelString)
    }()
    
    
 var inputImage: CIImage?
    
    override var outputImage: CIImage? {
        guard let kernel = kernel, let inputImage = inputImage else {
            return nil
        }
        
        return kernel.apply(extent: inputImage.extent,
                            arguments: [inputImage])
    }
}


