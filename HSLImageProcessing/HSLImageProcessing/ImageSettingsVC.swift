//
//  ImageSettingsVC.swift
//  HSLImageProcessing
//
//  Created by 1 on 03.04.2019.
//  Copyright © 2019 azharkova. All rights reserved.
//

import UIKit
import CoreImage

class ImageSettingsVC: UIViewController {

    var defaultImage: UIImage? = nil
    var filter:MultiBandHSV? = nil
    var queue: DispatchQueue? = nil
    
    var defaultColor = UIColor.green
    @IBOutlet weak var image: UIImageView!
    var _context: CIContext? = nil
    
    var context: CIContext {
        if (_context == nil) {
         if  let openGLContext = EAGLContext(api: .openGLES3) {
            _context = CIContext(eaglContext: openGLContext)
    }
        }
        return _context!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
defaultImage = UIImage(named: "testimage")
        image?.image = defaultImage
       filter = MultiBandHSV()
      
    }

    @IBAction func processImageByClick(_ sender: Any) {
    processImage()
        
        }
    
    func processImage() {
      
        if let im = defaultImage {
            weak var _im = im
           
                guard let __im = _im else {
                    return
                }
            
                
                self.filter?.inputImage = CIImage(image:__im)
                if let output = self.filter?.outputImage, let cg = context.createCGImage(output, from: output.extent) {
                 
                        self.image?.image = UIImage(cgImage:cg)
                
            }
        }
        }
    
    
    @IBAction func colorChanged(_ sender: Any) {
        if let slider = sender as? UISlider {
            let dif = slider.value
            let colorShift =  CGFloat(dif/360.0)
              filter?.inputRedShift = CIVector(x: colorShift, y: 0, z: 1)
          // processImage()
        }
    }
    
}
