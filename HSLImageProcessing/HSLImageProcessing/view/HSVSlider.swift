//
//  HSVSlider.swift
//  HSLImageProcessing
//
//  Created by 1 on 07.04.2019.
//  Copyright © 2019 azharkova. All rights reserved.
//

import UIKit

class HSVSlider: UISlider {
    override init(frame: CGRect) {
        super.init(frame: frame)
        addGradient()
        self.setThumbImage(UIImage(), for: .normal)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addGradient()
        self.setThumbImage(UIImage(), for: .normal)
    }

    private let gradient: CAGradientLayer = CAGradientLayer()

    func addGradient() {
        let colors = [ColorUtility.magenta.cgColor,
            ColorUtility.red.cgColor,
                     ColorUtility.orange.cgColor,
                     ColorUtility.yellow.cgColor,
                     ColorUtility.green.cgColor,
                     ColorUtility.aqua.cgColor,
                     ColorUtility.blue.cgColor,
                     ColorUtility.purple.cgColor
                     ]
        let trackImage = UIImage.gradientImage(size: self.bounds.size, colorSet: colors)
        self.setMinimumTrackImage(trackImage, for: .normal)
        self.setMaximumTrackImage(trackImage, for: .normal)
    }
}
