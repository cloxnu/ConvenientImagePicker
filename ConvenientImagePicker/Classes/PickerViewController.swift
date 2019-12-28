//
//  PickerViewController.swift
//  ConvenientImagePicker
//
//  Created by Land on 2019/10/16.
//

import UIKit
import Photos

let screenHeight = { () -> CGFloat in return UIScreen.main.bounds.height }
let screenWidth = { () -> CGFloat in UIScreen.main.bounds.width }
let statusBarHeight = UIApplication.shared.statusBarFrame.height


@objc public protocol ConvenientImagePickerDelegate {
    
    func imagePickerDidCancel(_ selectedImages: [Int : UIImage])
    func imageDidSelect(_ imagePicker: PickerViewController, index: Int, image: UIImage?)
    func imageDidDeselect(_ imagePicker: PickerViewController, index: Int, image: UIImage?)
    func imageSelectMax(_ imagePicker: PickerViewController, wantToSelectIndex: Int, wantToSelectImage: UIImage?)
}

public class PickerViewController: UIViewController {
    
    public weak var delegate: ConvenientImagePickerDelegate?
    
    internal var _selectedImageCount = 0
    public var selectedImageCount: Int { get{ return _selectedImageCount} }
    
    /// The maximum number of pictures allowed.
    public var maxNumberOfSelectedImage = 50
    /// A Boolean value that determines whether the picker view can mutiple selection.
    public var allowMultipleSelection = true
    public var maxSizeOfPicture = 1000
    /// The number of pictures in a row.
    public var numberOfPictureInRow = 4
    /// The interval between pictures.
    public var intervalOfPictures: CGFloat = 5
    /// A Boolean value that determines whether the title label, count view, and close button are exist.
    public var isSimpleMode = true
    /// The displayed images, it's will be photo library if nil.
    public var images: [UIImage]?
    /// A Boolean value that determines whether darkmode enable.
    public var isDarkMode = false
    /// A Boolean value that determines whether darkmode can switched automately. (only iOS 13 valid)
    public var isSwitchDarkAutomately = true
    /// A set of index of selected image when the picker appears.
    public var initialSelectedIndex = Set<Int>()
    /// A Boolean value that determines whether the appear animation is exist.
    public var isAnimated = true
    /// A selectedImage type value that relates to the image of selected picture.
    public var customSelectedImage = selectedImage()
    /// A Boolean value that determines whether the ability of landscape.
    public var isSupportLandscape = false
    
//    public var backgroundColor: UIColor = UIColor.white
//    public var titleColor: UIColor = UIColor.black
//    public var titleText: String = "Please select picture"
//    public var buttonTintColor: UIColor?
//    public var buttonTitle: String = "Done"
//    public var countTextColor: UIColor = UIColor.white
    
    public class selectedImage {
        public var image: UIImage?
        public var width: CGFloat = 20
        public var height: CGFloat = 20
        public var trailing: CGFloat = 10
        public var bottom: CGFloat = 10
        
        public init(image: UIImage?, width: CGFloat?, height: CGFloat?, trailing: CGFloat?, bottom: CGFloat?) {
            self.image = image
            self.width = width ?? self.width
            self.height = height ?? self.height
            self.trailing = trailing ?? self.trailing
            self.bottom = bottom ?? self.bottom
        }
        
        public convenience init() {
            self.init(image: nil, width: nil, height: nil, trailing: nil, bottom: nil)
        }
    }
    
    
    let transition = PresentTransition()
    var isDesideToCancel = false
    
    var backView = UIView()
    public var mainView = UIView()
    public var titleView = UIView()
    public var decorationBar = UIView()
    public var countLabel = UILabel()
    public var titleLabel = UILabel()
    public var doneButton = UIButton(type: .system)
    
    public var titleViewEffectView = UIVisualEffectView()
    
