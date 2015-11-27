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
        //let firstTime = userDefaults.boolForKey("FirstTime")
        //if firstTime {
        
        let checklist = Shoplist(name: "List")
        
        let item = ShoplistItem()
        item.text = "Milk"
        item.quantity = 3
        item.price = 50.00
        checklist.items.append(item)
        
        let item2 = ShoplistItem()
        item2.text = "Bread"
        item2.quantity = 2
        item2.price = 10.00
        checklist.items.append(item2)
        
        let item3 = ShoplistItem()
        item3.text = "Butter"
        item3.quantity = 1
        item3.price = 70.00
        checklist.items.append(item3)
        
        lists.append(checklist)
        indexOfSelectedShoplist = 0
        //userDefaults.setBool(false, forKey: "FirstTime")
        userDefaults.synchronize()
        //}
    }
    
    func sortShoplists() {
        lists.sortInPlace({ checklist1, checklist2 in
            return checklist1.name.localizedStandardCompare(checklist2.name) == .OrderedAscending
        })
    }
}
