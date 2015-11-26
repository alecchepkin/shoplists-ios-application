//
//  ViewController.swift
//  Shoplists
//
//  Created by Oleg Chepkin on 26/10/15.
//  Copyright © 2015 Nelixsoft.ru. All rights reserved.
//

import UIKit

class ShoplistViewController: UITableViewController, ItemDetailViewControllerDelegate {
  var checklist: Shoplist!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = checklist.name
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return checklist.items.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      
    let cell = tableView.dequeueReusableCellWithIdentifier("ShoplistItem", forIndexPath: indexPath)
    
    let item = checklist.items[indexPath.row]

    configureTextForCell(cell, withShoplistItem: item)
    configureCheckmarkForCell(cell, withShoplistItem: item)

    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      
    if let cell = tableView.cellForRowAtIndexPath(indexPath) {
      let item = checklist.items[indexPath.row]
      item.toggleChecked()
      
      configureCheckmarkForCell(cell, withShoplistItem: item)
    }
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle,forRowAtIndexPath indexPath: NSIndexPath) {

    checklist.items.removeAtIndex(indexPath.row)
    
    let indexPaths = [indexPath]
    tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
  }
  
  func configureTextForCell(cell: UITableViewCell, withShoplistItem item: ShoplistItem) {
    let label = cell.viewWithTag(1000) as! UILabel
    label.text = item.text
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
    let newRowIndex = checklist.items.count
    
    checklist.items.append(item)
    
    let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
    let indexPaths = [indexPath]
    tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
    
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func itemDetailViewController(controller: ItemDetailViewController, didFinishEditingItem item: ShoplistItem) {
    if let index = checklist.items.indexOf(item) {
      let indexPath = NSIndexPath(forRow: index, inSection: 0)
      if let cell = tableView.cellForRowAtIndexPath(indexPath) {
        configureTextForCell(cell, withShoplistItem: item)
      }
    }
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
        controller.itemToEdit = checklist.items[indexPath.row]
      }
    }
  }
}
