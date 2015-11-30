//
//  AllListsViewController.swift
//  Shoplists
//
//  Created by Oleg Chepkin on 26/11/15.
//  Copyright © 2015 Nelixsoft.ru. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {
    
    var dataModel: DataModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.delegate = self
        
        let index = dataModel.indexOfSelectedShoplist
        if index >= 0 && index < dataModel.lists.count {
            let shoplist = dataModel.lists[index]
            performSegueWithIdentifier("ShowShoplist", sender: shoplist)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = cellForTableView(tableView)
        
        let shoplist = dataModel.lists[indexPath.row]
        cell.textLabel!.text = shoplist.name
        cell.accessoryType = .DetailDisclosureButton
        
        let count = shoplist.countUncheckedItems()
        if shoplist.items.count == 0 {
            cell.detailTextLabel!.text = ""
        } else if count == 0 {
            cell.detailTextLabel!.text = NSLocalizedString("ALL_DONE", comment: "All Done")
        } else {
            cell.detailTextLabel!.text = "\(count) " + NSLocalizedString("REMAINING", comment: "Remainning")//"\(count) Remaining"
        }
        
        return cell
    }
    
    func cellForTableView(tableView: UITableView) -> UITableViewCell {
        let cellIdentifier = "Cell"
        if let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) {
            return cell
        } else {
            return UITableViewCell(style: .Subtitle, reuseIdentifier: cellIdentifier)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        dataModel.indexOfSelectedShoplist = indexPath.row
        
        let shoplist = dataModel.lists[indexPath.row]
        performSegueWithIdentifier("ShowShoplist", sender: shoplist)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        dataModel.lists.removeAtIndex(indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        let navigationController = storyboard!.instantiateViewControllerWithIdentifier("ListDetailNavigationController") as! UINavigationController
        
        let controller = navigationController.topViewController as! ListDetailViewController
        controller.delegate = self
        
        let shoplist = dataModel.lists[indexPath.row]
        controller.shoplistToEdit = shoplist
        
        presentViewController(navigationController, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowShoplist" {
            let controller = segue.destinationViewController as! ShoplistViewController
            controller.shoplist = sender as! Shoplist
            
        } else if segue.identifier == "AddShoplist" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! ListDetailViewController
            controller.delegate = self
            controller.shoplistToEdit = nil
        }
    }
    
    func listDetailViewControllerDidCancel(controller: ListDetailViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func listDetailViewController(controller: ListDetailViewController,
        didFinishAddingShoplist shoplist: Shoplist) {
            dataModel.lists.append(shoplist)
            dataModel.sortShoplists()
            tableView.reloadData()
            dismissViewControllerAnimated(true, completion: nil)
    }
    
    func listDetailViewController(controller: ListDetailViewController,
        didFinishEditingShoplist shoplist: Shoplist) {
            dataModel.sortShoplists()
            tableView.reloadData()
            dismissViewControllerAnimated(true, completion: nil)
    }
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        if viewController === self {
            dataModel.indexOfSelectedShoplist = -1
        }
    }
}
