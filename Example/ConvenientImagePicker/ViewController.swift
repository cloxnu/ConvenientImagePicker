//
//  ViewController.swift
//  ConvenientImagePicker
//
//  Created by CLOX on 10/16/2019.
//  Copyright (c) 2019 CLOX. All rights reserved.
//

import UIKit
import ConvenientImagePicker

class ViewController: UIViewController {
    
    let button = UIButton(type: UIButtonType.system)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.button.setTitle("Trigger Image Picker", for: UIControlState.normal)
        self.button.frame = CGRect(x: 50, y: 50, width: 200, height: 100)
        self.button.addTarget(self, action: #selector(buttonUpInside(_:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(self.button)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    @objc func buttonUpInside(_ button : UIButton)
    {
        let pickerViewController = PickerViewController()
        pickerViewController.maxNumberOfSelectedImage = 15
        
        //pickerViewController.allowMultipleSelection = false
        //pickerViewController.images = [UIImage()]
        //pickerViewController.allowMultipleSelection = false
        if #available(iOS 13.0, *) {
            //pickerViewController.mainView.backgroundColor = UIColor.systemBackground
            //pickerViewController.titleViewEffectView.effect = UIBlurEffect(style: UIBlurEffectStyle.dark)
            //pickerViewController.decorationBar.backgroundColor = UIColor.white
//            pickerViewController.countLabel.textColor = UIColor.systemBackground
//            pickerViewController.titleLabel.textColor = UIColor.white
        } else {
            // Fallback on earlier versions
        }
        self.present(pickerViewController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

