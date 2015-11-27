//
//  ViewController.swift
//  Shoplists
//
//  Created by Oleg Chepkin on 26/10/15.
//  Copyright © 2015 Nelixsoft.ru. All rights reserved.
//

import UIKit

class ShoplistViewController: UITableViewController, ItemDetailViewControllerDelegate {
    var shoplist: Shoplist!
    
    @IBOutlet weak var inListLabel: UILabel!
    @IBOutlet weak var inCartLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = shoplist.name
        updateTotalLabels()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoplist.items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ShoplistItem", forIndexPath: indexPath)
        
        let item = shoplist.items[indexPath.row]
        
        configureTextForCell(cell, withShoplistItem: item)
        configureCheckmarkForCell(cell, withShoplistItem: item)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            let item = shoplist.items[indexPath.row]
            item.toggleChecked()
            
            configureCheckmarkForCell(cell, withShoplistItem: item)
        }
        updateTotalLabels()
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle,forRowAtIndexPath indexPath: NSIndexPath) {
        
        shoplist.items.removeAtIndex(indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
    }
    
    func configureTextForCell(cell: UITableViewCell, withShoplistItem item: ShoplistItem) {
        let titleLabel = cell.viewWithTag(1000) as! UILabel
        titleLabel.text = item.text
        
        let subtitleLabel = cell.viewWithTag(1002) as! UILabel
        subtitleLabel.text = "\(item.quantity) x \(item.priceToMoney) = \(item.amountToMoney)"
    }
    
    func configureCheckmarkForCell(cell: UITableViewCell, withShoplistItem item: ShoplistItem) {
        let label = cell.viewWithTag(1001) as! UILabel
        
        if item.checked {
            label.text = "√"
        } else {
            label.text = ""
        }
        
        label.textColor = view.tintColor
    }
    
    func itemDetailViewControllerDidCancel(controller: ItemDetailViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func itemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item: ShoplistItem) {
        let newRowIndex = shoplist.items.count
        
        shoplist.items.append(item)
        
        let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
        let indexPaths = [indexPath]
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        updateTotalLabels()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func itemDetailViewController(controller: ItemDetailViewController, didFinishEditingItem item: ShoplistItem) {
        if let index = shoplist.items.indexOf(item) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                configureTextForCell(cell, withShoplistItem: item)
            }
        }
        updateTotalLabels()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddItem" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self
            
        } else if segue.identifier == "EditItem" {
            print("EditItem")
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self
            
            if let indexPath = tableView.indexPathForCell( sender as! UITableViewCell) {
                controller.itemToEdit = shoplist.items[indexPath.row]
            }
        }
    }
    
    func updateTotalLabels(){
        inListLabel.text = FormatHelper.priceDoubleToMoney(shoplist.inListTotal)
        inCartLabel.text = FormatHelper.priceDoubleToMoney(shoplist.inCartTotal)
    }
    
}
