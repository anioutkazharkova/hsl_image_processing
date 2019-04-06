//
//  HSLControlView.swift
//  HSLImageProcessing
//
//  Created by 1 on 06.04.2019.
//  Copyright © 2019 azharkova. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class HSLControlView: UIView {
    
    let hueMax:CGFloat = 360.0
    let lumDiv: CGFloat = 100.0
    
    var selectedColor = UIColor.red
    
    var currentHue:Float? {
        get {
            return hueSlider?.value
        }
    }
    
    var currentSat:Float? {
        get {
            return satSlider?.value
        }
    }
    
    var currentLum:Float? {
        get {
            return lumSlider?.value
        }
    }
    
    weak var listener: HSLListener? = nil
    
    @IBOutlet weak var hueSlider: GradientSlider!
    
    @IBOutlet weak var satSlider: GradientSlider!
    
    @IBOutlet weak var lumSlider: GradientSlider!
    
    convenience init() {
        self.init(frame: UIScreen.main.bounds)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        initContent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initContent()
    }
    
    private  func initContent() {
        
        let view = loadViewFromNib()
        
        view.frame = bounds
        
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        addSubview(view)
        setupSliders(color: selectedColor)
    }
    
    private func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: HSLControlView.self)
        let nib = UINib(nibName: "HSLControlView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    func setupSliders(color: UIColor) {
        hueSlider.addGradient(colors: color.createColorSet())
        satSlider.addGradient(colors: [color.cgColor,color.cgColor])
        lumSlider.addGradient(colors: color.createLumSet())
    }
    
    
    @IBAction func hueChanged(_ sender: Any) {
        colorChanged()
        resetForHue()
    }
    
    
    @IBAction func satChanged(_ sender: Any) {
        colorChanged()
    }
    
    @IBAction func lumChanged(_ sender: Any) {
        colorChanged()
       resetForLum()
    }
    
    func colorChanged() {
        if let hue = currentHue, let sat = currentSat, let lum = currentLum {
          listener?.colorChanged(hue: CGFloat(hue)/hueMax, sat: CGFloat(sat), lum: CGFloat(lum)/lumDiv)
        }
    }
    
    func resetForHue() {
        if let hue = currentHue, let lum = currentLum {
            let newColor = selectedColor.hslColor(hue: selectedColor.normalizeHue(shift: CGFloat(hue)/hueMax),sat: 1, lum: CGFloat(lum)/lumDiv)
            satSlider.addGradient(colors: [newColor.cgColor,newColor.cgColor])
            lumSlider.addGradient(colors: newColor.colorWithLum(lum: selectedColor.hsl!.lightness).createLumSet())
        }
    }
    
    func resetForLum() {
        if let hue = currentHue, let lum = currentLum {
            let newColor = selectedColor.hslColor(hue: selectedColor.normalizeHue(shift: CGFloat(hue)/hueMax), sat: 1, lum: CGFloat(lum)/lumDiv)
            hueSlider.addGradient(colors: newColor.createColorSet())
            satSlider.addGradient(colors: [newColor.cgColor,newColor.cgColor])
            
        }
    }
    
    deinit {
        listener = nil
    }
}

protocol HSLListener : class {
    func colorChanged(hue: CGFloat,sat: CGFloat, lum : CGFloat)
}
