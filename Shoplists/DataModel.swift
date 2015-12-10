//
//  DataModel.swift
//  Shoplists
//
//  Created by Oleg Chepkin on 26/11/15.
//  Copyright © 2015 Nelixsoft.ru. All rights reserved.
//

import Foundation

class DataModel {
    var lists = [Shoplist]()
    
    init() {
        loadShoplists()
        registerDefaults()
        handleFirstTime()
    }
    
    func documentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        return paths[0]
    }
    
    func dataFilePath() -> String {
        return (documentsDirectory() as NSString).stringByAppendingPathComponent("Shoplists.plist")
    }
    
    func saveShoplists() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(lists, forKey: "Shoplists")
        archiver.finishEncoding()
        data.writeToFile(dataFilePath(), atomically: true)
    }
    
    func loadShoplists() {
        let path = dataFilePath()
        if NSFileManager.defaultManager().fileExistsAtPath(path) {
            if let data = NSData(contentsOfFile: path) {
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                lists = unarchiver.decodeObjectForKey("Shoplists") as! [Shoplist]
                unarchiver.finishDecoding()
                sortShoplists()
            }
        }
    }
    
    func registerDefaults() {
        let dictionary = [ "ShoplistIndex": -1,
            "FirstTime": true ]
        
        NSUserDefaults.standardUserDefaults().registerDefaults(dictionary)
    }
    
    var indexOfSelectedShoplist: Int {
        get {
            return NSUserDefaults.standardUserDefaults().integerForKey("ShoplistIndex")
        }
        set {
            NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: "ShoplistIndex")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    func handleFirstTime() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let firstTime = userDefaults.boolForKey("FirstTime")
        
        if firstTime {
            
            let shoplist = Shoplist(name: "Grocery")

            shoplist.items.append(ShoplistItem(text: "Milk", quantity: 3, price: 1.2))
            shoplist.items.append(ShoplistItem(text: "Bread", quantity: 2, price: 2.0))
            shoplist.items.append(ShoplistItem(text: "Butter", quantity: 1, price: 3.4))
            shoplist.items.append(ShoplistItem(text: "Sugar", quantity: 1, price: 0.95))
            shoplist.items.append(ShoplistItem(text: "Flour", quantity: 1, price: 0.55))
            shoplist.items.append(ShoplistItem(text: "Chicken", quantity: 1, price: 2.05))
            shoplist.items.append(ShoplistItem(text: "Eggs", quantity: 1, price: 1.45))
            shoplist.items.append(ShoplistItem(text: "Apple", quantity: 1, price: 1.25))
            shoplist.items.append(ShoplistItem(text: "Potatoes", quantity: 1, price: 0.35))
            
            lists.append(shoplist)
            
            let shoplist2 = Shoplist(name: "Dress")
            
            shoplist.items.append(ShoplistItem(text: "Pullover", quantity: 1, price: 100.0))
            shoplist.items.append(ShoplistItem(text: "Suit", quantity: 2, price: 235.0))
            shoplist.items.append(ShoplistItem(text: "Shirt", quantity: 1, price: 30.5))
            
            lists.append(shoplist2)
            
            let shoplist3 = Shoplist(name: "Dinner")
            lists.append(shoplist3)
            
            let shoplist4 = Shoplist(name: "Market")
            lists.append(shoplist4)
            
            let shoplist5 = Shoplist(name: "Weekend")
            lists.append(shoplist5)
            
            
            indexOfSelectedShoplist = 0
            userDefaults.setBool(false, forKey: "FirstTime")
            userDefaults.synchronize()
        }
    }
    
    func sortShoplists() {
        lists.sortInPlace({ shoplist1, shoplist2 in
            return shoplist1.name.localizedStandardCompare(shoplist2.name) == .OrderedAscending
        })
    }
}
