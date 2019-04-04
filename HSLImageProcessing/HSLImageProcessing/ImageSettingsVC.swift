//
//  ImageSettingsVC.swift
//  HSLImageProcessing
//
//  Created by 1 on 03.04.2019.
//  Copyright © 2019 azharkova. All rights reserved.
//

import UIKit

class ImageSettingsVC: UIViewController {

    var defaultImage: UIImage? = nil
    var filter:CustomHSLFilter? = nil
    @IBOutlet weak var image: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
defaultImage = UIImage(named: "testimage")
        image?.image = defaultImage
       filter = CustomHSLFilter()
    }

    @IBAction func processImageByClick(_ sender: Any) {
        if let im = defaultImage {
            weak var _im = im
            DispatchQueue.global().async {
                guard let __im = _im else {
                    return
                }
                self.filter?.inputImage = CIImage(image: __im, options: nil)
                if let output = self.filter?.outputImage {
                    DispatchQueue.main.async {
                         self.image?.image = UIImage(ciImage: output)
                    }
                   
                }
            }
        
        }
    }
    
}
