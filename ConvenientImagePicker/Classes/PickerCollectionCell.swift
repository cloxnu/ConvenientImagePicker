//
//  PickerCollectionCell.swift
//  ConvenientImagePicker
//
//  Created by Land on 2019/10/18.
//

import UIKit

class PickerCollectionCell: UICollectionViewCell {
    
    var image: UIImageView!
    var selectedImageView: UIImageView!
    var upper: UIView!
    
    var customSelectedImage: UIImage?
    var selectedImageHeightCons: NSLayoutConstraint?
    var selectedImageWidthCons: NSLayoutConstraint?
    var selectedImageTrailingCons: NSLayoutConstraint?
    var selectedImageBottomCons: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        let traitCollection = UITraitCollection(displayScale: 2)
//        var bundle = Bundle(for: PickerCollectionCell.self)

//        if let resource = bundle.resourcePath, let resourceBundle = Bundle(path: resource + "/ConvenientImagePicker.bundle") {
//          bundle = resourceBundle
//        }
//
//        let selectedImage = UIImage(named: "SelectedImage", in: bundle, compatibleWith: traitCollection) ?? UIImage()
        
//        let bundlePath = Bundle.init(for: self.classForCoder).resourcePath?.appending("ConvenientImagePicker.bundle")
//        let resource = Bundle.init(path: bundlePath!)
//        let selectedImage = UIImage(named: "SelectedImage", in: resource, compatibleWith: nil)
        
        let bundle = Bundle.init(for: self.classForCoder)
        let url = bundle.url(forResource: "ConvenientImagePicker", withExtension: "bundle")
        let targetBundle = Bundle.init(url: url!)
        let selectedImage = UIImage.init(named: "SelectedImage", in: targetBundle, compatibleWith: nil)
        
//        let currentBundle = Bundle(for: type(of: self))
//        let bundleName = (currentBundle.infoDictionary? ["CFBundleName"] as! NSString).appending(".bundle")
//        let path = currentBundle.path(forResource: "SelectedImage@2x.png", ofType: nil, inDirectory: bundleName)
//        let selectedImage = UIImage(contentsOfFile: path!)
        
        self.image = UIImageView(frame: CGRect(origin: CGPoint.zero, size: frame.size))
        self.image.contentMode = .scaleAspectFill
        self.image.clipsToBounds = true
        
        self.upper = UIView(frame: CGRect(origin: CGPoint.zero, size: frame.size))
        self.upper.backgroundColor = UIColor.white
        self.upper.alpha = 0
        
        self.selectedImageView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: frame.size))
        self.selectedImageView.alpha = 0
        self.selectedImageView.image = self.customSelectedImage ?? selectedImage
        //self.selectedImageView.backgroundColor = UIColor.black
        self.selectedImageView.contentMode = .scaleAspectFill
        self.selectedImageView.clipsToBounds = true
        
        self.addSubview(self.image)
        self.addSubview(self.upper)
        self.addSubview(self.selectedImageView)

        self.image.translatesAutoresizingMaskIntoConstraints = false
        let cons1 = NSLayoutConstraint(item: self.image!, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0)
        let cons2 = NSLayoutConstraint(item: self.image!, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0)
        let cons3 = NSLayoutConstraint(item: self.image!, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
        let cons4 = NSLayoutConstraint(item: self.image!, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
        
        self.selectedImageView.translatesAutoresizingMaskIntoConstraints = false
        self.selectedImageHeightCons = NSLayoutConstraint(item: self.selectedImageView!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 20)
        self.selectedImageTrailingCons = NSLayoutConstraint(item: self.selectedImageView!, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: -10)
        self.selectedImageWidthCons = NSLayoutConstraint(item: self.selectedImageView!, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 20)
        self.selectedImageBottomCons = NSLayoutConstraint(item: self.selectedImageView!, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: -10)
        
        self.upper.translatesAutoresizingMaskIntoConstraints = false
        let cons9 = NSLayoutConstraint(item: self.upper!, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 3)
        let cons10 = NSLayoutConstraint(item: self.upper!, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: -3)
        let cons11 = NSLayoutConstraint(item: self.upper!, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 3)
        let cons12 = NSLayoutConstraint(item: self.upper!, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: -3)
        
        cons1.isActive = true
        cons2.isActive = true
        cons3.isActive = true
        cons4.isActive = true
        self.selectedImageHeightCons?.isActive = true
        self.selectedImageTrailingCons?.isActive = true
        self.selectedImageWidthCons?.isActive = true
        self.selectedImageBottomCons?.isActive = true
        cons9.isActive = true
        cons10.isActive = true
        cons11.isActive = true
        cons12.isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
