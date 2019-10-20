//
//  PresentTransition.swift
//  ConvenientImagePicker
//
//  Created by Land on 2019/10/17.
//

import UIKit

class PresentTransition2: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    var isPresent = true
    var isInteractive = false
    
    private var panGesture : UIPanGestureRecognizer!
    var PickerVC : UIViewController!
    
    var velocity: CGFloat = 0
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.5
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
            guard let toVC = transitionContext.viewController(forKey: .to) else {return}
            guard let fromVC = toVC.presentingViewController else {return}
            guard let fromView = fromVC.view else {return}
            let theUpper = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
            self.PickerVC = toVC
            
            self.panGesture = UIPanGestureRecognizer()
            self.panGesture.addTarget(self, action: #selector(Panned(_:)))
            toView.addGestureRecognizer(self.panGesture)
            
            toView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 0 + 50)
            toView.layer.cornerRadius = 20
            theUpper.backgroundColor = UIColor.black
            theUpper.alpha = 0

            fromView.addSubview(theUpper)
            container.addSubview(fromView)
            container.addSubview(toView)
            
            let duration = self.transitionDuration(using: transitionContext)
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: velocity, options: [.allowUserInteraction], animations: {
                toView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height / 2.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2.0 + 50)
                theUpper.alpha = 0.3
            }) { (true) in
                transitionContext.completeTransition(true)
            }
        }
        else
        {
            guard let fromView = transitionContext.view(forKey: .from) else {return}
            guard let fromVC = transitionContext.viewController(forKey: .from) else {return}
            guard let toVC = fromVC.presentedViewController else {return}
            guard let toView = toVC.view else {return}
            let theUpper = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
            
            fromView.layer.cornerRadius = 20
            theUpper.backgroundColor = UIColor.black
            theUpper.alpha = 0.3

            toView.addSubview(theUpper)
            container.addSubview(fromView)
            container.addSubview(toView)
            
            let duration = self.transitionDuration(using: transitionContext)
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity, options: [.allowUserInteraction], animations: {
                fromView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 0 + 50)
                theUpper.alpha = 0
            }) { (true) in
                transitionContext.completeTransition(true)
            }
        }
    }
    
    
    @objc func Panned(_ gesture: UIPanGestureRecognizer)
    {
        if gesture.state == .began
        {
            self.isInteractive = true
            self.PickerVC.dismiss(animated: true, completion: nil)
        }
        self.update(0.5)
    }
    
    
    
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.isPresent = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.isPresent = false
        return self
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.isInteractive ? self : nil
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.isInteractive ? self : nil
    }
    
    
}
