//
//  SharedObjects.swift
//  GoTaxiDriver
//
//  Created by Riaz on 24/11/17.
//  Copyright © 2017 Go Taxi. All rights reserved.
//

import UIKit

class SharedObjects: NSObject {
static let sharedInstance = SharedObjects()
    var documents : [Document]?
    var documentSelectedToUpdate: Document?
}

