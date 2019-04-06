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
    let queue = DispatchQueue(label: "image_queue",qos: .userInteractive)
    var imageItem: DispatchWorkItem? = nil
    
    var filters:[ColorFilter] = [ColorFilter(color: .red),
                                 ColorFilter(color: .yellow),
                                 ColorFilter(color: .green),
                                 ColorFilter(color:  .purple),
                                 ColorFilter(color: .blue),
                                 ColorFilter(color: .aqua)
                                 ]
    
    @IBOutlet weak var imageView: ImageScrollView?
    
    @IBOutlet weak var hslControl: HSLControlView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
defaultImage = UIImage(named: "image2")
        imageView?.setup()
        
        imageView?.imageContentMode = .aspectFit
        imageView?.initialOffset = .center
    imageView?.display(image: defaultImage!)
        hslControl?.setupFilters(filters: filters)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hslControl?.listener = self
        hslControl?.filterListener = self
        imageView?.imageScrollViewDelegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        hslControl?.listener = nil
        hslControl?.filterListener = nil
        imageView?.imageScrollViewDelegate = nil
        super.viewWillDisappear(animated)
    }
    
    
    func processImage(color: Colors, hue: CGFloat, sat: CGFloat, lum: CGFloat) {
        if (imageItem != nil) {
            imageItem?.cancel()
        }
        
        imageItem = DispatchWorkItem { [weak self]  in
            if let im = self?.defaultImage, let output = FilteredImageHelper.applyFilter(image: im, color: color, hueShift: hue, saturation: sat, lum: lum) {
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

extension ImageSettingsVC : FilterChangedListener {
    func filterItemChanged(index: Int) {
        hslControl?.changeFilter(filter:filters[index])
    }
}

extension ImageSettingsVC : HSLListener {
    func colorChanged(color: Colors, hue: CGFloat, sat: CGFloat, lum: CGFloat) {
        processImage(color: color, hue: hue, sat: sat, lum: lum)
    }
}

extension ImageSettingsVC : ImageScrollViewDelegate {
    func imageScrollViewDidChangeOrientation(imageScrollView: ImageScrollView) {
        
    }
    
}
