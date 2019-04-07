//
//  ImagePickerController.swift
//  HSLImageProcessing
//
//  Created by 1 on 07.04.2019.
//  Copyright © 2019 azharkova. All rights reserved.
//

import UIKit
import Photos

class ImagePickerController: BaseVC {

    var assets: PHFetchResult<AnyObject>?
    var adapter: ImageAdapter?
    @IBOutlet weak var imageList: UICollectionView!
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        adapter = ImageAdapter()
        adapter?.sideSize = ((self.view?.bounds.width ?? 0) - 8.0)/4
        
        imageList.register(UINib.init(nibName: ImagePickerCell.cellIdentifier, bundle: nil), forCellWithReuseIdentifier:ImagePickerCell.cellIdentifier)
        imageList.delegate = adapter
        imageList.dataSource = adapter
        if PHPhotoLibrary.authorizationStatus() == .authorized {
            reloadAssets()
        } else {
            PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) -> Void in
                if status == .authorized {
                    self.reloadAssets()
                } else {
                    self.showNeedAccessMessage()
                }
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.adapter?.owner = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.adapter?.owner = nil 
        super.viewWillDisappear(animated)
    }
    
    
     func showNeedAccessMessage() {
        let alert = UIAlertController(title: "Image picker", message: "App need get access to photos", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction) -> Void in
            self.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) -> Void in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        }))
        
        show(alert, sender: nil)
    }
    
    func reloadAssets() {
        self.showLoading(show: true)
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
        fetchOptions.fetchLimit = 25000
        assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions) as? PHFetchResult<AnyObject>
    
        adapter?.loadAssets(assets: assets)
        DispatchQueue.main.async { [weak self] in
            self?.imageList?.reloadData()
            self?.showLoading(show: false)
            self?.imageList?.isHidden = false
        }
    }

    func showLoading(show: Bool){
        if (show){
            self.loader?.startAnimating()
        } else {
            self.loader?.stopAnimating()
        }
        self.loader?.isHidden = !show
    }
    
    private func loadImage(index: Int) {
        let width = self.view.bounds.width
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .fast
        
        if let item = assets?[index] as? PHAsset {
        PHImageManager.default().requestImage(for:item, targetSize: CGSize(width: width, height: 0.75 * width), contentMode: .aspectFill, options: options) { [weak self] (image: UIImage?, info: [AnyHashable: Any]?) -> Void in
            if let _image = image {
                let vc = ImageSettingsVC()
                vc.setupImage(image: _image)
                self?.navigationController?.pushViewController(vc, animated: false)
            }
        }
        }
    }
}

extension ImagePickerController : ListOwner {
    func reload() {
        imageList?.reloadData()
    }
    
    func selectedItem(index: Int) {
        self.loadImage(index: index)
    }
    

}
