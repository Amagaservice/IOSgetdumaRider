//
//  Network.swift
//  Ocory
//
//  Created by Arun Singh on 25/02/21.
//

import Foundation
import UIKit
import Alamofire

enum methodType {
    case POST,GET
}

//var baseURL = "https://www.getduma.com/"
var baseURL = "https://staging.getduma.com/"
var imgURL = "https://promatics.xyz/azy/public/images/product/"
var profileImg = "https://promatics.xyz/azy/public/images/profile/"

//"http://13.233.185.124/azy/public/images/product/"
var chatImgUrl = ""
var pdfURL = ""


class Connectivity {
    class var isConnectedToInternet:Bool {
        
        return NetworkReachabilityManager()!.isReachable
        
    }
}

class webservices {
    init(){}
    var responseCode = 0;
    var connectionError = ""
    
    func startConnectionWithGetTypeOTP(getUrlString:String ,outputBlock:@escaping (_ receivedData:AnyObject)->Void) {
        
        let Url = getUrlString
        
        print(Url)
        
        AF.request(Url, encoding: JSONEncoding.default).responseJSON { response in
            
            if response.response != nil {
                
                if let json = response.value {
                    
                    self.responseCode = 1
                    outputBlock(json as AnyObject)
                    
                }else {
                    
                    self.responseCode = 2
                    outputBlock(["Error" : response.error?.localizedDescription] as AnyObject)
                    
                }
            }else {
                
                self.responseCode = 2
                
                outputBlock(["Error" : response.error?.localizedDescription] as AnyObject)
                
            }
        }
    }
    
    func startConnectionWithSendOtp(getUrlString:String , params getParams:[String: AnyObject],outputBlock:@escaping (_ receivedData:AnyObject)->Void) {
        let Url = "https://bulksms.vsms.net/eapi/submission/send_sms/2/2.0?"
        print(Url)
        AF.request(Url, method: .post, parameters: getParams as Parameters, encoding: JSONEncoding.default).responseJSON { response in
            if response.response != nil {
                if !(response.description.isEmpty) {
                    self.responseCode = 1
                    outputBlock(response.description as AnyObject)
                }else {
                    self.responseCode = 2
                    outputBlock(["Error" : response.error?.localizedDescription] as AnyObject)
                }
            }else {
                self.responseCode = 2
                outputBlock(["Error" : response.error?.localizedDescription] as AnyObject)
            }
        }
    }
    
    func startConnectionWithGetType(getUrlString:String ,outputBlock:@escaping (_ receivedData: AnyObject)->Void) {
        
        let Url = baseURL + getUrlString
        print(Url)
        AF.request(Url, encoding: JSONEncoding.default).responseJSON { response in
            if response.response != nil {
                if !(response.description.isEmpty) {
                    self.responseCode = 1
                    outputBlock(response.description as AnyObject)
                }else {
                    self.responseCode = 2
                    outputBlock(["Error" : response.error?.localizedDescription] as AnyObject)
                }
            }else {
                self.responseCode = 2
                outputBlock(["Error" : response.error?.localizedDescription] as AnyObject)
            }
        }
    }
    
    func startConnectionWithGetTypeWithParam(getUrlString:String,authRequired : Bool = false,outputBlock:@escaping (_ receivedData: AnyObject)->Void) {
        
        let Url = baseURL + getUrlString
        print(Url)
        var headers: HTTPHeaders = [:]
        
        if(authRequired){
            headers = ["Authorization" : "Bearer " + (UserDefaults.standard.value(forKey: "token") as? String ?? "")]
        }
        AF.request(String(describing: Url), encoding: URLEncoding.default,headers: headers).responseJSON { response in
            if response.response != nil {
                if let json = response.value {
                    self.responseCode = 1
                    outputBlock(json as AnyObject)
                }else {
                    self.responseCode = 2
                    outputBlock(["Error" : response.error?.localizedDescription] as AnyObject)
                }
            }else {
                self.responseCode = 2
                outputBlock(["Error" : response.error?.localizedDescription] as AnyObject)
            }
        }
    }
    
