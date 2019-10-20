//
//  PickerViewDataSource.swift
//  ConvenientImagePicker
//
//  Created by Land on 2019/10/18.
//

import Foundation
import UIKit
import Photos



extension PickerViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, UIGestureRecognizerDelegate
{
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.images == nil
        {
            return self.assetsFetchResults.count
        }
        else
        {
            return self.images!.count
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return self.PickerCollectionCellInit(indexPath: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if self.selectedImageCount >= self.maxNumberOfSelectedImage
        {
            self.delegate?.imageSelectMax(self, wangToSelectIndex: indexPath.item, wangToSelectImage: self.GetImageFromIndex(item: indexPath.item))
            return false
        }
        return true
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.1) {
            collectionView.cellForItem(at: indexPath)?.layer.borderWidth = 5.0
            (collectionView.cellForItem(at: indexPath) as? PickerCollectionCell)?.selectedImageView.alpha = 1
            (collectionView.cellForItem(at: indexPath) as? PickerCollectionCell)?.upper.alpha = 0.3
        }
        self.PickerCollectionCellOp(indexPath: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.1) {
            collectionView.cellForItem(at: indexPath)?.layer.borderWidth = 0.0
            (collectionView.cellForItem(at: indexPath) as? PickerCollectionCell)?.selectedImageView.alpha = 0
            (collectionView.cellForItem(at: indexPath) as? PickerCollectionCell)?.upper.alpha = 0
        }
        self.PickerCollectionCellDeOp(indexPath: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let length = (screenWidth - self.intervalOfPictures * CGFloat(self.numberOfPictureInRow + 1)) / CGFloat(self.numberOfPictureInRow)
        return CGSize(width: length, height: length)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: self.intervalOfPictures, left: self.intervalOfPictures, bottom: self.intervalOfPictures, right: self.intervalOfPictures)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: [.allowUserInteraction, .curveEaseInOut], animations: {
            collectionView.cellForItem(at: indexPath)?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: nil)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.allowUserInteraction, .curveEaseInOut], animations: {
            collectionView.cellForItem(at: indexPath)?.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
    }

    
    func collectionViewInit()
    {
        self.AssetsInit()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = self.intervalOfPictures
        layout.minimumLineSpacing = self.intervalOfPictures
        let length = (screenWidth - self.intervalOfPictures * CGFloat(self.numberOfPictureInRow + 1)) / CGFloat(self.numberOfPictureInRow)
        layout.itemSize = CGSize(width: length, height: length)
        
        let height = screenHeight - statusBarHeight
        self.collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: height < 0 ? 0 : height), collectionViewLayout: layout)
        //self.collectionView.frame = CGRect(x: 0, y: 50, width: screenWidth, height: height < 0 ? 0 : height)
        self.collectionView.contentInset = UIEdgeInsets(top: self.titleView.bounds.height - self.intervalOfPictures, left: 0, bottom: 0, right: 0)
        self.collectionView.scrollIndicatorInsets = UIEdgeInsets(top: self.titleView.bounds.height, left: 0, bottom: 0, right: 0)
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.register(PickerCollectionCell.self, forCellWithReuseIdentifier: "PickerCollectionCell")
        self.collectionView.allowsSelection = true
        self.collectionView.allowsMultipleSelection = self.allowMultipleSelection
        self.collectionView.delaysContentTouches = false
        self.collectionViewPanGesture.delegate = self
        self.collectionView.addGestureRecognizer(self.collectionViewPanGesture)
        (self.collectionView as UIScrollView).delegate = self
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.isScrollEnabled = false
        self.mainView.addSubview(self.collectionView)
    }
    
    func AssetsInit()
    {
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",
            ascending: false)]
        allPhotosOptions.predicate = NSPredicate(format: "mediaType = %d",
                                                 PHAssetMediaType.image.rawValue)
        assetsFetchResults = PHAsset.fetchAssets(with: PHAssetMediaType.image,
                                                              options: allPhotosOptions)
         
        self.imageManager = PHCachingImageManager()
        self.resetCachedAssets()
        
    }
    
    func resetCachedAssets(){
        self.imageManager.stopCachingImagesForAllAssets()
    }
    
    func PickerCollectionCellInit(indexPath: IndexPath) -> UICollectionViewCell // Pay Attention: Info.plist NSPhotoLibraryUsageDescription !!!
    {
        guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "PickerCollectionCell", for: indexPath) as? PickerCollectionCell else { return UICollectionViewCell() }
        cell.layer.borderColor = UIColor.systemBlue.cgColor
        cell.layer.borderWidth = self.selectedImages[indexPath.item] == nil ? 0.0 : 5.0
        cell.selectedImageView.alpha = self.selectedImages[indexPath.item] == nil ? 0 : 1
        cell.upper.alpha = self.selectedImages[indexPath.item] == nil ? 0 : 0.3
        
        if self.images == nil
        {
            let asset = self.assetsFetchResults[indexPath.item]
            //获取缩略图
            self.imageManager.requestImage(for: asset, targetSize: CGSize(width: 500, height: 500),
                                           contentMode: PHImageContentMode.aspectFill,
                                           options: nil) { (image, nfo) in
                                            cell.image.image = image
            }
        }
        else
        {
            cell.image.image = self.images?[indexPath.item]
        }
        
        return cell
    }
    
    func GetImageFromIndex(item: Int) -> UIImage?
    {
        var res : UIImage?
        let asset = self.assetsFetchResults[item]
        PHImageManager.default().requestImage(for: asset,
                    targetSize: CGSize(width: maxSizeOfPicture, height: maxSizeOfPicture) , contentMode: .aspectFill,
                    options: nil, resultHandler: {
                    (image, _) in
                        res = image
        })
        return res
    }
    
    func PickerCollectionCellOp(indexPath: IndexPath)
    {
        let image = self.GetImageFromIndex(item: indexPath.item)
        self.selectedImages[indexPath.item] = image
        self._selectedImageCount = self.selectedImages.count
        self.delegate?.imageDidSelect(self, index: indexPath.item, image: image)
        self.CountViewUpdate()
        if !self.allowMultipleSelection
        {
            self.MainViewCancelOp(velocity: 0)
        }
    }
    
    func PickerCollectionCellDeOp(indexPath: IndexPath)
    {
        let image = self.GetImageFromIndex(item: indexPath.item)
        self.selectedImages[indexPath.item] = nil
        self._selectedImageCount = self.selectedImages.count
        self.delegate?.imageDidDeselect(self, index: indexPath.item, image: image)
        self.CountViewUpdate()
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //print("offY: \(scrollView.contentOffset.y), isTracking: \(scrollView.isTracking)")
        if scrollView.contentOffset.y < -(self.titleView.bounds.height - self.intervalOfPictures) && scrollView.isTracking
        {
            scrollView.isScrollEnabled = false
        }
        if scrollView.contentOffset.y <= -(self.titleView.bounds.height - self.intervalOfPictures) && self.currentMainViewY == screenHeight / 2.0
        {
            scrollView.isScrollEnabled = false
        }
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.titleViewPanGesture
        {
            return false
        }
        return true
    }
    
}

