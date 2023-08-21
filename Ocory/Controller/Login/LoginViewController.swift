//
//  LoginViewController.swift
//  Ocory
//
//  Created by Arun Singh on 2/11/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet weak var emailAddress_txtField: UITextField!
    @IBOutlet weak var password_txtField: UITextField!
    @IBOutlet weak var login_btn: UIButton!
    
    //MARK:- Variables
    let conn = webservices()
    
    //MARK:- Default Func
    override func viewDidLoad() {
        super.viewDidLoad()
        emailAddress_txtField.setLeftPaddingPoints(20)
        password_txtField.setLeftPaddingPoints(20)

        //   self.emailAddress_txtField.text = "jawwad.khan@niletechnologies.com"
        //     self.password_txtField.text = "abc@123"
        self.setView()
        self.navigationController?.isNavigationBarHidden = true
     //   self.emailAddress_txtField.text = "monday@gmail.com"
    //    self.password_txtField.text = "abc@123"
    }
    //MARK:- Button Action
    @IBAction func tapEyePassword_btn(_ sender: UIButton) {
        password_txtField.isSecureTextEntry.toggle()
         if password_txtField.isSecureTextEntry {
             if let image = UIImage(systemName: "eye.slash.fill") {
                 sender.setImage(image, for: .normal)
             }
         } else {
             if let image = UIImage(systemName: "eye.fill") {
                 sender.setImage(image, for: .normal)
             }
         }
    }
    @IBAction func tapLogin_btn(_ sender: Any) {
        if self.emailAddress_txtField.text == ""{
            self.showAlert("GetDuma", message: "Please enter email address")
        }else if self.password_txtField.text == ""{
            
            self.showAlert("GetDuma", message: "Please enter password")
        }else{
            self.loginApi()
        }
    }
    @IBAction func tapSignUp_btn(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func tapForgotPass_btn(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "SendOTPViewController") as! SendOTPViewController
        vc.modalPresentationStyle = .overFullScreen
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.fade
        transition.subtype = CATransitionSubtype.fromTop
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(vc, animated: true, completion: nil)
    }
    //MARK:- User Defined Func
    func setView(){
        self.login_btn.layer.cornerRadius = 5
    }
}
//MARK:- Web Api
extension LoginViewController{
    // MARK:- login api
    func loginApi(){
        var deviceID =  UIDevice.current.identifierForVendor?.uuidString
        print(deviceID)
//        let gcm_token = AppDelegate.fcmToken
//        NSUSERDEFAULT.setValue(gcm_token, forKey: kFcmToken)
      //  NSUSERDEFAULT.setValue(fcmToken, forKey: kFcmToken)
        let param = ["email":self.emailAddress_txtField.text!,"password":self.password_txtField.text!,"device_token": deviceID ?? "", "device_type": "ios", "utype":1 , "gcm_token" :  NSUSERDEFAULT.value(forKey: kFcmToken) as? String ?? ""] as [String : Any]
        Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithPostType(getUrlString: "login", params: param, outputBlock: { (value) in
            Indicator.shared.hideProgressView()
            if self.conn.responseCode == 1{
                print(value)
                let msg = (value["message"] as? String ?? "")
                if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: value["data"] as? [String:Any] ?? "", requiringSecureCoding: false) {
                    UserDefaults.standard.set(savedData, forKey: "loginInfo")
                }
                if ((value["status"] as? Int ?? 0) == 1){
                    let token = (value["token"] as? String ?? "")
                    let data = (value["data"] as? [String:Any] ?? [:])
                    let userId = (data["user_id"] as? String ?? "")
                    let gcm = (data["gcm_token"] as? String ?? "")
                    let is_card = (data["is_card"] as? Int ?? 0)
                    let add_card = (data["add_card"] as? Int ?? 0)
                    let country_code = (data["country_code"] as? String ?? "")
                    let mobile = (data["mobile"] as? String ?? "")
//                    var mobileno = country_code + mobile
//
//                    let country_code = self.profileDetails?.country_code ?? ""
//                    let mobile = self.profileDetails?.mobile ?? ""
//                 //   var mobileno = country_code + mobile
                    NSUSERDEFAULT.set(mobile, forKey: kownMobile)
                    NSUSERDEFAULT.set(country_code, forKey: kownCcode)

                    
                   // NSUSERDEFAULT.set(mobileno, forKey: kownMobile)
                    
                    NSUSERDEFAULT.setValue(gcm, forKey: kDeviceToken)
                    NSUSERDEFAULT.set(token, forKey: accessToken)
                    NSUSERDEFAULT.set(userId, forKey: kUserID)
                    NSUSERDEFAULT.setValue(self.password_txtField.text!, forKey: kPassword)
                    UserDefaults.standard.synchronize()
                    if add_card == 0{
                        NSUSERDEFAULT.set(true, forKey: kUserLogin)
                        self.loginlogoutAPI(statut: "1")
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else if is_card == 1 && add_card == 1{
                        self.loginlogoutAPI(statut: "1")
                        NSUSERDEFAULT.set(true, forKey: kUserLogin)
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        self.loginlogoutAPI(statut: "2")
                        NSUSERDEFAULT.set(false, forKey: kUserLogin)
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignupPaymentVC") as! SignupPaymentVC
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }else{
                    self.showAlert("GetDuma", message: msg)
                }
            }
        })
    }
    // MARK:- update login logout status api 
    func loginlogoutAPI(statut: String){
        let param = ["status": statut] as [String : Any]
        Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithPostType(getUrlString: "updateloginlogout", params: param,authRequired: true) { (value) in
            print(value)
            Indicator.shared.hideProgressView()
            if self.conn.responseCode == 1{
                let msg = (value["status"] as? String ?? "")
                print(msg)
            }
        }
    }
}