    func startNewConnectionWithGetTypeWithParam(getUrlString:String,authRequired : Bool = false,params getParams:[String: AnyObject],outputBlock:@escaping (_ receivedData: AnyObject)->Void) {
        
        let Url = baseURL + getUrlString
        print(Url)
        var headers: HTTPHeaders = [:]
        
        if(authRequired){
            headers = ["Authorization" : "Bearer " + (UserDefaults.standard.value(forKey: "token") as? String ?? "")]
        }
        AF.request(String(describing: Url),method: .get ,parameters: getParams as Parameters, encoding: URLEncoding.default,headers: headers).responseJSON { response in
            if response.response != nil {
                if let json = response.value {
                    self.responseCode = 1
                    outputBlock(json as AnyObject)
                }else {
                    self.responseCode = 2
                    outputBlock(["Error" : response.error?.localizedDescription] as AnyObject)
                }
            }else {
                self.responseCode = 2
                outputBlock(["Error" : response.error?.localizedDescription] as AnyObject)
            }
        }
    }
    func startConnectionWithPostTypeWithUrlParam(getUrlString:String ,authRequired : Bool = false,params getParams:[String: AnyObject],outputBlock:@escaping (_ receivedData:AnyObject)->Void) {
        let Url = baseURL + getUrlString
        print(Url)
        var headers: HTTPHeaders = [:]
        
        if(authRequired){
            headers = ["Authorization" : "Bearer " + (UserDefaults.standard.value(forKey: "token") as? String ?? "")]
        }
        
        AF.request(Url, method: .post, parameters: getParams as Parameters,encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            if response.response != nil {
                if !(response.description.isEmpty) {
                    self.responseCode = 1
                    outputBlock(response.description as AnyObject)
                }else {
                    self.responseCode = 2
                    outputBlock(["Error" : response.error?.localizedDescription] as AnyObject)
                }
            }else {
                self.responseCode = 2
                outputBlock(["Error" : response.error?.localizedDescription] as AnyObject)
            }
        }
    }
    
    func startConnectionWithPutTypeWithParam(getUrlString:String ,authRequired : Bool = false,params getParams:[String: AnyObject],outputBlock:@escaping (_ receivedData:AnyObject)->Void) {
        let Url = baseURL + getUrlString
        print(Url)
        var headers: HTTPHeaders = [:]
        
        if(authRequired){
            headers = ["Authorization" : "Bearer " + (UserDefaults.standard.value(forKey: "token") as? String ?? "")]
        }
        
        AF.request(Url, method: .put, parameters: getParams as Parameters,encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            if response.response != nil {
                if !(response.description.isEmpty) {
                    self.responseCode = 1
                    outputBlock(response.description as AnyObject)
                }else {
                    self.responseCode = 2
                    outputBlock(["Error" : response.error?.localizedDescription] as AnyObject)
                }
            }else {
                self.responseCode = 2
                outputBlock(["Error" : response.error?.localizedDescription] as AnyObject)
            }
        }
    }
    
    func startConnectionWithGetTypeSpecialCharacterWithParam(getUrlString:String,authRequired : Bool = false,outputBlock:@escaping (_ receivedData: AnyObject)->Void) {
        
        let Url = baseURL + getUrlString
        let newUrl = Url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        print(newUrl as Any)
        var headers: HTTPHeaders = [:]
        
        if(authRequired){
            headers = ["Authorization" : "Bearer " + (UserDefaults.standard.value(forKey: "token") as? String ?? "")]
        }
        AF.request(String(describing: newUrl ?? ""), encoding: JSONEncoding.default,headers: headers).responseJSON { response in
            if response.response != nil {
                if !(response.description.isEmpty) {
                    self.responseCode = 1
                    outputBlock(response.description as AnyObject)
                }else {
                    self.responseCode = 2
                    outputBlock(["Error" : response.error?.localizedDescription] as AnyObject)
                }
            }else {
                self.responseCode = 2
                outputBlock(["Error" : response.error?.localizedDescription] as AnyObject)
            }
        }
    }
    
