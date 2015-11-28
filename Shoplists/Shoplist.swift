//
//  Shoplist.swift
//  Shoplists
//
//  Created by Oleg Chepkin on 26/11/15.
//  Copyright © 2015 Nelixsoft.ru. All rights reserved.
//

import UIKit

class Shoplist: NSObject, NSCoding {
    var name = ""
    var items = [ShoplistItem]()
    var inListTotal: Double {
        get {
            var total = 0.0
            for item in items{
                total += item.amount
            }
            return total
        }
    }
    var inCartTotal: Double {
        get {
            var total = 0.0
            for item in items{
                if item.checked == true {
                    total += item.amount
                }
            }
            return total
        }
    }
    
    init(name: String) {
        self.name = name
        super.init()
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey("Name") as! String
        items = aDecoder.decodeObjectForKey("Items") as! [ShoplistItem]
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "Name")
        aCoder.encodeObject(items, forKey: "Items")
    }
    
    func countUncheckedItems() -> Int {
        var count = 0
        for item in items where !item.checked {
            count += 1
        }
        return count
    }
    
    /*
    // The functional programming version
    func countUncheckedItems() -> Int {
    return items.reduce(0) { cnt, item in cnt + (item.checked ? 0 : 1) }
    }
    */
}
