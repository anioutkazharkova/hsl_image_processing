//
//  ZoomImageView.swift
//  HSLImageProcessing
//
//  Created by 1 on 06.04.2019.
//  Copyright © 2019 azharkova. All rights reserved.
//

import UIKit

class ZoomImageView: UIView {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage? {
        get {
            return imageView?.image
        }
        set {
            imageView?.image = newValue
        }
    }
    
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
        scrollView.zoomScale = 1.0
        scrollView.delegate = self
    }
    
    private func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: ZoomImageView.self)
        let nib = UINib(nibName: "ZoomImageView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
}

extension ZoomImageView : UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
