//
//  DocumentList.swift
//  GoTaxiDriver
//
//  Created by Riaz on 23/11/17.
//  Copyright © 2017 Go Taxi. All rights reserved.
//

import Foundation
import ObjectMapper

class DocumentList: Mappable {
    var statusCode: Int?
    var statusMessage: String?
    var documents: [Document]?
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        self.statusCode         <- map["StatusCode"]
        self.statusMessage      <- map["StatusMessage"]
        self.documents        <- map["DocumentList"]
    }
}

class Document: Mappable {
    var name: String?
    var documentId: Int?
    var description: String?
    var isMandatory:Bool?
    var uploadStatus = false
    var image:UIImage?
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        self.name               <- map["DocumentName"]
        self.documentId         <- map["DocumentID"]
        self.description        <- map["DocumentDescription"]
        self.isMandatory        <- map["IsMandatory"]
    }
}