    func startConnectionAsPostWithHeader(strUrl: String, param getParams: [String: AnyObject] , header getHeaders: HTTPHeaders, outputBlock: @escaping (_ receivedData: AnyObject)-> Void) {
        
        print(strUrl)
        
        AF.request(strUrl, method: .post, parameters: getParams, encoding: JSONEncoding.default, headers: getHeaders).responseJSON { (response) in
            
            if response.response != nil {
                
                if !(response.description.isEmpty) {
                    self.responseCode = 1
                    
                    outputBlock(response.description as AnyObject)
                }else {
                    self.responseCode = 2
                    outputBlock(["Error" : response.error?.localizedDescription] as AnyObject)
                }
                
            }else {
                self.responseCode = 2
                outputBlock(["Error" : response.error?.localizedDescription] as AnyObject)
            }
        }
    }
    
    func startConnectionWithGetTypeWithoutBaseUrl(getUrlString:String ,outputBlock:@escaping (_ receivedData:AnyObject)->Void) {
        let Url = getUrlString
        print(Url)
        AF.request(Url, encoding: JSONEncoding.default).responseJSON { response in
            if response.response != nil {
                if !(response.description.isEmpty) {
                    self.responseCode = 1
                    outputBlock(response.description as AnyObject)
                }else {
                    self.responseCode = 2
                    outputBlock(["Error" : response.error?.localizedDescription] as AnyObject)
                }
            }else {
                self.responseCode = 2
                outputBlock(["Error" : response.error?.localizedDescription] as AnyObject)
            }
        }
    }
    
