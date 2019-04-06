//
//  ColorPaleteView.swift
//  HSLImageProcessing
//
//  Created by 1 on 07.04.2019.
//  Copyright © 2019 azharkova. All rights reserved.
//

import UIKit

@IBDesignable
class ColorPaleteView: UIView {

    @IBOutlet weak var colorButtonsList: UICollectionView!
    var adapter:ColorAdapter? = nil
    weak var filterListener: FilterChangedListener?

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
        adapter = ColorAdapter()
        colorButtonsList.register(UINib.init(nibName: ColorCell.cellIdentifier, bundle: nil), forCellWithReuseIdentifier:ColorCell.cellIdentifier)
        colorButtonsList.dataSource = adapter
        colorButtonsList.delegate = adapter
    }
    
    private func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: ColorPaleteView.self)
        let nib = UINib(nibName: "ColorPaleteView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    func setupData(colors: [ColorItem]) {
        self.adapter?.setupData(items: colors)
        self.adapter?.owner = self
        self.colorButtonsList.reloadData()
    }
}

extension ColorPaleteView:ListOwner {
    func reload() {
        colorButtonsList?.reloadData()
    }
    
    func selectedItem(index: Int) {
        filterListener?.filterItemChanged(index: index)
    }
}

protocol  ListOwner : class {
    func reload()
    func selectedItem(index: Int)
}

