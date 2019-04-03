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
        filter?.inputImage = CIImage(image: im)
        if let output = filter?.outputImage {
            image?.image = UIImage(ciImage: output)
        }
        }
    }
    
}
