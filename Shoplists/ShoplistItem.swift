//
//  ShoplistItem.swift
//  Shoplists
//
//  Created by Oleg Chepkin on 26/10/15.
//  Copyright © 2015 Nelixsoft.ru. All rights reserved.
//

import Foundation

class ShoplistItem: NSObject, NSCoding {
    var text = ""
    var quantity = 1
    var price = 0.0
    var checked = false
    
    var amount: Double {
        get {
            return Double(quantity) * price
        }
    }
    var priceToMoney: String {
        get {
            return FormatHelper.priceDoubleToMoney(price)
        }
    }
    
    var amountToMoney: String {
        get {
            return FormatHelper.priceDoubleToMoney(amount)
        }
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObjectForKey("Text") as! String
        checked = aDecoder.decodeBoolForKey("Checked")
        quantity = aDecoder.decodeIntegerForKey("Quantity")
        price = aDecoder.decodeDoubleForKey("Price")
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(text, forKey: "Text")
        aCoder.encodeInteger(quantity, forKey: "Quantity")
        aCoder.encodeDouble(price, forKey: "Price")
        aCoder.encodeBool(checked, forKey: "Checked")
    }
    
    func toggleChecked() {
        checked = !checked
    }

}
