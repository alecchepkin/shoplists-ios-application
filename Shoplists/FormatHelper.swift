//
//  MoneyHelper.swift
//  Shoplists
//
//  Created by legr on 27/11/15.
//  Copyright © 2015 Razeware. All rights reserved.
//

import Foundation

class FormatHelper {
    
    class func moneyTextToMoney(stringPrice: String) -> String{
        
        let digitText = stringPriceFilter(stringPrice)
        let numberFromField = (NSString(string: digitText).doubleValue)/100
        return priceDoubleToMoney(numberFromField)
    }
    
    class func priceDoubleToMoney(price: Double) -> String{
        
        let formatter = formatterCurrency()
        var newPrice = formatter.stringFromNumber(price)
        newPrice = newPrice!.stringByReplacingOccurrencesOfString("$", withString: "")
        return newPrice!
    }
    
    class func formatterCurrency() -> NSNumberFormatter{
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.locale = NSLocale(localeIdentifier: "en_US")
        return formatter
    }
    
    class func stringPriceFilter(stringPrice: String) -> String{
        let digits = NSCharacterSet.decimalDigitCharacterSet()
        var digitText = ""
        for c in stringPrice.unicodeScalars {
            if digits.longCharacterIsMember(c.value) {
                digitText.append(c)
            }
        }
        return digitText
    }

}