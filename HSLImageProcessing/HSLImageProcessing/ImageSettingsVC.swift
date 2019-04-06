//
//  ImageSettingsVC.swift
//  HSLImageProcessing
//
//  Created by 1 on 03.04.2019.
//  Copyright © 2019 azharkova. All rights reserved.
//

import UIKit
import CoreImage

class ImageSettingsVC: UIViewController{
   

    var defaultImage: UIImage? = nil
    var filter:AdvHSLFilter? = nil
    let queue = DispatchQueue(label: "image_queue",qos: .userInteractive)
    var imageItem: DispatchWorkItem? = nil
    
    var colorShift:CGFloat = 0.0
    var defaultColor = UIColor.green
    var _context: CIContext? = nil
    
    @IBOutlet weak var hueSlider: GradientSlider!
    @IBOutlet weak var imageView: ImageScrollView?
    
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
defaultImage = UIImage(named: "image2")
        imageView?.setup()
        imageView?.imageScrollViewDelegate = self
        imageView?.imageContentMode = .aspectFit
        imageView?.initialOffset = .center
    imageView?.display(image: defaultImage!)
        
   // hueSlider.addGradient(colors: UIColor.red.createColorSet())
    }
    
   

    @IBAction func processImageByClick(_ sender: Any) {
    processImage()
        
        }
    
    func processImage() {
        if (imageItem != nil) {
            imageItem?.cancel()
        }
        
        imageItem = DispatchWorkItem { [weak self]  in
            if let im = self?.defaultImage, let output = FilteredImageHelper.applyFilter(image: im, color: .red, shift: Float(self?.colorShift ?? 0), saturation: 0, lum: 0) {
                DispatchQueue.main.async {
                self?.imageView?.display(image: output)
                }
            }
        }
        if let item = imageItem {
        queue.async(execute: item)
            item.notify(queue: DispatchQueue.main){ [weak self] in
                self?.imageItem = nil
            }
        }
    }

    
    
    @IBAction func colorChanged(_ sender: Any) {
        if let slider = sender as? UISlider {
            let dif = slider.value
             colorShift =  CGFloat(dif/360.0)
            processImage()
        }
    }
    
}

extension ImageSettingsVC : ImageScrollViewDelegate {
    func imageScrollViewDidChangeOrientation(imageScrollView: ImageScrollView) {
        
    }
    
}