    func startConnectionWithDeleteType(getUrlString:String,authRequired : Bool = false ,outputBlock:@escaping (_ receivedData: AnyObject)->Void) {
        let Url = baseURL + getUrlString
        print(Url)
        var headers: HTTPHeaders = [:]
        
        if(authRequired){
            headers = ["Authorization" : "Bearer " + (UserDefaults.standard.value(forKey: "token") as? String ?? "")]
        }
        AF.request(Url, method: .delete, encoding: JSONEncoding.default,headers: headers).responseJSON { response in
            if response.response != nil {
                if !(response.description.isEmpty) {
                    self.responseCode = 1
                    outputBlock(response.description as AnyObject)
                }else {
                    self.responseCode = 2
                    outputBlock(["Error" : response.error?.localizedDescription] as AnyObject)
                }
            }else {
                self.responseCode = 2
                outputBlock(["Error" : response.error?.localizedDescription] as AnyObject)
            }
        }
    }
    
//    func startConnectionWithPutType(getUrlString:String,authRequired : Bool = false ,outputBlock:@escaping (_ receivedData: AnyObject)->Void) {
//        let Url = baseURL + getUrlString
//        print(Url)
//        var headers: HTTPHeaders = [:]
//
//        if(authRequired){
//            headers = ["Authorization" : "Bearer " + (UserDefaults.standard.value(forKey: "token") as? String ?? "")]
//        }
//        AF.request(Url, method: .put, encoding: JSONEncoding.default,headers: headers).responseJSON { response in
//            if response.response != nil {
//                if !(response.description.isEmpty) {
//                    self.responseCode = 1
//                    outputBlock(response.description as AnyObject)
//                }else {
//                    self.responseCode = 2
//                    outputBlock(["Error" : response.error?.localizedDescription] as AnyObject)
//                }
//            }else {
//                self.responseCode = 2
//                outputBlock(["Error" : response.error?.localizedDescription] as AnyObject)
//            }
//        }
//    }
    
    
    func startConnectionWithPostType(getUrlString:String , params getParams:[String: Any],authRequired : Bool = false,outputBlock:@escaping (_ receivedData:AnyObject)->Void) {
        let Url = baseURL + getUrlString
        print(Url)
        print(getParams)
        //        var request = URLRequest(url: URL(string: baseURL + getUrlString)!)
        //
        //        request.httpMethod = "POST"
        //        request.httpBody =
        var headers: HTTPHeaders = [:]
        if(authRequired){
            headers = ["Authorization" : "Bearer " + (UserDefaults.standard.value(forKey: "token") as? String ?? "")]
        }
        print(headers)
        AF.request(Url, method: .post, parameters: getParams as Parameters, encoding: URLEncoding.default,headers: headers).responseJSON { response in
            if response.response != nil {
                if let json = response.value {
                    self.responseCode = 1
                    outputBlock(json as AnyObject)
                }else {
                    self.responseCode = 2
                    outputBlock(["Error" : response.error?.localizedDescription] as AnyObject)
                }
            }else {
                self.responseCode = 2
                outputBlock(["Error" : response.error?.localizedDescription] as AnyObject)
            }
        }
    }
 // ajay 3/08/21
//        func StartConectionWithSingleFile(FileData: Data , FileParam: String , FileName: String , FileMimeType: String , getParams:[String: AnyObject] , getUrlString:String ,authRequired : Bool = false,outputBlock:@escaping (_ receivedData:AnyObject)->Void) {
//
//            let url = URL(string: baseURL + getUrlString)!
//
//            print(url)
//
//            var urlRequest = URLRequest(url: url)
//
//            urlRequest.httpMethod = "POST"
//
//            let parameters = getParams
//
//            var headers: HTTPHeaders = [:]
//            if(authRequired){
//                headers = ["Authorization" : "Bearer " + (UserDefaults.standard.value(forKey: "token") as? String ?? "")]
//            }
//            print(headers)
//            //urlRequest.allHTTPHeaderFields = headers
//
//            AF.upload(multipartFormData: { multipart_FormData in
//
//                multipart_FormData.append(FileData, withName: FileParam, fileName: FileName, mimeType: FileMimeType)
//
//                for (key, value) in parameters {
//
//                    multipart_FormData.append(value.data(using: String.Encoding.utf8.rawValue)!, withName: key)
//
//                }
//            },with: urlRequest,encodingCompletion: { encodingResult in
//
//                switch encodingResult {
//
//                case .success(let upload, _, _):
//
//                    upload.responseJSON { response in
//
//                        if let json = response.result.value {
//
//                            self.responseCode = 1
//                            outputBlock(json as AnyObject)
//
//                        }else {
//
//                            self.responseCode = 2
//                            outputBlock(["Error" : response.error?.localizedDescription] as AnyObject)
//
//                        }
//                    }
//                case .failure(let encodingError):
//
//                    self.responseCode = 2
//
//                    outputBlock(["Error" : encodingError] as AnyObject)
//                }
//            })
//        }
    
