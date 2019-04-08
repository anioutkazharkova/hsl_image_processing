//
//  ImageAdapter.swift
//  HSLImageProcessing
//
//  Created by 1 on 07.04.2019.
//  Copyright © 2019 azharkova. All rights reserved.
//

import UIKit
import Photos

class ImageAdapter: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    weak var owner: ListOwner?
  var sideSize: CGFloat = 80.0
   var assets: PHFetchResult<AnyObject>?

    func loadAssets(assets: PHFetchResult<AnyObject>?) {
      self.assets = assets
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (assets != nil) ? assets!.count : 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagePickerCell.cellIdentifier,
                                                            for: indexPath) as? ImagePickerCell else {
                                                                return UICollectionViewCell()

        }

        PHImageManager.default().requestImage(for: assets?[indexPath.row] as! PHAsset, targetSize: CGSize(width: sideSize, height: sideSize), contentMode: .aspectFill, options: nil) { (image: UIImage?, info: [AnyHashable: Any]?) -> Void in
            cell.image = image
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: sideSize, height: sideSize)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        owner?.selectedItem(index: indexPath.row)
}
}
