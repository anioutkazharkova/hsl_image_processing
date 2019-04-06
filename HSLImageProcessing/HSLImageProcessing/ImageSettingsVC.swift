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
    
    @IBOutlet weak var imageView: ImageScrollView?
    
    @IBOutlet weak var hslControl: HSLControlView!
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
        
        imageView?.imageContentMode = .aspectFit
        imageView?.initialOffset = .center
    imageView?.display(image: defaultImage!)
        
   // hueSlider.addGradient(colors: UIColor.red.createColorSet())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hslControl?.listener = self
        imageView?.imageScrollViewDelegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        hslControl?.listener = nil
        imageView?.imageScrollViewDelegate = nil
        super.viewWillDisappear(animated)
    }
    
    
    func processImage(hue: CGFloat, sat: CGFloat, lum: CGFloat) {
        if (imageItem != nil) {
            imageItem?.cancel()
        }
        
        imageItem = DispatchWorkItem { [weak self]  in
            if let im = self?.defaultImage, let output = FilteredImageHelper.applyFilter(image: im, color: .red, hueShift: hue, saturation: sat, lum: lum) {
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

    
}

extension ImageSettingsVC : HSLListener {
    func colorChanged(hue: CGFloat, sat: CGFloat, lum: CGFloat) {
        processImage(hue: hue, sat: sat, lum: lum)
    }
}

extension ImageSettingsVC : ImageScrollViewDelegate {
    func imageScrollViewDidChangeOrientation(imageScrollView: ImageScrollView) {
        
    }
    
}
