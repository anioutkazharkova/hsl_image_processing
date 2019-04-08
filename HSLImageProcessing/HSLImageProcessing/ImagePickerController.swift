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

    var adapter: ImageAdapter?
    @IBOutlet weak var imageList: UICollectionView!

    @IBOutlet weak var loader: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()

        adapter = ImageAdapter()
        adapter?.sideSize = ((self.view?.bounds.width ?? 0) - 8.0)/4

        imageList.register(UINib.init(nibName: ImagePickerCell.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: ImagePickerCell.cellIdentifier)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.adapter?.owner = self
        imageList.delegate = adapter
        imageList.dataSource = adapter
        loadAssets()
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.adapter?.owner = nil
        imageList.delegate = nil
        imageList.dataSource = nil
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

    func loadAssets() {
        ImagePhotoManager.shared.loadAssets(success: {
            [weak self] result in
            self?.setupAssets(assets: result)
            }, failure: { [weak self] in
            self?.showNeedAccessMessage()
        })
    }

    func setupAssets(assets: PHFetchResult<AnyObject>) {
        self.showLoading(show: true)
        adapter?.loadAssets(assets: assets)
        DispatchQueue.main.async { [weak self] in
            self?.imageList?.reloadData()
            self?.showLoading(show: false)
            self?.imageList?.isHidden = false
        }
    }

    func showLoading(show: Bool) {
        if (show) {
            self.loader?.startAnimating()
        } else {
            self.loader?.stopAnimating()
        }
        self.loader?.isHidden = !show
    }

    private func loadImage(index: Int) {
        ImagePhotoManager.shared.selectAsset(index: index)
      goToFilter()
    }

    private func goToFilter() {
        let vc = ImageSettingsVC()
        self.navigationController?.pushViewController(vc, animated: false)
    }
}

extension ImagePickerController: ListOwner {
    func reload() {
        imageList?.reloadData()
    }

    func selectedItem(index: Int) {
        self.loadImage(index: index)
    }

}
