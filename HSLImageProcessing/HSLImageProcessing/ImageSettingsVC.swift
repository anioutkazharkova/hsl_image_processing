//
//  ImageSettingsVC.swift
//  HSLImageProcessing
//
//  Created by 1 on 03.04.2019.
//  Copyright © 2019 azharkova. All rights reserved.
//

import UIKit
import CoreImage

class ImageSettingsVC: BaseVC{
   

    var showPrevImageButton:ActionImageButton?
    
    var defaultImage: UIImage? = nil
    var processedImage: UIImage? = nil
    let queue = DispatchQueue(label: "image_queue",qos: .userInteractive)
    var imageItem: DispatchWorkItem? = nil
    weak var imageHelper = FilterImageManager.sharedInstance
    
    @IBOutlet weak var imageView: ImageScrollView?
    
    @IBOutlet weak var hslControl: HSLControlView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFilters()
    }
    
    func setupImage(image: UIImage){
        self.defaultImage = image.copy() as? UIImage
        self.processedImage=image.copy() as? UIImage
        
    }
    
    func setupFilters() {
        imageView?.setup()
        
        imageView?.imageContentMode = .aspectFit
        imageView?.initialOffset = .center
        imageView?.display(image: defaultImage!)
        
        imageHelper?.setupFilter(image: defaultImage!)
        
        hslControl?.setupColors(colors: imageHelper?.filters.map{ColorItem(filter: $0)} ?? [ColorItem]())
        hslControl?.selectedFilter = imageHelper?.selectedFilter
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        setupMenu()
        hslControl?.listener = self
        hslControl?.filterListener = self
        imageView?.imageScrollViewDelegate = self
    }
    
    func setupMenu(){
        if (showPrevImageButton == nil){
            showPrevImageButton = ActionImageButton(frame:CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 30, height: 30)))
            showPrevImageButton?.setBackgroundImage(UIImage(named: "prev_image"), for: .normal)
            showPrevImageButton?.listener = self
        }
        
        let prevImage = UIBarButtonItem(customView: showPrevImageButton!)
       
        self.navigationItem.leftBarButtonItem = prevImage
    }
    
    @objc func showDefaultImage(sender: AnyObject, forEvent event: UIEvent) {
      
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        hslControl?.listener = nil
        hslControl?.filterListener = nil
        imageView?.imageScrollViewDelegate = nil
        super.viewWillDisappear(animated)
    }
    
    
    func processImage() {
        if (imageItem != nil) {
            imageItem?.cancel()
        }
        
        imageItem = DispatchWorkItem { [weak self]  in
            if let output = self?.imageHelper?.apply(){
                DispatchQueue.main.async {
                self?.processedImage = output
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
    
    func showDefaultImage() {
        if let image = self.defaultImage {
            self.imageView?.display(image: image)
        }
    }
    
    func showProcessedImage() {
        if let image = self.processedImage {
            self.imageView?.display(image: image)
        }
    }
}

extension ImageSettingsVC : LongPressListener {
    func longPressStarted() {
       showDefaultImage()
    }
    
    func longPressEnded() {
      showProcessedImage()
    }
}

extension ImageSettingsVC : FilterChangedListener {
    func filterItemChanged(index: Int) {
        imageHelper?.selectFilter(index: index)
       hslControl?.selectedFilter = imageHelper?.selectedFilter
    }
    
    func filterColorSelected(color: Colors) {
       showDefaultImage()
      imageHelper?.setupFilter(image: self.defaultImage!, with: color)
      hslControl?.selectedFilter = imageHelper?.selectedFilter
    }
    
    func needSetupFilter() {
       showDefaultImage()
        imageHelper?.setupFilter(image: self.defaultImage!)
         hslControl?.selectedFilter = imageHelper?.selectedFilter
    }
}

extension ImageSettingsVC : HSLListener {
    func colorChanged(filter: ColorFilter) {
        imageHelper?.changeFilter(filter: filter)
        processImage()
    }
}

extension ImageSettingsVC : ImageScrollViewDelegate {
    func imageScrollViewDidChangeOrientation(imageScrollView: ImageScrollView) {
        
    }
    
}
