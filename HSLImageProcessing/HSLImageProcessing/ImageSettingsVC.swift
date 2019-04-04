//
//  ImageSettingsVC.swift
//  HSLImageProcessing
//
//  Created by 1 on 03.04.2019.
//  Copyright © 2019 azharkova. All rights reserved.
//

import UIKit

class ImageSettingsVC: UIViewController {

    var filter:CustomHSLFilter? = nil
    @IBOutlet weak var image: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

       filter = CustomHSLFilter()
    }

    @IBAction func processImageByClick(_ sender: Any) {
        if let im = image?.image {
            weak var _im = im
            DispatchQueue.global().async {
                guard let __im = _im else {
                    return
                }
                if let cg = __im.cgImage {
                    self.filter?.inputImage = CIImage(image:__im)
                if let output = self.filter?.outputImage {
                    DispatchQueue.main.async {
                         self.image?.image = UIImage(ciImage: output)
                        self.image?.contentMode = UIView.ContentMode.scaleAspectFit
                    }
                   
                }
                }
            }
        
        }
    }
    
}
