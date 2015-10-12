//
//  ContainerViewController.swift
//  Twitter_Redux
//
//  Created by Matthew Goo on 10/9/15.
//  Copyright © 2015 mattgoo. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController, UIScrollViewDelegate, MenuViewControllerDelegate, TweetsViewControllerDelegate {
    var containerView: UIView?
    var menuView: UIView?
    var selectedViewController: UIViewController?
    let viewControllers = [
        TweetsViewController(nibName: "TweetsViewController", bundle: NSBundle.mainBundle()),
        UserProfileViewController(nibName: "UserProfileViewController", bundle: NSBundle.mainBundle()),
        MentionsViewController(nibName: "MentionsViewController", bundle: NSBundle.mainBundle())
    ]
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addScrollView()
        addContainerView()
        addMenuView()
        createContraints()
        let time = dispatch_time(DISPATCH_TIME_NOW, 0)
        
        dispatch_after(time, dispatch_get_main_queue(), {
            self.closeMenuSideBar()
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
        scrollView!.addSubview(containerView!)
        selectedViewController = viewController
    }
    
    func menuViewControllerDelegate(menuViewController: MenuViewController, didTapMenuTab selectedMenuTab: String) {
        switch(selectedMenuTab) {
        case "Home Timeline":
            let tweetsViewController = viewControllers[0] as! TweetsViewController
            tweetsViewController.delegate = self
            selectViewController(tweetsViewController)
        case "Profile":
            selectCurrentUser()
        case "Mentions":
            let mentionViewController = viewControllers[2]
            selectViewController(mentionViewController)
        default:
            selectCurrentUser()
        }
        closeMenuSideBar()
    }
    
    func closeMenuSideBar() {
        createContraints()
        let containerViewCenter = CGPoint(x: 250, y: 0)
        self.scrollView!.setContentOffset(containerViewCenter, animated: true)
    }
    
    func tweetsViewControllerDelegate(tweetsViewController: TweetsViewController, didUpdateProfileUser user: User) {
        let userProfileVC = viewControllers[1] as! UserProfileViewController
        userProfileVC.profileUser = user
        selectViewController(userProfileVC)
        closeMenuSideBar()
    }
    
    @IBAction func onSignOut(sender: UIBarButtonItem) {
        User.currentUser?.logout()
    }
    
    private func addScrollView() {
//        scrollView!.delegate = self
        scrollView!.translatesAutoresizingMaskIntoConstraints = false
        scrollView!.pagingEnabled = true
        scrollView!.showsHorizontalScrollIndicator = false
        scrollView!.bounces = false
        view.addSubview(scrollView!)
    }
    
    func selectCurrentUser() {
        let userProfileViewController = viewControllers[1] as! UserProfileViewController
        userProfileViewController.profileUser = User.currentUser
        selectViewController(userProfileViewController)
    }
    
    private func addContainerView() {
        selectCurrentUser()
        scrollView!.addSubview(containerView!)
    }
    
    private func addMenuView() {
        let menuViewController = MenuViewController(nibName: "MenuViewController", bundle: nil)
        menuViewController.delegate = self
        self.addChildViewController(menuViewController)
        menuView = menuViewController.view
        menuView!.translatesAutoresizingMaskIntoConstraints = false
        scrollView!.addSubview(menuView!)
        menuViewController.didMoveToParentViewController(self)
    }
    
    private func createContraints() {
        let views = [
            "menuView": menuView!,
            "containerView": containerView!,
            "scrollView": scrollView!,
            "view": view!
        ]
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[menuView(==scrollView)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[containerView(==scrollView)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
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