    //    func SartConectionWithMultipleFile(FileDataArr: Array<Data> , FileParamArr: Array<String> , FileNameArr: Array<String> , FileMimeTypeArr: Array<String> , getParams:[String: Any] , getUrlString:String ,outputBlock:@escaping (_ receivedData:AnyObject)->Void) {
    //
    //        let url = URL(string: baseURL + getUrlString)!
    //        print(url)
    //        var urlRequest = URLRequest(url: url)
    //
    //        urlRequest.httpMethod = "POST"
    //
    //        let parameters = getParams
    //        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    //        AF.upload(multipartFormData: { multipart_FormData in
    //
    //            for i in 0..<FileDataArr.count {
    //
    //                multipart_FormData.append(FileDataArr[i], withName: FileParamArr[i], fileName: FileNameArr[i], mimeType: FileMimeTypeArr[i])
    //
    //            }
    //
    //            for (key, value) in parameters {
    //
    //
    //                multipart_FormData.append(String(describing: value).data(using: String.Encoding.utf8)!, withName: key)
    //                //                multipart_FormData.append( String(describing:value).data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key)
    //
    //            }
    //
    //
    //
    //
    //        },with: urlRequest,encodingCompletion: { encodingResult in
    //
    //            switch encodingResult {
    //
    //            case .success(let upload, _, _):
    //
    //                upload.responseJSON { response in
    //
    //                    if let json = response.result.value {
    //
    //                        self.responseCode = 1
    //                        outputBlock(json as AnyObject)
    //                    }else {
    //
    //                        self.responseCode = 2
    //                        outputBlock(["Error" : response.error?.localizedDescription] as AnyObject)
    //                    }
    //                }
    //            case .failure(let encodingError):
    //
    //                self.responseCode = 2
    //
    //                outputBlock(["Error" : encodingError] as AnyObject)
    //            }
    //        })
    //    }
    
    
    //    func SartConectionWithMultipleFileusingPatch(FileDataArr: Array<Data> , FileParamArr: Array<String> , FileNameArr: Array<String> , FileMimeTypeArr: Array<String> , getParams:[String: AnyObject] , getUrlString:String ,outputBlock:@escaping (_ receivedData:AnyObject)->Void) {
    //
    //        let url = URL(string: baseURL + getUrlString)!
    //        print(url)
    //        var urlRequest = URLRequest(url: url)
    //
    //        urlRequest.httpMethod = "PATCH"
    //
    //        let parameters = getParams
    //
    //        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    //
    //        AF.upload(multipartFormData: { multipart_FormData in
    //
    //            for i in 0..<FileDataArr.count {
    //
    //                multipart_FormData.append(FileDataArr[i], withName: FileParamArr[i], fileName: FileNameArr[i], mimeType: FileMimeTypeArr[i])
    //
    //            }
    //
    //            for (key, value) in parameters {
    //
    //                multipart_FormData.append(value.data(using: String.Encoding.utf8.rawValue)!, withName: key)
    //
    //            }
    //
    //        },with: urlRequest,encodingCompletion: { encodingResult in
    //
    //            switch encodingResult {
    //
    //            case .success(let upload, _, _):
    //
    //                upload.responseJSON { response in
    //
    //                    if let json = response.result.value {
    //
    //                        self.responseCode = 1
    //                        outputBlock(json as AnyObject)
    //
    //                    }else {
    //
    //                        self.responseCode = 2
    //                        outputBlock(["Error" : response.error?.localizedDescription] as AnyObject)
    //
    //                    }
    //                }
    //            case .failure(let encodingError):
    //
    //                self.responseCode = 2
    //
    //                outputBlock(["Error" : encodingError] as AnyObject)
    //            }
    //        })
    //    }
    
