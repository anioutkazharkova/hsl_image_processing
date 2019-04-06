//
//  AdvHSLFilter.swift
//  HSLImageProcessing
//
//  Created by 1 on 06.04.2019.
//  Copyright © 2019 azharkova. All rights reserved.
//

import CoreImage
import UIKit

class AdvHSLFilter: CIFilter {
    
    var sense: CGFloat = 0.15
    
    var inputImage: CIImage?
    var inputRedShift = CIVector(x: 0, y: 1, z: 1)
    var inputOrangeShift = CIVector(x: 0, y: 1, z: 1)
    var inputYellowShift = CIVector(x: 0, y: 1, z: 1)
    var inputGreenShift = CIVector(x: 0, y: 1, z: 1)
    var inputAquaShift = CIVector(x: 0, y: 1, z: 1)
    var inputBlueShift = CIVector(x: 0, y: 1, z: 1)
    var inputPurpleShift = CIVector(x: 0, y: 1, z: 1)
    var inputMagentaShift = CIVector(x: 0, y: 1, z: 1)
    
    let kernel: CIColorKernel? = {
        let hslData = Bundle.main.path(forResource: "hsv_filter", ofType: "cikernel")
        
        guard let path = hslData,
            let code = try? String(contentsOfFile: path),
            let kernel = CIColorKernel(source: code) else { return nil }
        return kernel
    }()
    
    func setupFilter(selectedColor: Colors, hueShift: CGFloat, sat: CGFloat, lum: CGFloat){
        resetShifts()
        switch selectedColor {
        case .red:
             inputRedShift = CIVector(x: hueShift, y: sat, z: lum)
        case .orange:
            inputOrangeShift = CIVector(x: hueShift, y: sat, z: lum)
        case .yellow:
            inputYellowShift = CIVector(x: hueShift, y: sat, z: lum)
        case .green:
            inputGreenShift = CIVector(x: hueShift, y: sat, z: lum)
        case .aqua:
            inputAquaShift = CIVector(x: hueShift, y: sat, z: lum)
        case .blue:
            inputBlueShift = CIVector(x: hueShift, y: sat, z: lum)
        case .purple:
            inputPurpleShift = CIVector(x: hueShift, y: sat, z: lum)
        case .magenta:
           inputMagentaShift = CIVector(x: hueShift, y: sat, z: lum)
        }
    }
    
    private func resetShifts() {
        inputRedShift = CIVector(x: 0, y: 1, z: 1)
        inputOrangeShift = CIVector(x: 0, y: 1, z: 1)
        inputYellowShift = CIVector(x: 0, y: 1, z: 1)
        inputGreenShift = CIVector(x: 0, y: 1, z: 1)
        inputAquaShift = CIVector(x: 0, y: 1, z: 1)
        inputBlueShift = CIVector(x: 0, y: 1, z: 1)
        inputPurpleShift = CIVector(x: 0, y: 1, z: 1)
        inputMagentaShift = CIVector(x: 0, y: 1, z: 1)
    }
    
    
        override var attributes: [String : Any]
        {
            return [
                kCIAttributeFilterDisplayName: "MultiBandHSV" as AnyObject,
                "inputImage": [kCIAttributeIdentity: 0,
                               kCIAttributeClass: "CIImage",
                               kCIAttributeDisplayName: "Image",
                               kCIAttributeType: kCIAttributeTypeImage]
            ]
        }
    
        override var outputImage: CIImage?
        {
            guard let inputImage = inputImage else
            {
                return nil
            }
            return kernel?.apply(extent: inputImage.extent,
                                            arguments: [inputImage,
                                                        inputRedShift,
                                                        inputOrangeShift,
                                                        inputYellowShift,
                                                        inputGreenShift,
                                                        inputAquaShift,
                                                        inputBlueShift,
                                                        inputPurpleShift,
                                                        inputMagentaShift,sense])
        }
}
