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
      private let red = CGFloat(0) // UIColor(red: 0.901961, green: 0.270588, blue: 0.270588, alpha: 1).hue()
      private let orange = UIColor(red: 0.901961, green: 0.584314, blue: 0.270588, alpha: 1).hue()
      private let yellow = UIColor(red: 0.901961, green: 0.901961, blue: 0.270588, alpha: 1).hue()
      private let green = UIColor(red: 0.270588, green: 0.901961, blue: 0.270588, alpha: 1).hue()
      private let aqua = UIColor(red: 0.270588, green: 0.901961, blue: 0.901961, alpha: 1).hue()
      private let blue = UIColor(red: 0.270588, green: 0.270588, blue: 0.901961, alpha: 1).hue()
      private let purple = UIColor(red: 0.584314, green: 0.270588, blue: 0.901961, alpha: 1).hue()
      private let magenta = UIColor(red: 0.901961, green: 0.270588, blue: 0.901961, alpha: 1).hue()
    
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
    
    func setupFilter(selectedColor: Colors, shift: CGFloat){
        resetShifts()
        switch selectedColor {
        case .red:
             inputRedShift = CIVector(x: shift, y: 1, z: 1)
        case .orange:
            inputOrangeShift = CIVector(x: shift, y: 1, z: 1)
        case .yellow:
            inputYellowShift = CIVector(x: shift, y: 1, z: 1)
        case .green:
            inputGreenShift = CIVector(x: shift, y: 1, z: 1)
        case .aqua:
            inputAquaShift = CIVector(x: shift, y: 1, z: 1)
        case .blue:
            inputBlueShift = CIVector(x: shift, y: 1, z: 1)
        case .purple:
            inputPurpleShift = CIVector(x: shift, y: 1, z: 1)
        case .magenta:
           inputMagentaShift = CIVector(x: shift, y: 1, z: 1)
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