    func startConnectionWithString_Getype(getString: String,outputBlock:@escaping (_ receivedData: AnyObject,_ responceCode: Int) -> Void){
        
        let url = baseURL + getString
        
        print(url)
        
        var request = URLRequest(url: URL(string: url)!)
        
        request.httpMethod = "GET"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //  request.timeoutInterval = 600
        
        AF.request(request as URLRequestConvertible).responseJSON { (responce) in
            
            if responce.response != nil{
                
                if !(responce.description.isEmpty){
                    
                    outputBlock(responce.description as AnyObject,1)
                    
                }else{
                    
                    outputBlock(["Error": responce.error?.localizedDescription] as AnyObject,2)
                    
                }
                
            }else{
                
                outputBlock(["Error": responce.error?.localizedDescription] as AnyObject,3)
                
            }
            
        }
        
    }
    
    
    
    
    func startConnectionWithPatchType(getUrlString:String , params getParams:[String: AnyObject],outputBlock:@escaping (_ receivedData:AnyObject)->Void) {
        let Url = baseURL + getUrlString
        print(Url)
        AF.request(Url, method: .patch, parameters: getParams as Parameters, encoding: JSONEncoding.default).responseJSON { response in
            if response.response != nil {
                if !(response.description.isEmpty) {
                    self.responseCode = 1
                    outputBlock(response.description as AnyObject)
                }else {
                    self.responseCode = 2
                    outputBlock(["Error" : response.error?.localizedDescription] as AnyObject)
                }
            }else {
                self.responseCode = 2
                outputBlock(["Error" : response.error?.localizedDescription] as AnyObject)
            }
        }
    }
    
    
    //    func SartConectionWithMultipleFileWithArray(FileDataArr: Array<Data> , FileParamArr: Array<String> , FileNameArr: Array<String> , FileMimeTypeArr: Array<String> , getParams:[String: Any] , getUrlString:String ,outputBlock:@escaping (_ receivedData:AnyObject,_ responseCode: Int)->Void) {
    //
    //        let url = URL(string: baseURL + getUrlString)!
    //
    //        var urlRequest = URLRequest(url: url)
    //
    //        urlRequest.httpMethod = "POST"
    //
    //        let parameters = getParams
    //
    //        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    //
    //        AF.upload(multipartFormData: { multipart_FormData in
    //
    //            for i in 0..<FileDataArr.count {
    //
    //                multipart_FormData.append(FileDataArr[i], withName: FileParamArr[i], fileName: FileNameArr[i], mimeType: FileMimeTypeArr[i])
    //
    //            }
    //
    //
    //            for (key, value) in parameters {
    //
    //                print(value)
    //
    //                if let _ = value as? [Parameters]{
    //
    //                    if let jsonData = try? JSONSerialization.data(withJSONObject: value, options:[]) {
    //                        multipart_FormData.append(jsonData, withName: key as String)
    //                    }
    //
    //                }else if let _ = value as? Parameters {
    //
    //                    if let jsonData = try? JSONSerialization.data(withJSONObject: value, options:[]) {
    //                        multipart_FormData.append(jsonData, withName: key as String)
    //                    }
    //
    //                } else {
    //                    multipart_FormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
    //                }
    //
    //            }
    //
    //        },with: urlRequest,encodingCompletion: { encodingResult in
    //
    //            switch encodingResult {
    //
    //            case .success(let upload, _, _):
    //
    //                upload.responseJSON { response in
    //
    //                    if let json = response.result.value {
    //
    //                        self.responseCode = 1
    //                        outputBlock(json as AnyObject, 1)
    //
    //                    }else {
    //
    //                        self.responseCode = 2
    //                        outputBlock(["Error" : response.error?.localizedDescription] as AnyObject, 2)
    //
    //                    }
    //                }
    //            case .failure(let encodingError):
    //
    //                self.responseCode = 2
    //
    //                outputBlock(["Error" : encodingError] as AnyObject, 3)
    //
    //            }
    //        })
    //    }
    
    
    
    func startConnectionWithStringGetTypeGoogle(getUrlString:String ,outputBlock:@escaping (_ receivedData: AnyObject)->Void) {
        let Url =  getUrlString
        print(Url)
        AF.request(Url, encoding: JSONEncoding.default).responseJSON { response in
            if response.response != nil {
                if !(response.description.isEmpty) {
                    self.responseCode = 1
                    outputBlock(response.description as AnyObject)
                }else {
                    self.responseCode = 2
                    outputBlock(["Error" : response.error?.localizedDescription] as AnyObject)
                }
            }else {
                self.responseCode = 2
                outputBlock(["Error" : response.error?.localizedDescription] as AnyObject)
            }
        }
    }
    
    
    func startConnectionWithPostTypeWithArray(getUrlString:String ,authRequired : Bool = false, params getParams:[String: Any],outputBlock:@escaping (_ receivedData:AnyObject,_ responceCode: Int)->Void) {
        
        let Url = baseURL + getUrlString
        
        print(Url)
        print(getParams)
        
        var headers: HTTPHeaders = [:]
        
        if let token = UserDefaults.standard.string(forKey: "jwt") {
            
            if(authRequired){
                headers = [
                    "Authorization": "\(token)",
                    "Accept": "application/json"
                ]
            }
            // ["Authorization" : "Bearer " + (UserDefaults.standard.value(forKey: "token") as? String ?? "")]
        }
        
        AF.request(Url, method: .post, parameters: getParams as Parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            if response.response != nil {
                
                if !(response.description.isEmpty) {
                    
                    self.responseCode = 1
                    outputBlock(response.description as AnyObject, 1)
                    
                }else {
                    
                    self.responseCode = 2
                    outputBlock(["Error" : response.error?.localizedDescription] as AnyObject, 2)
                    
                }
            }else {
                
                self.responseCode = 3
                
                outputBlock(["Error" : response.error?.localizedDescription] as AnyObject, 3)
                
            }
        }
    }
    