    func resetViewsFrame()
    {
        self.backView.frame = CGRect(x: 0, y: 0, width: screenWidth(), height: screenHeight())
        self.mainView.frame = CGRect(x: 0, y: screenHeight(), width: screenWidth(), height: screenHeight() + 50.0)
        self.titleView.frame = CGRect(x: 0, y: 0, width: screenWidth(), height: 15)
        self.decorationBar.frame = CGRect(x: screenWidth() / 2.0 - 40, y: 5, width: 80, height: 5)
        self.countLabel.frame = CGRect(x: 15, y: 15, width: 30, height: 30)
        self.titleLabel.frame = CGRect(x: 60, y: 0, width: screenWidth() - 150, height: 60)
        self.doneButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        self.titleViewEffectView.frame = CGRect(x: 0, y: 0, width: screenWidth(), height: 60)
    }
    func resetAllView()
    {
        self.backView.frame = CGRect(x: 0, y: 0, width: screenWidth(), height: screenHeight())
        self.backView.alpha = 0
        self.backView.backgroundColor = UIColor.black
        
        self.mainView.frame = CGRect(x: 0, y: screenHeight(), width: screenWidth(), height: screenHeight() + 50.0)
        self.mainView.layer.cornerRadius = 10.0
        self.mainView.clipsToBounds = true
        self.mainView.backgroundColor = UIColor.white
        
        self.titleView.frame = CGRect(x: 0, y: 0, width: screenWidth(), height: 15)
        self.titleView.clipsToBounds = true
        self.titleView.backgroundColor = UIColor.white
        
        self.decorationBar.frame = CGRect(x: screenWidth() / 2.0 - 40, y: 5, width: 80, height: 5)
        self.decorationBar.clipsToBounds = true
        self.decorationBar.layer.cornerRadius = 2.5
        self.decorationBar.backgroundColor = UIColor.black
        
        self.countLabel.frame = CGRect(x: 15, y: 15, width: 30, height: 30)
        self.countLabel.backgroundColor = UIColor.lightGray
        self.countLabel.textColor = UIColor.white
        self.countLabel.textAlignment = .center
        self.countLabel.font = UIFont.boldSystemFont(ofSize: 20)
        self.countLabel.text = "0"
        self.countLabel.clipsToBounds = true
        self.countLabel.layer.cornerRadius = 15
        
        self.titleLabel.frame = CGRect(x: 60, y: 0, width: screenWidth() - 150, height: 60)
        self.titleLabel.textColor = UIColor.black
        self.titleLabel.textAlignment = .center
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        self.titleLabel.text = "Please select picture"
        self.titleLabel.clipsToBounds = true
        
        self.doneButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        self.doneButton.titleLabel?.textAlignment = .right
        self.doneButton.frame = CGRect(x: screenWidth() - 75, y: 0, width: 60, height: 60)
        self.doneButton.setTitle("Done", for: .normal)
        
        self.titleViewEffectView.frame = CGRect(x: 0, y: 0, width: screenWidth(), height: 60)
        let blur = UIBlurEffect(style: .extraLight)
        self.titleViewEffectView.effect = blur
    }
    
    public var collectionView : UICollectionView!
    var imagesResource = [UIImage]()
    
    let panGesture = UIPanGestureRecognizer()
    let collectionViewPanGesture = UIPanGestureRecognizer()
    let titleViewPanGesture = UIPanGestureRecognizer()
    
    let cancelTapGesture = UITapGestureRecognizer()
    let titleViewTapGesture = UITapGestureRecognizer()
    
    var assetsFetchResults: PHFetchResult<PHAsset>!
    var imageManager: PHCachingImageManager!
    
