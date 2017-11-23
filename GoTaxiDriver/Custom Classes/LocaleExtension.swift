//
//  LocaleExtension.swift
//  GoTaxiDriver
//
//  Created by Riaz on 23/11/17.
//  Copyright © 2017 Go Taxi. All rights reserved.
//

import UIKit

extension NSLocale {
    
    struct Locale {
        let countryCode: String
        let countryName: String
    }
    
    class func locales() -> [Locale] {
        
        var locales = [Locale]()
//        for localeCode in NSLocale.isoCountryCodes {
//            let countryName = NSLocale.current.dis.displayNameForKey(NSLocaleCountryCode, value: localeCode)!
//            let countryCode = localeCode
//            let locale = Locale(countryCode: countryCode, countryName: countryName)
//            locales.append(locale)
//        }
        
        return locales
    }
    
}