    //    func SartConectionWithSingleFile(FileData: Data , FileParam: String , FileName: String , FileMimeType: String, getParams:[String: Any] , getUrlString:String ,authRequired : Bool = false, outputBlock:@escaping (_ receivedData:AnyObject,_ responseCode: Int)->Void) {
    //
    //        let url = URL(string: baseURL + getUrlString)!
    //
    //        var urlRequest = URLRequest(url: url)
    //
    //        urlRequest.httpMethod = "POST"
    //
    //        let parameters = getParams
    //
    //        var headers: HTTPHeaders = [:]
    //        // ["Authorization": UserDefaults.standard.value(forKey: "userToken") as? String ?? ""]
    //        if let token = UserDefaults.standard.string(forKey: "userToken") {
    //
    //            if(authRequired){
    //                headers = [
    //                    "Authorization": "\(token)",
    //                    "Accept": "application/json"
    //                ]
    //
    //                //                urlRequest.setValue("\(token)", forHTTPHeaderField: "Authorization")
    //
    //                urlRequest.allHTTPHeaderFields = headers
    //            }
    //
    //        }
    //
    //        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    //
    //        AF.upload(multipartFormData: { multipartFormData in
    //
    //            multipartFormData.append(FileData, withName: FileParam,fileName: FileName, mimeType: FileMimeType)
    //
    //            for (key, value) in getParams {
    //                let val = String(describing: value)
    //                multipartFormData.append(val.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key)
    //            }
    //
    //        },with: urlRequest,encodingCompletion: { encodingResult in
    //
    //            switch encodingResult {
    //
    //            case .success(let upload, _, _):
    //
    //                upload.responseJSON { response in
    //
    //                    if let json = response.result.value {
    //
    //                        self.responseCode = 1
    //                        outputBlock(json as AnyObject, 1)
    //
    //                    }else {
    //
    //                        self.responseCode = 2
    //                        outputBlock(["Error" : response.error?.localizedDescription] as AnyObject, 2)
    //
    //                    }
    //                }
    //            case .failure(let encodingError):
    //
    //                self.responseCode = 2
    //
    //                outputBlock(["Error" : encodingError] as AnyObject, 3)
    //
    //            }
    //        })
    //    }
    // Ye Pehel se Tha
    //    func SartConectionWithSingleFileWithArray(FileDataArr: Data , FileParamArr: String , FileNameArr: String , FileMimeTypeArr: String , getParams:[String: Any] , getUrlString:String ,outputBlock:@escaping (_ receivedData:AnyObject,_ responseCode: Int)->Void) {
    //
    //        let url = URL(string: baseURL + getUrlString)!
    //
    //        var urlRequest = URLRequest(url: url)
    //
    //        urlRequest.httpMethod = "POST"
    //
    //        let parameters = getParams
    //
    //        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    //
    //        Alamofire.upload(multipartFormData: { multipart_FormData in
    //
    //
    //            multipart_FormData.append(FileDataArr, withName: FileParamArr, fileName: FileNameArr, mimeType: FileMimeTypeArr)
    //
    //
    //            for (key, value) in parameters {
    //
    //                print(value)
    //
    //                if let _ = value as? [Parameters]{
    //
    //                    if let jsonData = try? JSONSerialization.data(withJSONObject: value, options: .prettyPrinted) {
    //                        multipart_FormData.append(jsonData, withName: key as String)
    //                    }
    //
    //                }else if let _ = value as? Parameters {
    //
    //                    if let jsonData = try? JSONSerialization.data(withJSONObject: value, options: .prettyPrinted) {
    //                        multipart_FormData.append(jsonData, withName: key as String)
    //                    }
    //
    //                }else if let _ = value as? Array<Int> {
    //
    //                    if let str = ((value as? [Int])?.map({"\($0)"}))?.joined(separator:",") {
    //                        do{
    //
    //                            if let jsonData = try? Data(str.utf8) {
    //
    //                                multipart_FormData.append(jsonData, withName: key as String)
    //
    //                            }
    //                        }
    //                        catch{
    //                            print(error.localizedDescription)
    //                        }
    //
    //                    }
    //
    //                } else {
    //                    multipart_FormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
    //                }
    //
    //            }
    //
    //        },with: urlRequest,encodingCompletion: { encodingResult in
    //
    //            switch encodingResult {
    //
    //            case .success(let upload, _, _):
    //
    //                upload.responseJSON { response in
    //
    //                    if let json = response.result.value {
    //
    //                        self.responseCode = 1
    //                        outputBlock(json as AnyObject, 1)
    //
    //                    }else {
    //
    //                        self.responseCode = 2
    //                        outputBlock(["Error" : response.error?.localizedDescription] as AnyObject, 2)
    //
    //                    }
    //                }
    //            case .failure(let encodingError):
    //
    //                self.responseCode = 2
    //
    //                outputBlock(["Error" : encodingError] as AnyObject, 3)
    //
    //            }
    //        })
    //    }
    
}

