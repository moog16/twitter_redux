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
    var selectedViewController: UIViewController?
    let viewControllers = [
        TweetsViewController(nibName: "TweetsViewController", bundle: NSBundle.mainBundle()),
        UserProfieViewController(nibName: "UserProfieViewController", bundle: NSBundle.mainBundle())
    ]
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
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
        containerView = viewController.view
        containerView!.translatesAutoresizingMaskIntoConstraints = false
        viewController.didMoveToParentViewController(self)
        selectedViewController = viewController
    }
    
    func menuViewControllerDelegate(menuViewController: MenuViewController, selectedMenuTab: String) {
        var viewController: UIViewController?
        switch(selectedMenuTab) {
        case "Home Timeline":
            viewController = viewControllers[0]
        case "Profile":
            viewController = viewControllers[1]
        default:
            viewController = viewControllers[1]
        }
        selectViewController(viewController!)
    }
    
    
    private func addScrollView() {
//        scrollView!.delegate = self
        scrollView!.translatesAutoresizingMaskIntoConstraints = false
        scrollView!.pagingEnabled = true
        scrollView!.showsHorizontalScrollIndicator = false
        scrollView!.bounces = false
        view.addSubview(scrollView!)
    }
    
    private func addContainerView() {
        selectViewController(viewControllers[1])
        scrollView!.addSubview(containerView!)
    }
    
    private func addMenuView() {
        let menuViewController = MenuViewController(nibName: "MenuViewController", bundle: nil)
        self.addChildViewController(menuViewController)
        menuView = menuViewController.view
        menuView?.backgroundColor = UIColor.darkGrayColor()
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

        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[menuView(==scrollView)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[containerView(==scrollView)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
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
