//
//  ProfileAPI.swift
//  Ocory
//
//  Created by nile on 14/07/21.
//

import Foundation
import Alamofire
//MARK:- Web Api
extension ProfileViewController{
   //MARK:- get profile data API
    func getProfileDataApi() {
        
        Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithGetTypeWithParam(getUrlString: "get_profile",authRequired: true) { (value) in
            
            print(value)
            Indicator.shared.hideProgressView()
            if self.conn.responseCode == 1{
                print(value)
                if (value["status"] as? Int ?? 0) == 1{
                    let data = (value["data"] as? [String:AnyObject] ?? [:])
                    do{
                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                        self.profileDetails = try newJSONDecoder().decode(ProfileData.self, from: jsonData)
                    
                        let country_code = self.profileDetails?.country_code ?? ""
                        let mobile = self.profileDetails?.mobile ?? ""
                     //   var mobileno = country_code + mobile
                        NSUSERDEFAULT.set(mobile, forKey: kownMobile)
                        NSUSERDEFAULT.set(country_code, forKey: kownCcode)

                        self.setData()
//                        self.userImg.isUserInteractionEnabled = false
//                        self.name_txtField.isUserInteractionEnabled = false
//                        self.email_txtField.isUserInteractionEnabled = false
//                        self.mobile_txtField.isUserInteractionEnabled = false
                    }catch{
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func updateProfileApi(imageOrVideo : UIImage?,params: [String: Any]){
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + (UserDefaults.standard.value(forKey: "token") as? String ?? ""),
            "Content-type": "multipart/form-data"
        ]
        
        Indicator.shared.showProgressView(self.view)
        AF.upload(multipartFormData: { multipartFormData in
            
//            if imageData != nil{
//                multipartFormData.append(imageData!,
//                                         withName: "avatar" , fileName: "avatar.jpg", mimeType: "image/jpeg"
//                )
//            }
            if imageOrVideo != nil{
                let imageData = imageOrVideo!.jpegData(compressionQuality: 0.20)
                multipartFormData.append(imageData!,
                                         withName: "verification_id" , fileName: "verification_id.jpg", mimeType: "image/jpeg"
                )
            }
        
            for p in params {
                multipartFormData.append("\(p.value)".data(using: String.Encoding.utf8)!, withName: p.key)
                print("KEY VALUE DATA===========\(p.key)"=="-----+++++----\(p.value)")
            }
        },
        to: "\(baseURL)update_profile_of_user", method: .post , headers: headers )
        .responseJSON(completionHandler: { (data) in
            let d = data.value
            let value = (d as? [String:Any] ?? [:])
            print(value)
            let msg = (value["message"] as? String ?? "")
            if (value["status"] as? Int ?? 0) == 1{
                self.showAlertWithAction(Title: "GetDuma", Message: "Profile updated successfully", ButtonTitle: "Ok")
                {
                    self.getProfileDataApi()
                }
            }else{
                Indicator.shared.hideProgressView()
                self.showAlert("GetDuma", message: msg)
            }
        })
    }
    func uploadProfilePhotoAPI( image: UIImage, params: [String : Any]){
        let imageData = image.jpegData(compressionQuality: 0.50)
              print("image data\(String(describing: imageData))")
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data",
            "Accept": "application/json",
            "authorization": "Bearer \(UserDefaults.standard.value(forKey: "token") as? String ?? "")"
        ]
        Indicator.shared.showProgressView(self.view)
        AF.upload(multipartFormData: { multiPart in
            for p in params {
                multiPart.append("\(p.value)".data(using: String.Encoding.utf8)!, withName: p.key)
            }
            multiPart.append(imageData!, withName: "profile_pic", fileName: "profile_pic.jpg", mimeType: "image/jpg")
        }, to: "\(baseURL)upload_profile_pic", method: .post, headers: headers) .uploadProgress(queue: .main, closure: { progress in
            print("Upload Progress: \(progress.fractionCompleted)")
        }).responseJSON(completionHandler: { data in
            print("upload finished: \(data)")
            Indicator.shared.hideProgressView()
            let d = data.value
            let value = (d as? [String:Any] ?? [:])
            print(value)
            let msg = (value["message"] as? String ?? "")
            if (value["status"] as? Int ?? 0) == 1{
                self.showAlertWithAction(Title: "GetDuma", Message: msg, ButtonTitle: "Ok")
                {
                    self.getProfileDataApi()
                }
            }else{
                Indicator.shared.hideProgressView()
                self.showAlert("GetDuma", message: msg)
            }
        }).response { (response) in
            switch response.result {
                
            case .success(let resut):
                print("upload success result: \(resut)")
            case .failure(let err):
                print("upload err: \(err)")
            }
        }
    }
    
    func uploadPhotoGallaryNew(media: UIImage, params: [String:Any]){
        let imageData = media.jpegData(compressionQuality: 0.20)
              print("image data\(String(describing: imageData))")
        let url = URL(string: "\(baseURL)upload_profile_pic")!
        let headers: HTTPHeaders = [
           // "Content-type": "multipart/form-data",
            "Accept": "application/json",
            "authorization": "Bearer \(UserDefaults.standard.value(forKey: "token") as? String ?? "")"
        ]
        Indicator.shared.showProgressView(self.view)
        AF.upload(multipartFormData: { multipartFormData in
            
            if imageData != nil{
                multipartFormData.append(imageData!,
                                         withName: "profile_pic" , fileName: "profile_pic.jpg", mimeType: "image/jpeg"
                                     )
            }
          
            for (key, value) in params {
                multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
                print("KEY VALUE DATA===========\(key)"=="-----+++++----\(value)")
            }
        }, to: url, headers: headers)
        .responseJSON { response in
            print("URL AND HEADERS==========\(headers)")
            print(response)
            Indicator.shared.hideProgressView()
            switch (response.result) {
            case .success(let JSON):
                print("JSON: \(JSON)")
                let responseString = JSON as! NSDictionary
                print(responseString)
                let msg = responseString["message"] as? String ?? ""
                if (responseString["status"] as? Int ?? 0) == 1 {
                    self.showAlert("GetDuma", message: msg)
                }
                else{
                    self.showAlert("GetDuma", message: msg)
                }
                break;
            case .failure(let error):
                print(error)
                self.showAlert("GetDuma", message: "\(error.localizedDescription)")
                break
            }
        }
    }
    
    func uploadPhotoGallaryNewSignup(imageData: UIImage , params: [String:Any]){
        let imageData = imageData.jpegData(compressionQuality: 0.20)
              print("image data\(String(describing: imageData))")
        let url = URL(string: "\(baseURL)upload_verification_id")!
        let headers: HTTPHeaders = [
           // "Content-type": "multipart/form-data",
            "Accept": "application/json",
            "authorization": "Bearer \(UserDefaults.standard.value(forKey: "token") as? String ?? "")"
        ]
        Indicator.shared.showProgressView(self.view)
        AF.upload(multipartFormData: { multipartFormData in
            
            if imageData != nil{
                multipartFormData.append(imageData!,
                                         withName: "verification_id" , fileName: "verification_id.jpg", mimeType: "image/jpeg")
            }
          
            for (key, value) in params {
                multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
                print("KEY VALUE DATA===========\(key)"=="-----+++++----\(value)")
            }
        }, to: url, headers: headers)
        .responseJSON { response in
            print("URL AND HEADERS==========\(headers)")
            print(response)
            Indicator.shared.hideProgressView()
            switch (response.result) {
            case .success(let JSON):
                print("JSON: \(JSON)")
                let responseString = JSON as! NSDictionary
                print(responseString)
                let msg = responseString["message"] as? String ?? ""
                if (responseString["status"] as? Int ?? 0) == 1 {
                    self.showAlert("GetDuma", message: msg)
                }
                else{
                    self.showAlert("GetDuma", message: msg)
                }
                break;
            case .failure(let error):
                print(error)
                self.showAlert("GetDuma", message: "\(error.localizedDescription)")
                break
            }
        }
      
    }
    
}

