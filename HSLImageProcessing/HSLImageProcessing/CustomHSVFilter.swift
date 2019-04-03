//
//  CustomHSVFilter.swift
//  HSLImageProcessing
//
//  Created by 1 on 03.04.2019.
//  Copyright © 2019 azharkova. All rights reserved.
//

import Foundation
import CoreImage

class CustomHSLFilter:CIFilter {
    
    var inputImage: CIImage? 
    
    override var outputImage: CIImage!
    {
        let hslData = Bundle.main.path(forResource: "hsl", ofType: "cikernel")
        
        guard let path = hslData,
            let code = try? String(contentsOfFile: path),
            let kernel = CIColorKernel(source: code) else { return nil }
        guard let inputImage = inputImage else { return nil }
        
        let extent = inputImage.extent
        let arguments = [inputImage]
        
        return kernel.apply(extent: extent, arguments: arguments)
    }
}

/*
 vec4 hsv2rgb(vec4 color)
 { float h = color.r;
 float s = color.g;
 float v = color.b;
 h       = h*6.0;
 float i = floor( h );
 float f =  h -i ;
 float p =  v * ( 1.0 - s );
 float q =  v * ( 1.0 - s * f );
 float t =  v * ( 1.0 - s * ( 1.0 - f ) );
 float r = (i == 0.0 ?   v  :
 (i == 1.0 ?   q  :
 (i == 2.0 ?   p  :
 (i == 3.0 ?   p  :
 (i == 4.0 ?   t  :  v )))));
 float g = (i == 0.0 ?   t  :
 (i == 1.0 ?   v  :
 (i == 2.0 ?   v  :
 (i == 3.0 ?   q  :
 (i == 4.0 ?   p  :  p )))));
 float b = (i == 0.0 ?   p  :
 (i == 1.0 ?   p  :
 (i == 2.0 ?   t  :
 (i == 3.0 ?   v  :
 (i == 4.0 ?   v  :  q )))));
 return vec4(r, g, b, color.a);
 }
 kernel vec4 hsl2rgb(sampler image)
 { vec4 pixel = sample(image, samplerCoord(image));
 return hsv2rgb(pixel);
 }*/
