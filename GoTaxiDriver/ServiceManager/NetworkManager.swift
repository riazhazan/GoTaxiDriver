//
//  NetworkManager.swift
//  GoTaxiDriver
//
//  Created by Riaz on 23/11/17.
//  Copyright © 2017 Go Taxi. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class NetworkManager {
    
    class func validateNumberByRequestingOTP(parameter: [String: Any], completionHandler: @escaping (_ status: APIErrorStatus, _ responseObject: BaseResponse?) -> Void) {
        
        Alamofire.request(NetworkConstants.k_ServerURL + NetworkConstants.validateNumber, method: HTTPMethod.post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).responseObject { (response: DataResponse<BaseResponse>) in
            completionHandler(self.getErrorStatusForHTTPResponse(response.response), response.result.value)
        }
    }
    
    class func validateOTP(parameter: [String: Any], completionHandler: @escaping (_ status: APIErrorStatus, _ responseObject: ValidateOtp?) -> Void) {
        
        Alamofire.request(NetworkConstants.k_ServerURL + NetworkConstants.validateOtp, method: HTTPMethod.post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).responseObject { (response: DataResponse<ValidateOtp>) in
            completionHandler(self.getErrorStatusForHTTPResponse(response.response), response.result.value)
        }
    }
    
    class func validateUserName(userName: String, completionHandler: @escaping (_ status: APIErrorStatus, _ responseObject: ValidateUserName?) -> Void) {
        
        Alamofire.request(NetworkConstants.k_ServerURL + String(format: NetworkConstants.validateUserName, userName), method: HTTPMethod.post, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseObject { (response: DataResponse<ValidateUserName>) in
            completionHandler(self.getErrorStatusForHTTPResponse(response.response), response.result.value)
        }
    }
    
    class func registerDriver(parameter: [String: Any], completionHandler: @escaping (_ status: APIErrorStatus, _ responseObject: BaseResponse?) -> Void) {
        
        Alamofire.request(NetworkConstants.k_ServerURL + NetworkConstants.register, method: HTTPMethod.post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).responseObject { (response: DataResponse<BaseResponse>) in
            completionHandler(self.getErrorStatusForHTTPResponse(response.response), response.result.value)
        }
    }
    
    class func getDocumentList(parameter: [String: Any], completionHandler: @escaping (_ status: APIErrorStatus, _ responseObject: DocumentList?) -> Void) {
        
        Alamofire.request(NetworkConstants.k_ServerURL + NetworkConstants.documentList, method: HTTPMethod.get, parameters: parameter, encoding: URLEncoding.default, headers: nil).responseObject { (response: DataResponse<DocumentList>) in
            completionHandler(self.getErrorStatusForHTTPResponse(response.response), response.result.value)
        }
    }
}

extension NetworkManager {
    class func uploadDocumentToServer(documentId: Int, selectedImage: UIImage, completionHandler: @escaping (_ status: APIErrorStatus, _ responseObject: BaseResponse?) -> Void)  {
       
        if let data = UIImageJPEGRepresentation(selectedImage,0.3) {

            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    multipartFormData.append(data, withName: "fieldNameHere", fileName: "file", mimeType: "image/jpeg")
            },
                to: NetworkConstants.k_ServerURL + String(format: NetworkConstants.uploadDocument, documentId),
                method: .post,
                headers: [:],
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseObject { (response: DataResponse<BaseResponse>) in
                            completionHandler(self.getErrorStatusForHTTPResponse(response.response), response.result.value)
                        }
                    case .failure(let encodingError):
                        debugPrint(encodingError)
                    }
            })
        }
    }
}

extension NetworkManager {
    /// Analyses HTTP status code and returns API error status
    ///
    /// - Parameter response: HTTP URL response
    /// - Returns: API Error status for corresponding HTTP status code
    class func getErrorStatusForHTTPResponse(_ response: HTTPURLResponse?) -> APIErrorStatus{
        
        var status = 0
        if let res = response{
            status = res.statusCode
        }
        
        if (status >= 200 && status < 300) {
            return .success
        } else if (status >= 300 && status < 500) {
            return .failure
        } else {
            return .networkError
        }
    }
    
    
    /// Configures the http header for the network call
    ///
    /// - Returns: returns the configured header dictionary
    class func getHTTPHeaders() -> Dictionary<String, String> {
        var httpHeader = [String: String]()
        if let token = UserDefaults.standard.value(forKey: DefaultKeys.accessToken) as? String {
            httpHeader["authorization"] = "Bearer  \(token)"
        }
        return httpHeader
    }
}

enum APIErrorStatus {
    case success
    case failure
    case networkError
    case noInternet
}

struct APIStatusCodes {
    static let InsufficientData:Int    = 600
    static let OperationFailed:Int     = 601
    static let OperationSuccess:Int    = 602
    static let NotAuthorized:Int       = 603
    static let ErrorOccured:Int        = 604
}
