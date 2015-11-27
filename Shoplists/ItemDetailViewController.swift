//
//  ItemDetailViewController.swift
//  Shoplists
//
//  Created by Oleg Chepkin on 26/11/15.
//  Copyright © 2015 Nelixsoft.ru. All rights reserved.
//

import Foundation
import UIKit

protocol ItemDetailViewControllerDelegate: class {
    func itemDetailViewControllerDidCancel(controller: ItemDetailViewController)
    func itemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item: ShoplistItem)
    func itemDetailViewController(controller: ItemDetailViewController, didFinishEditingItem item: ShoplistItem)
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var quantityField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    
    weak var delegate: ItemDetailViewControllerDelegate?
    
    var itemToEdit: ShoplistItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hi")
        if let item = itemToEdit {
            print("hello")
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.enabled = true
            quantityField.text = "\(item.quantity)"
            priceField.text = FormatHelper.priceDoubleToMoney(item.price)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    @IBAction func cancel() {
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        if let item = itemToEdit {
            item.text = textField.text!
            item.quantity = Int(quantityField.text!)!
            item.price = Double(priceField.text!)!
            delegate?.itemDetailViewController(self, didFinishEditingItem: item)
            
        } else {
            let item = ShoplistItem()
            item.text = textField.text!
            item.checked = false
            item.quantity = Int(quantityField.text!)!
            item.price = Double(priceField.text!)!
            delegate?.itemDetailViewController(self, didFinishAddingItem: item)
        }
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text! as NSString
        let newText = oldText.stringByReplacingCharactersInRange(range, withString: string) as NSString!
        print("newText: \(newText)")
        switch textField.tag {
        case 1:
            doneBarButton.enabled = (newText.length > 0)
            return true
            
        case 2:
            textField.text = FormatHelper.stringPriceFilter(newText as String)
            return false
            
         default:

            textField.text = FormatHelper.moneyTextToMoney(newText as String)
            
            return false
        }
        
    }
  }
