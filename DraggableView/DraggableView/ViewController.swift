//
//  ViewController.swift
//  DraggableView
//
//  Created by Maxim on 04.09.16.
//  Copyright © 2016 Maxim. All rights reserved.
//

import UIKit
import ARNTransitionAnimator

class ViewController: UIViewController, DraggableMenuDelegate {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var optionBar: UIView!
    @IBOutlet weak var menuOpenButton: UIBarButtonItem!
    @IBOutlet weak var dismissButton: UIBarButtonItem!
    @IBOutlet weak var dragMenuView: UIView!
    @IBOutlet weak var detailContainerView: UIView!
    
    private var animator: ARNTransitionAnimator!
    private var detailViewController: DraggableMenuController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        detailViewController = storyboard.instantiateViewControllerWithIdentifier("DraggableMenuController") as? DraggableMenuController
        detailViewController.modalPresentationStyle = .OverCurrentContext // можно изменить
        detailViewController.tapCloseButtonActionHandler = { [unowned self] in
            self.animator.interactiveType = .None
        }
        
        detailViewController.delegate = self
        
        dismissButton.enabled = false
        setupAnimator()
    }
    
    func setupAnimator() {
        animator = ARNTransitionAnimator(operationType: .Present, fromVC: self, toVC: detailViewController)
        animator.usingSpringWithDamping = 0.8
        animator.gestureTargetView = dragMenuView
        animator.interactiveType = .Present
        
        // Present detailViewController - презентация модального экрана
        
        animator.presentationBeforeHandler = { [unowned self] containerView, transitionContext in
            print("start presentation")
            self.beginAppearanceTransition(false, animated: false)
            
            self.animator.direction = .Top
            
            self.detailViewController.view.frame.origin.y = self.optionBar.frame.origin.y + self.optionBar.frame.size.height
            
            self.detailContainerView.insertSubview(self.detailViewController.view, atIndex: 0)
            //self.view.insertSubview(self.detailViewController.view, belowSubview: self.optionBar)
            
            self.view.layoutIfNeeded()
            self.detailViewController.view.layoutIfNeeded()
            
            // optionBarView
            let startOriginY = self.optionBar.frame.origin.y
            print("startOriginY = \(startOriginY)")
            let endOriginY = -self.optionBar.frame.size.height
            print("endOriginY = \(endOriginY)")
            let diff = -endOriginY + startOriginY
        
            let tabStartOriginY = self.optionBar.frame.origin.y
            print("tabStartOriginY = \(tabStartOriginY)")
            
            let tabEndOriginY = tabStartOriginY
                //containerView.frame.size.height
            print("tabEndOriginY = \(tabEndOriginY)")
            let tabDiff = tabEndOriginY - tabStartOriginY
            
            self.animator.presentationCancelAnimationHandler = { containerView in
                self.optionBar.frame.origin.y = startOriginY
                self.detailViewController.view.frame.origin.y = self.optionBar.frame.origin.y + self.optionBar.frame.size.height
                self.optionBar.frame.origin.y = tabStartOriginY
                self.containerView.alpha = 1.0
                self.optionBar.alpha = 1.0
                self.optionBar.alpha = 1.0
                for subview in self.optionBar.subviews {
                    subview.alpha = 1.0
                }
            }
            
            self.animator.presentationAnimationHandler = { [unowned self] containerView, percentComplete in
                let _percentComplete = percentComplete >= 0 ? percentComplete : 0
                self.optionBar.frame.origin.y = startOriginY - (diff * _percentComplete)
                if self.optionBar.frame.origin.y < endOriginY {
                    self.optionBar.frame.origin.y = endOriginY
                }
                self.detailViewController.view.frame.origin.y = self.optionBar.frame.origin.y + self.optionBar.frame.size.height
                self.optionBar.frame.origin.y = tabStartOriginY + (tabDiff * _percentComplete)
                if self.optionBar.frame.origin.y > tabEndOriginY {
                    self.optionBar.frame.origin.y = tabEndOriginY
                }
                
                let alpha = 1.0 - (1.0 * _percentComplete)
                self.containerView.alpha = alpha + 0.5
                self.optionBar.alpha = alpha
                for subview in self.optionBar.subviews {
                    subview.alpha = alpha
                }
            }
            
            self.animator.presentationCompletionHandler = { containerView, completeTransition in
                self.endAppearanceTransition()
                
                if completeTransition {
                    self.optionBar.alpha = 0.0
                    self.detailViewController.view.removeFromSuperview()
                    containerView.addSubview(self.detailViewController.view)
                    self.animator.interactiveType = .Dismiss
                    self.animator.gestureTargetView = self.detailViewController.view
                    self.menuOpenButton.enabled = false
                    self.dismissButton.enabled = true
                    self.animator.direction = .Bottom
                } else {
                    self.beginAppearanceTransition(true, animated: false)
                    self.endAppearanceTransition()
                }
            }
        }
        
        // Dismiss detailViewController
        
        animator.dismissalBeforeHandler = { [unowned self] containerView, transitionContext in
            print("start dismissal")
            self.beginAppearanceTransition(true, animated: false)
            
            self.view.insertSubview(self.detailViewController.view, belowSubview: self.optionBar)
            
            self.view.layoutIfNeeded()
            self.detailViewController.view.layoutIfNeeded()
            
            // optionBarView
            let startOriginY = 0 - self.optionBar.bounds.size.height
            let endOriginY = self.containerView.bounds.size.height - self.optionBar.bounds.size.height - self.optionBar.frame.size.height
            let diff = -startOriginY + endOriginY
            
            let tabStartOriginY = containerView.bounds.size.height
            let tabEndOriginY = containerView.bounds.size.height - self.optionBar.bounds.size.height
            let tabDiff = tabStartOriginY - tabEndOriginY
            
            self.optionBar.frame.origin.y = containerView.bounds.size.height
            self.containerView.alpha = 0.5
            
            self.animator.dismissalCancelAnimationHandler = { containerView in
                self.optionBar.frame.origin.y = startOriginY
                self.detailViewController.view.frame.origin.y = self.optionBar.frame.origin.y + self.optionBar.frame.size.height
                self.optionBar.frame.origin.y = tabStartOriginY
                self.containerView.alpha = 0.5
                self.optionBar.alpha = 0.0
                self.optionBar.alpha = 0.0
                for subview in self.optionBar.subviews {
                    subview.alpha = 0.0
                }
            }
            
            self.animator.dismissalAnimationHandler = { containerView, percentComplete in
                let _percentComplete = percentComplete >= -0.05 ? percentComplete : -0.05
                self.optionBar.frame.origin.y = startOriginY + (diff * _percentComplete)
                self.detailViewController.view.frame.origin.y = self.optionBar.frame.origin.y + self.optionBar.frame.size.height
                self.optionBar.frame.origin.y = tabStartOriginY - (tabDiff *  _percentComplete)
                
                let alpha = 1.0 * _percentComplete
                self.containerView.alpha = alpha + 0.5
                self.optionBar.alpha = alpha
                self.optionBar.alpha = 1.0
                for subview in self.optionBar.subviews {
                    subview.alpha = alpha
                }
            }
            
            self.animator.dismissalCompletionHandler = { containerView, completeTransition in
                self.endAppearanceTransition()
                
                if completeTransition {
                    self.detailViewController.view.removeFromSuperview()
                    self.animator.gestureTargetView = self.dragMenuView
                    self.menuOpenButton.enabled = true
                    self.dismissButton.enabled = false
                    self.animator.interactiveType = .Present
                } else {
                    self.detailViewController.view.removeFromSuperview()
                    containerView.addSubview(self.detailViewController.view)
                    self.beginAppearanceTransition(false, animated: false)
                    self.endAppearanceTransition()
                }
            }
        }
        
        detailViewController.transitioningDelegate = animator
    }

    
    @IBAction func openDraggableMenu() {
        animator.interactiveType = .None
        dismissButton.enabled = true
        menuOpenButton.enabled = false
        assert(detailViewController.delegate != nil, "Delegate для detailViewController назначен")
        presentViewController(detailViewController, animated: true, completion: nil)
    }

    @IBAction func dismissDraggableMenu() {
        animator.interactiveType = .None
        dismissViewControllerAnimated(true, completion: nil)
        dismissButton.enabled = false
        menuOpenButton.enabled = true
    }
}

extension ViewController {
    
    func cellDidSelected(with type: ListElement) -> ListElement {
        print("Cell did selected")
        let object = ListElement()
        return object
    }
}

