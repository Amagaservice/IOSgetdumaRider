//
//  ResetPasswordViewController.swift
//  Ocory
//
//  Created by Arun Singh on 26/02/21.
//

import UIKit

class ResetPasswordViewController: UIViewController {

    //MARK:- OUTLETS
    @IBOutlet weak var registeredEmail_txtField: SetTextField!
    @IBOutlet weak var enterOtp_txtField: SetTextField!
    @IBOutlet weak var newPass_txtField: SetTextField!
    @IBOutlet weak var confirmPass_txtField: SetTextField!
    
    
    //MARK:- Variables
    let conn = webservices()
    
    //MARK:- Default Func
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    @IBAction func tapEyePassword_btn(_ sender: UIButton) {
        newPass_txtField.isSecureTextEntry.toggle()
         if newPass_txtField.isSecureTextEntry {
             if let image = UIImage(systemName: "eye.slash.fill") {
                 sender.setImage(image, for: .normal)
             }
         } else {
             if let image = UIImage(systemName: "eye.fill") {
                 sender.setImage(image, for: .normal)
             }
         }
    }
    
    @IBAction func tapEyeConfirmPassword_btn(_ sender: UIButton) {
        confirmPass_txtField.isSecureTextEntry.toggle()
         if confirmPass_txtField.isSecureTextEntry {
             if let image = UIImage(systemName: "eye.slash.fill") {
                 sender.setImage(image, for: .normal)
             }
         } else {
             if let image = UIImage(systemName: "eye.fill") {
                 sender.setImage(image, for: .normal)
             }
         }
    }
    
    //MARK:- User Defined Func
    
    
    
    
    //MARK:- Button Action
    
    @IBAction func tapResetPass_btn(_ sender: Any) {
        
        if self.registeredEmail_txtField.text == ""{
            
            self.showAlert("GetDuma", message: "Please enter registered email")
        }else if !(Validation().isValidEmail(self.registeredEmail_txtField.text!)){
            
            self.showAlert("GetDuma", message: "Please enter valid email id")
        }else if self.enterOtp_txtField.text == ""{
            
            self.showAlert("GetDuma", message: "Please enter OTP")
        }else if self.newPass_txtField.text == ""{
            
            self.showAlert("GetDuma", message: "Please enter new password")
        }else if ((self.newPass_txtField.text!.count) < 6){
            
            self.showAlert("GetDuma", message: "Please enter six character password")
        }else if self.confirmPass_txtField.text == ""{
            
            self.showAlert("GetDuma", message: "Please enter confirm password")
        }else if !(self.newPass_txtField.text! == self.confirmPass_txtField.text!){
            
            self.showAlert("GetDuma", message: "Please enter same password in new password and confirm password")
        }else{
            
            self.resetPasswordApi()
        }
    }
    @IBAction func tapCancel_btn(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: .dismissForget, object: nil)
    }
    


}
extension ResetPasswordViewController{
    //MARK:- forgot password's reset password api 
    func resetPasswordApi(){
        
        let param = ["email":self.registeredEmail_txtField.text!,"otp":self.enterOtp_txtField.text!,"password":self.newPass_txtField.text!]
        
        self.conn.startConnectionWithPostType(getUrlString: "forgot-password", params: param) { (value) in
            
            if self.conn.responseCode == 1{
                
                print(value)
                let msg = (value["message"] as? String ?? "")
                if (value["status"] as? Int ?? 0) == 1{
                    
                    self.showAlertWithAction(Title: "Ocory", Message: msg, ButtonTitle: "Ok") {
                        
                        self.dismiss(animated: true, completion: nil)
                        NotificationCenter.default.post(name: .dismissForget, object: nil)
                    }
                }else{
                    
                    self.showAlert("Ocory", message: msg)
                }
            }
        }
    }
}