extension UIImageView {
    
    func downLoadImage(ImageURL: String , PlaceholderImage: UIImage) {
        
        self.image = PlaceholderImage
        
        self.accessibilityHint = (imgURL + ImageURL).replacingOccurrences(of: " ", with: "%20")
        
        //print(imgURL + ImageURL)
        
        AF.request((imgURL + ImageURL).replacingOccurrences(of: " ", with: "%20")).responseData { (response) in
            
            if "\(response.request!)" == self.accessibilityHint {
                
                if response.error == nil {
                    
                    if let data = response.data {
                        
                        if UIImage(data: data) != nil {
                            
                            self.image = UIImage(data: data)
                            
                        }else {
                            
                            self.image = PlaceholderImage
                            
                        }
                    }
                }
            }
        }
    }
    
    func downLoadImageWithoutBaseURL(ImageURL: String , PlaceholderImage: UIImage) {
        
        self.image = PlaceholderImage
        
        self.accessibilityHint = ImageURL.replacingOccurrences(of: " ", with: "%20")
        
        AF.request(ImageURL.replacingOccurrences(of: " ", with: "%20")).responseData { (response) in
            
            print(ImageURL)
            
            if "\(response.request!)" == self.accessibilityHint {
                
                if response.error == nil {
                    
                    if let data = response.data {
                        
                        if UIImage(data: data) != nil {
                            
                            self.image = UIImage(data: data)
                            
                        }else {
                            
                            self.image = PlaceholderImage
                            
                        }
                    }
                }
            }
        }
    }
    
    func downLoadImage(ImageURL: String) {
        
        self.accessibilityHint = (imgURL + ImageURL).replacingOccurrences(of: " ", with: "%20")
        
        AF.request((imgURL + ImageURL).replacingOccurrences(of: " ", with: "%20")).responseData { (response) in
            
            if "\(response.request!)" == self.accessibilityHint {
                
                if response.error == nil {
                    
                    if let data = response.data {
                        
                        if UIImage(data: data) != nil {
                            
                            self.image = UIImage(data: data)
                            
                        }
                    }
                }
            }
        }
    }
    
}

