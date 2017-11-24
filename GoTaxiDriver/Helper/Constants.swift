//
//  Constants.swift
//  GoTaxi
//
//  Created by Riaz on 21/11/17.
//  Copyright © 2017 Go Taxi. All rights reserved.
//

import UIKit

let userEntityCode      = 100

let AppRegularFont   = "HelveticaNeue"
let AppMediumFont    = "HelveticaNeue-Medium"
let AppBoldFont      = "HelveticaNeue-Bold"

let AppFontSmallerSize:CGFloat = 12
let AppFontRegularSize:CGFloat = 14
let AppFontMediumSize:CGFloat = 16
let AppFontBigSize:CGFloat = 18

struct DefaultKeys {
    
//Userdefault key strings
    static let isUserLoggedIn   = "isUserLoggedIn"
    static let accessToken      = "accessToken"
}


/// Enum for directions
///
/// - left:
/// - top:
/// - right:
/// - bottom:
/// - topLeft:
/// - topRight:
/// - bottomLeft:
/// - bottomRight:
/// - allSides:
enum Directions {
    case left
    case top
    case right
    case bottom
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
    case allSides
}

extension Directions {
    var shadowOffset: CGSize {
        switch self {
        case .left:
            return CGSize(width: -10, height: 0)
        case .top:
            return CGSize(width: -10, height: 0)
        case .right:
            return CGSize(width: 10, height: 0)
        case .bottom:
            return CGSize(width: 0, height: 10)
        case .topLeft:
            return CGSize(width: -10, height: -10)
        case .topRight:
            return CGSize(width: 10, height: -10)
        case .bottomLeft:
            return CGSize(width: -10, height: 10)
        case .bottomRight:
            return CGSize(width: 10, height: 10)
        case .allSides:
            return CGSize(width: 0, height: 0)
        }
    }
}


/// Structure stores the display date formats
struct DateFormats {
    static let hourMinute = "hh:mm a"
    static let monthDateHourMinute = "MMMM dd, yyyy, hh:mm a"
    static let shortMnthDateHrMin = "MMM dd hh:mm a"
    static let monthDateYear = "MMMM dd, yyyy"
    static let shortMonthDateYear = "MMM dd, yyyy"
    static let mmddyy = "MM-dd-yyyy"
}
