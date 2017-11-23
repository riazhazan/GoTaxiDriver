//
//  BaseViewController.swift
//  GoTaxiDriver
//
//  Created by Riaz on 23/11/17.
//  Copyright © 2017 Go Taxi. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
   
    var countriesInEnglish: [String] {
        let myLanguageId = "en" // in which language I want to show the list
        return NSLocale.isoCountryCodes.map {
            return NSLocale(localeIdentifier: myLanguageId).localizedString(forCountryCode: $0) ?? $0
        }
    }
    var countriesInArabic: [String] {
        let myLanguageId = "ar" // in which language I want to show the list
        return NSLocale.isoCountryCodes.map {
            return NSLocale(localeIdentifier: myLanguageId).localizedString(forCountryCode: $0) ?? $0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureTextFieldBorder(textField: UITextField) {
        textField.layer.borderColor = UIColor().textFieldBorderColor.cgColor
        textField.layer.borderWidth = 1
    }
    
    func setPlaceHolderString(placeholderStr: String) -> NSMutableAttributedString {
        let fnt = UIFont(name: "Avenir Next", size: 14)
        let attributedString = NSMutableAttributedString(string:placeholderStr, attributes:[NSAttributedStringKey.font : fnt!])
        let pattern = "\\B\\*\\w+"
        let range: Range<String.Index> = placeholderStr.range(of: "*")!
        let index: Int = placeholderStr.distance(from: placeholderStr.startIndex, to: range.lowerBound)
        if placeholderStr.range(of: pattern, options: .regularExpression) != nil {
            attributedString.setAttributes([NSAttributedStringKey.font : fnt!.withSize(10), NSAttributedStringKey.baselineOffset: 10], range: NSMakeRange(index, 1))
        }
        return attributedString
    }
}
