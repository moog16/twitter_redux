//
//  ContainerViewController.swift
//  Twitter_Redux
//
//  Created by Matthew Goo on 10/9/15.
//  Copyright © 2015 mattgoo. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController, UIScrollViewDelegate, MenuViewControllerDelegate {
    var containerView: UIView?
    var menuView: UIView?
    var scrollView: UIScrollView?
    var selectedViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addScrollView()
        addContainerView()
        addMenuView()
        createContraints()
        
        
        let containerViewCenter = CGPoint(x: 250, y: menuView!.frame.height)
        let time = dispatch_time(DISPATCH_TIME_NOW, 0)
        
        dispatch_after(time, dispatch_get_main_queue(), {
            self.scrollView!.setContentOffset(containerViewCenter, animated: false)
        });
        
    }
    
    func selectViewController(viewController: UIViewController) {
        if let oldViewController = selectedViewController {
            oldViewController.willMoveToParentViewController(nil)
            oldViewController.view.removeFromSuperview()
            oldViewController.removeFromParentViewController()
        }
        
        self.addChildViewController(viewController)
        viewController.view.frame = (self.containerView?.bounds)!
        viewController.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.containerView!.addSubview(viewController.view)
        viewController.didMoveToParentViewController(self)
        selectedViewController = viewController
    }
    
    func menuViewControllerDelegate(menuViewController: MenuViewController, didTapMenuTab menuTab: String) {
        selectViewController(<#T##viewController: UIViewController##UIViewController#>)
    }
    
    
    private func addScrollView() {
        scrollView = UIScrollView()
        scrollView!.delegate = self
        scrollView!.translatesAutoresizingMaskIntoConstraints = false
        scrollView!.pagingEnabled = true
        scrollView!.showsHorizontalScrollIndicator = false
        scrollView!.bounces = false
        view.addSubview(scrollView!)
    }
    
    private func addContainerView() {
        containerView = UIView()
        containerView!.translatesAutoresizingMaskIntoConstraints = false
        containerView!.backgroundColor = UIColor.redColor()
        scrollView!.addSubview(containerView!)
    }
    
    private func addMenuView() {
        let menuViewController = MenuViewController(nibName: "MenuViewController", bundle: nil)
        self.addChildViewController(menuViewController)
        menuView = menuViewController.view
        menuView!.translatesAutoresizingMaskIntoConstraints = false
        scrollView!.addSubview(menuView!)
        menuViewController.didMoveToParentViewController(self)
    }
    
    private func createContraints() {
        let navigationBarHeight = navigationController!.navigationBar.frame.height + 20
        let views = [
            "menuView": menuView!,
            "containerView": containerView!,
            "scrollView": scrollView!,
            "view": view!
        ]
        let metrics = [
            "navigationBarHeight": navigationBarHeight
        ]

        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[scrollView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[scrollView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-navigationBarHeight-[menuView(==view)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[containerView(==view)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[menuView(250)][containerView(==view)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
