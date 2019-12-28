//
//  PresentTransition.swift
//  ConvenientImagePicker
//
//  Created by Land on 2019/10/17.
//

import UIKit

class PresentTransition: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    var isPresent = true
    
    var velocity: CGFloat = 0
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let container = transitionContext.containerView
//        print("in")
//        guard let fromView = transitionContext.view(forKey: .from) else {return}
//        guard let toView = transitionContext.view(forKey: .to) else {return}
//        print("in2")
//
//        let theUpper = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        
        if self.isPresent
        {
            //guard let fromView = transitionContext.view(forKey: .from) else {return}
            guard let toView = transitionContext.view(forKey: .to) else {return}
            
            if let toVC = transitionContext.viewController(forKey: .to) as? PickerViewController
            {
                if toVC.isAnimated
                {
                    toVC.isAnimated = transitionContext.isAnimated
                }
            }
            
            toView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            container.addSubview(toView)
            transitionContext.completeTransition(true)
        }
        else
        {
            guard let fromView = transitionContext.view(forKey: .from) else {return}
            
            fromView.alpha = 0
            container.addSubview(fromView)
            transitionContext.completeTransition(true)
        }
    }
    
    
    
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.isPresent = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.isPresent = false
        return self
    }
    
    
}
