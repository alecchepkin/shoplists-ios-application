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

  override init() {
    super.init()
  }
  
  required init?(coder aDecoder: NSCoder) {
    text = aDecoder.decodeObjectForKey("Text") as! String
    checked = aDecoder.decodeBoolForKey("Checked")
    super.init()
  }
  
  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(text, forKey: "Text")
    aCoder.encodeBool(checked, forKey: "Checked")
  }
  
  func toggleChecked() {
    checked = !checked
  }
}
