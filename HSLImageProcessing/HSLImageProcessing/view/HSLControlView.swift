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
    
    weak var filterListener: FilterChangedListener? {
        didSet {
            colorPalette?.filterListener = filterListener
        }
    }
    
    var selectedFilter: ColorFilter? = nil {
        didSet{
            setupSliders(color: selectedColor)
        }
    }
    
    var selectedColor:UIColor {
        get {
            return selectedFilter?.defaultColor.getColor() ?? UIColor.red
        }
    }
    
    var currentColor:UIColor = UIColor.red
    
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
    
    @IBOutlet weak var colorPalette: ColorPaleteView!
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
    }
    
    private func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: HSLControlView.self)
        let nib = UINib(nibName: "HSLControlView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    func setupFilters(filters: [ColorFilter]){
        var items = [ColorItem]()
        for f in filters {
            var item = ColorItem(color: f.defaultColor)
            items.append(item)
        }
        items[0].isSelected = true
        selectedFilter = filters[0]
        colorPalette?.setupData(colors: items)
    }
    
    func changeFilter(filter:ColorFilter){
        self.selectedFilter = filter
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
            selectedFilter?.selectedHue = CGFloat(hue)
            selectedFilter?.selectedSat = CGFloat(sat)
            selectedFilter?.selectedLum = CGFloat(lum)
          listener?.colorChanged(hue: CGFloat(hue)/hueMax, sat: CGFloat(sat), lum: CGFloat(lum)/lumDiv)
        }
    }
    
    func resetForHue() {
        if let hue = currentHue, let lum = currentLum {
            currentColor = selectedColor.hslColor(hue: selectedColor.normalizeHue(shift: CGFloat(hue)/hueMax),sat: 1, lum: CGFloat(lum)/lumDiv)
            satSlider.addGradient(colors: [currentColor.cgColor,currentColor.cgColor])
            lumSlider.addGradient(colors: currentColor.colorWithLum(lum: selectedColor.hsl!.lightness).createLumSet())
        }
    }
    
    func resetForLum() {
        if let hue = currentHue, let lum = currentLum {
            currentColor = selectedColor.hslColor(hue: selectedColor.normalizeHue(shift: CGFloat(hue)/hueMax), sat: 1, lum: CGFloat(lum)/lumDiv)
            hueSlider.addGradient(colors: currentColor.createColorSet())
            satSlider.addGradient(colors: [currentColor.cgColor,currentColor.cgColor])
            
        }
    }
    
    deinit {
        listener = nil
    }
}


protocol HSLListener : class {
    func colorChanged(hue: CGFloat,sat: CGFloat, lum : CGFloat)
}

protocol FilterChangedListener : class {
    func filterItemChanged(index: Int)
}
