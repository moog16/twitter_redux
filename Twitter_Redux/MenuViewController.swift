//
//  MenuViewController.swift
//  Twitter_Redux
//
//  Created by Matthew Goo on 10/7/15.
//  Copyright © 2015 mattgoo. All rights reserved.
//

import UIKit

@objc protocol MenuViewControllerDelegate {
    optional func menuViewControllerDelegate(menuViewController: MenuViewController, didTapMenuTab selectedMenuTab: String)
}

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var menuTableView: UITableView!
    let menuTabs = ["Home Timeline", "Profile", "Mentions"]
    var delegate: MenuViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.reloadData()
        let cellNib = UINib(nibName: "MenuCell", bundle: NSBundle.mainBundle())
        menuTableView.registerNib(cellNib, forCellReuseIdentifier: "MenuCell")
        menuTableView.rowHeight = 50
        
        let backgroundView = UIView(frame: CGRectZero)
        menuTableView.tableFooterView = backgroundView
        menuTableView.backgroundColor = UIColor(red: 0.46, green: 0.46, blue: 0.46, alpha: 1)
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as! MenuCell
        cell.menuLabel.text = menuTabs[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuTabs.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        delegate?.menuViewControllerDelegate?(self, didTapMenuTab: menuTabs[indexPath.row])
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
