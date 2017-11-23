//
//  UITextFieldExtension.swift
//  GoTaxiDriver
//
//  Created by Riaz on 23/11/17.
//  Copyright © 2017 Go Taxi. All rights reserved.
//

import UIKit

extension UITextField {
    
    
    /// Sets a padding to the textField in the specified diretion
    ///
    /// - Parameter direction: direction in which padding is to be set
    func setPaddingtoTextField (direction: Directions) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        switch direction {
        case Directions.left:
            self.leftView = paddingView
            self.leftViewMode = .always
        case Directions.right:
            self.leftView = paddingView
            self.rightView = paddingView
            self.rightViewMode = .always
            self.leftViewMode = .always
        default:
            break
        }
    }
}