    var selectedImagesIndex = Set<Int>()
    
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.configure()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.configure()
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.screenHasRotation), name: .UIDeviceOrientationDidChange, object: nil)
        
        self.view.addSubview(self.backView)
        self.view.addSubview(self.mainView)
        
        self.selectedImagesIndex = self.initialSelectedIndex
        self.titleView.frame = CGRect(x: 0, y: 0, width: screenWidth(), height: self.isSimpleMode ? 15 : 60)
        
        self.PangestureInit()
        self.OtherViewInit()
        self.TitleViewInit()
        // Do any additional setup after loading the view.
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        //self.view.addSubview(self.mainView)

        self.isDarkMode = self.isSystemDarkMode(traitCollection: self.traitCollection)
        self.UpdateDarkMode()
        self.MainViewMoveToCenterOp(velocity: 0, isAnimated: self.isAnimated)
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection)
            {
                if self.isSwitchDarkAutomately
                {
                    self.isDarkMode = self.isSystemDarkMode(traitCollection: self.traitCollection)
                    self.UpdateDarkMode()
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    var currentRotation = { () -> UIDeviceOrientation in
        switch UIDevice.current.orientation
        {
        case .landscapeLeft:
            return .landscapeLeft
        case .landscapeRight:
            return .landscapeRight
        default:
            return .portrait
        }
        
    }()
    @objc func screenHasRotation()
    {
        if !self.isSupportLandscape
        {
            return
        }
        let ori = UIDevice.current.orientation
        if ori != .landscapeLeft && ori != .landscapeRight && ori != .portrait
        {
            return
        }
        if ori != currentRotation
        {
            self.currentRotation = UIDevice.current.orientation
            self.resetViewsFrame()
            self.titleView.frame = CGRect(x: 0, y: 0, width: screenWidth(), height: self.isSimpleMode ? 15 : 60)
            
            self.UpdateCollectionView()
        }
    }
    
    let BackgroundAlpha: CGFloat = 0.5
    
    func configure()
    {
        self.modalPresentationStyle = .custom
        self.modalTransitionStyle = .coverVertical
        self.transitioningDelegate = self.transition
        self.resetAllView()
    }
    
    
    
    // MARK: - MainViewMoveOp
    
    var currentMainViewY = screenHeight()
    func MainViewMoveToCenterOp(velocity: CGFloat, isAnimated: Bool)
    {
        let distination = screenHeight() / 2.0
        let v = velocity / abs(distination - self.currentMainViewY) //Conversion unit
        self.currentMainViewY = distination
        
        if isAnimated
        {
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: v, options: [.allowUserInteraction, .curveEaseInOut], animations: {
                self.mainView.frame = CGRect(x: 0, y: screenHeight() / 2.0, width: screenWidth(), height: screenHeight() + 50.0)
                self.backView.alpha = self.BackgroundAlpha
            }, completion: nil)
        }
        else
        {
            self.mainView.frame = CGRect(x: 0, y: screenHeight() / 2.0, width: screenWidth(), height: screenHeight() + 50.0)
            self.backView.alpha = self.BackgroundAlpha
        }
    }
    
    func MainViewMoveToTopOp(velocity: CGFloat)
    {
        let distination = statusBarHeight
        let v = velocity / abs(distination - self.currentMainViewY) //Conversion unit
        self.currentMainViewY = distination
        self.collectionView.isScrollEnabled = true
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: v, options: [.allowUserInteraction, .curveEaseInOut], animations: {
            self.mainView.frame = CGRect(x: 0, y: statusBarHeight, width: screenWidth(), height: screenHeight() + 50.0)
            self.backView.alpha = self.BackgroundAlpha
        }, completion: nil)
    }
    
    func MainViewCancelOp(velocity: CGFloat)
    {
        if self.isDesideToCancel
        {
            return
        }
        self.isDesideToCancel = true
        let distination = screenHeight()
        let v = velocity / abs(distination - self.currentMainViewY) //Conversion unit
        self.currentMainViewY = distination
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: v, options: [.allowUserInteraction, .curveEaseInOut], animations: {
            self.mainView.frame = CGRect(x: 0, y: screenHeight(), width: screenWidth(), height: screenHeight() + 50.0)
            self.backView.alpha = 0
        }) { (true) in
            var selectedImages = [Int : UIImage]()
            for oneIndex in self.selectedImagesIndex
            {
                selectedImages[oneIndex] = self.GetImageFromIndex(item: oneIndex)
            }
            self.delegate?.imagePickerDidCancel(selectedImages)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func MainViewMoveOp()
    {
        self.mainView.frame = CGRect(x: 0, y: self.currentMainViewY, width: screenWidth(), height: screenHeight() + 50.0)
        self.backView.alpha = self.CalculateForBackgroundAlpha(Y: self.currentMainViewY)
//        UIView.animate(withDuration: 0.1, delay: 0, options: [.allowUserInteraction, .curveEaseInOut], animations: {
//            self.mainView.frame = CGRect(x: 0, y: self.currentMainViewY, width: screenWidth(), height: screenHeight() + 50.0)
//            self.backView.backgroundColor = UIColor.init(white: 0, alpha: self.CalculateForBackgroundAlpha(Y: self.currentMainViewY))
//        }, completion: nil)
    }
    
    func CalculateForBackgroundAlpha(Y: CGFloat) -> CGFloat
    {
        if Y >= screenHeight() / 2.0 && Y <= screenHeight()
        {
            return (1.0 - (Y - screenHeight() / 2.0) / (screenHeight() / 2.0)) * self.BackgroundAlpha
        }
        else if Y > screenHeight()
        {
            return 0
        }
        else
        {
            return self.BackgroundAlpha
        }
    }
    
    func MainViewMoveToWhere(velocityY: CGFloat)
    {
        let vFast: CGFloat = 200
        
        switch self.currentMainViewY
        {
        case ..<((screenHeight() / 2.0 - statusBarHeight) / 2.0):
            if velocityY >= vFast
            {
                self.MainViewMoveToCenterOp(velocity: abs(velocityY), isAnimated: true)
            }
            else
            {
                self.MainViewMoveToTopOp(velocity: abs(velocityY))
            }
        case ((screenHeight() / 2.0 - statusBarHeight) / 2.0) ... screenHeight() / 2.0:
            if velocityY <= -vFast
            {
                self.MainViewMoveToTopOp(velocity: abs(velocityY))
            }
            else
            {
                self.MainViewMoveToCenterOp(velocity: abs(velocityY), isAnimated: true)
            }
        case screenHeight() / 2.0 ... screenHeight() * 3.0 / 4.0:
            if velocityY >= vFast
            {
                self.MainViewCancelOp(velocity: abs(velocityY))
            }
            else
            {
                self.MainViewMoveToCenterOp(velocity: abs(velocityY), isAnimated: true)
            }
        default:
            if velocityY <= -vFast
            {
                self.MainViewMoveToCenterOp(velocity: abs(velocityY), isAnimated: true)
            }
            else
            {
                self.MainViewCancelOp(velocity: abs(velocityY))
            }
        }
    }
    
    
    
    // MARK: - TitlePanGesture
    
    func TitlePanGestureInit()
    {
        self.titleViewPanGesture.delegate = self
        self.titleViewPanGesture.addTarget(self, action: #selector(titlePanned(_:)))
        self.titleView.addGestureRecognizer(self.titleViewPanGesture)
    }
    
    var titleViewStartY: CGFloat = 0
    @objc func titlePanned(_ gesture : UIPanGestureRecognizer)
    {
        switch gesture.state
        {
        case .began:
            self.titleViewStartY = self.currentMainViewY
        case .changed:
            let gestureY = self.titleViewStartY + gesture.translation(in: gesture.view).y
            self.currentMainViewY = gestureY <= statusBarHeight ? statusBarHeight : gestureY
            self.MainViewMoveOp()
        case .ended:
            let velocityY = gesture.velocity(in: gesture.view).y
            self.MainViewMoveToWhere(velocityY: velocityY)
        case .cancelled, .failed:
            self.MainViewMoveToWhere(velocityY: 0)
        default:
            break
        }
    }
    
    // MARK: - PanGesture
    
    func PangestureInit()
    {
        self.panGesture.delegate = self
        self.panGesture.addTarget(self, action: #selector(Panned(_:)))
        self.mainView.addGestureRecognizer(self.panGesture)
        
        self.cancelTapGesture.addTarget(self, action: #selector(viewTapped(_:)))
        self.backView.addGestureRecognizer(cancelTapGesture)
    }
    
    @objc func viewTapped(_ gesture : UITapGestureRecognizer)
    {
        self.MainViewCancelOp(velocity: 0)
    }
    
    var MainViewStartY: CGFloat?
    @objc func Panned(_ gesture : UIPanGestureRecognizer)
    {
        if self.collectionView.isScrollEnabled
        {
            return
        }
        switch gesture.state
        {
        case .began:
            self.MainViewStartY = self.currentMainViewY
        case .changed:
            self.MainViewStartY = self.MainViewStartY == nil ? self.currentMainViewY - gesture.translation(in: gesture.view).y : self.MainViewStartY
            let gestureY = self.MainViewStartY! + gesture.translation(in: gesture.view).y
            self.currentMainViewY = gestureY <= statusBarHeight ? statusBarHeight : gestureY
            self.MainViewMoveOp()
        case .ended:
            let velocityY = gesture.velocity(in: gesture.view).y
            self.MainViewMoveToWhere(velocityY: velocityY)
            self.MainViewStartY = nil
        case .cancelled, .failed:
            self.MainViewMoveToWhere(velocityY: 0)
            self.MainViewStartY = nil
        default:
            break
        }
    }
    
    
    // MARK: - OtherView
    
    func OtherViewInit()
    {
        self.collectionViewInit()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


