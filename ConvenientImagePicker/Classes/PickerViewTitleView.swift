//
//  PickerViewTitleView.swift
//  ConvenientImagePicker
//
//  Created by Land on 2019/10/19.
//

import Foundation
import UIKit


extension PickerViewController
{
    
    func TitleViewInit()
    {
        self.TitlePanGestureInit()
        self.titleViewTapGesture.addTarget(self, action: #selector(titleTapped(_:)))
        self.titleView.addGestureRecognizer(self.titleViewTapGesture)
        
        self.titleView.backgroundColor = UIColor.clear
        
        if !self.isSimpleMode
        {
//            self.titleLabel.textColor = self.titleColor
//            self.titleLabel.text = self.titleText
//            self.countLabel.textColor = self.countTextColor
            self.doneButton.addTarget(self, action: #selector(buttonUpInside(_:)), for: .touchUpInside)
//            self.doneButton.setTitle(self.buttonTitle, for: UIControlState.normal)
//            if self.buttonTintColor != nil
//            {
//                self.doneButton.tintColor = self.buttonTintColor!
//            }
        }
        
        
        self.titleView.addSubview(self.titleViewEffectView)
        
        if !self.isSimpleMode
        {
            self.titleView.addSubview(self.titleLabel)
            self.titleView.addSubview(self.countLabel)
            self.titleView.addSubview(self.doneButton)
        }
        else
        {
            self.titleView.addSubview(self.decorationBar)
        }
        
        self.mainView.addSubview(self.titleView)
    }
    
    @objc func buttonUpInside(_ button : UIButton)
    {
        self.MainViewCancelOp(velocity: 0)
    }
    
    @objc func titleTapped(_ gesture: UITapGestureRecognizer)
    {
        self.MainViewMoveToCenterOp(velocity: 0, isAnimated: true)
    }
    
    func isSystemDarkMode(traitCollection: UITraitCollection) -> Bool
    {
        if #available(iOS 13.0, *)
        {
            return traitCollection.userInterfaceStyle == .dark ? true : false
        }
        return false
    }
    
    func UpdateDarkMode()
    {
        self.decorationBar.backgroundColor = self.isDarkMode ? UIColor.white : UIColor.black
        self.titleViewEffectView.effect = UIBlurEffect(style: self.isDarkMode ? .dark : .extraLight)
        self.mainView.backgroundColor = self.isDarkMode ? UIColor.black : UIColor.white
        self.countLabel.textColor = self.isDarkMode ? UIColor.black : UIColor.white
        self.titleLabel.textColor = self.isDarkMode ? UIColor.white : UIColor.black
    }
    
    func CountViewUpdate()
    {
        self.countLabel.text = String(self.selectedImageCount)
        UIView.animate(withDuration: 0.1) {
            if self.countLabel.text!.count >= 2
            {
                self.countLabel.frame = CGRect(x: 15, y: 15, width: 45, height: 30)
            }
            else
            {
                self.countLabel.frame = CGRect(x: 15, y: 15, width: 30, height: 30)
            }
            
            if self.selectedImageCount == 0
            {
                self.countLabel.backgroundColor = UIColor.lightGray
            }
            else
            {
                self.countLabel.backgroundColor = UIColor.systemBlue
            }
        }
        
    }
}
