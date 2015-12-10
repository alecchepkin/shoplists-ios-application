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
        let longPress = UILongPressGestureRecognizer(target: self, action: "longPressGestureRecognized:")
        tableView.addGestureRecognizer(longPress)
        print("hello")
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
    
    // MARK: GestureRecoqnizer
    
    func longPressGestureRecognized(gestureRecognizer: UIGestureRecognizer) {
        print("long")
        let longPress = gestureRecognizer as! UILongPressGestureRecognizer
        let state = longPress.state
        let locationInView = longPress.locationInView(tableView)
        let indexPath = tableView.indexPathForRowAtPoint(locationInView)
        print("indexPath: \(indexPath)")
        if (indexPath == nil){
            return
        }
        
        struct My {
            
            static var cellSnapshot : UIView? = nil
            
        }
        struct Path {
            
            static var initialIndexPath : NSIndexPath? = nil
            
        }
        
        switch state {
        case UIGestureRecognizerState.Began:
            if indexPath != nil {
                Path.initialIndexPath = indexPath
                let cell = tableView.cellForRowAtIndexPath(indexPath!) as UITableViewCell!
                if cell.restorationIdentifier == "SummuryBar"{
                    break
                }
                My.cellSnapshot  = snapshopOfCell(cell)
                var center = cell.center
                
                My.cellSnapshot!.center = center
                
                My.cellSnapshot!.alpha = 0.0
                
                tableView.addSubview(My.cellSnapshot!)
                
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    center.y = locationInView.y
                    
                    My.cellSnapshot!.center = center
                    
                    My.cellSnapshot!.transform = CGAffineTransformMakeScale(1.05, 1.05)
                    
                    My.cellSnapshot!.alpha = 0.98
                    
                    cell.alpha = 0.0
                    
                    }, completion: { (finished) -> Void in
                        
                        if finished {
                            
                            cell.hidden = true
                            
                        }
                        
                })
                
            }
        case UIGestureRecognizerState.Changed:
            if  My.cellSnapshot == nil {
                break
            }
            var center = My.cellSnapshot!.center
            center.y = locationInView.y
            My.cellSnapshot!.center = center
            if ((indexPath != nil) && (indexPath != Path.initialIndexPath)) {
                swap(&shoplist.items[indexPath!.row], &shoplist.items[Path.initialIndexPath!.row])
                tableView.moveRowAtIndexPath(Path.initialIndexPath!, toIndexPath: indexPath!)
                Path.initialIndexPath = indexPath
            }
        default:
            if(Path.initialIndexPath == nil){
                break
            }
            let cell = tableView.cellForRowAtIndexPath(Path.initialIndexPath!) as UITableViewCell!
            cell.hidden = false
            cell.alpha = 0.0
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                My.cellSnapshot!.center = cell.center
                My.cellSnapshot!.transform = CGAffineTransformIdentity
                My.cellSnapshot!.alpha = 0.0
                cell.alpha = 1.0
                }, completion: { (finished) -> Void in
                    if finished {
                        Path.initialIndexPath = nil
                        My.cellSnapshot!.removeFromSuperview()
                        My.cellSnapshot = nil
                    }
            })
            
        }
    }
    
    func snapshopOfCell(inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        UIGraphicsEndImageContext()
        let cellSnapshot : UIView = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0)
        cellSnapshot.layer.shadowRadius = 0.0
        cellSnapshot.layer.shadowOpacity = 0.0
        return cellSnapshot
    }
    
}
