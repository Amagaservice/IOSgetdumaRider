//
//  ChangePasswordViewController.swift
//  Ocory
//
//  Created by Arun Singh on 24/02/21.
//

import UIKit

class ChangePasswordViewController: UIViewController {

    //MARK:- OUTLETS
    
    @IBOutlet weak var oldPass_txtField: SetTextField!
    @IBOutlet weak var newPassword_txtField: SetTextField!
    @IBOutlet weak var cnfPassword_txtField: SetTextField!
    
    
    //MARK:- Variables
    let conn = webservices()
    
    //MARK:- Default Func
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Button Action
    @IBAction func tapEyeOldPassword_btn(_ sender: UIButton) {
        oldPass_txtField.isSecureTextEntry.toggle()
         if oldPass_txtField.isSecureTextEntry {
             if let image = UIImage(systemName: "eye.slash.fill") {
                 sender.setImage(image, for: .normal)
             }
         } else {
             if let image = UIImage(systemName: "eye.fill") {
                 sender.setImage(image, for: .normal)
             }
         }
    }
    
    @IBAction func tapEyeNewPassword_btn(_ sender: UIButton) {
        newPassword_txtField.isSecureTextEntry.toggle()
         if newPassword_txtField.isSecureTextEntry {
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
        cnfPassword_txtField.isSecureTextEntry.toggle()
         if cnfPassword_txtField.isSecureTextEntry {
             if let image = UIImage(systemName: "eye.fill") {
                 sender.setImage(image, for: .normal)
             }
         } else {
             if let image = UIImage(systemName: "eye.slash.fill") {
                 sender.setImage(image, for: .normal)
             }
         }
    }
   
    @IBAction func tapChangePass_btn(_ sender: Any) {
        let oldPass = NSUSERDEFAULT.value(forKey: kPassword) ?? ""
        if self.oldPass_txtField.text == ""{
            self.showAlert("GetDuma", message: "Please enter old password")
        }
        else if self.oldPass_txtField.text !=  oldPass as? String {
            self.showAlert("GetDuma", message: "Please enter valid password")
        }
        else if self.newPassword_txtField.text == ""{
            
            self.showAlert("GetDuma", message: "Please enter new password")
        }else if (self.newPassword_txtField.text?.count ?? 0) < 6{
            
            self.showAlert("GetDuma", message: "Please enter six character password")
        }else if self.cnfPassword_txtField.text == ""{
            
            self.showAlert("GetDuma", message: "Please enter confirm password")
        }else if !(self.newPassword_txtField.text == self.cnfPassword_txtField.text){
            
            self.showAlert("GetDuma", message: "Please enter same password in new and confirm password field")
        }else{
            
            self.changePassApi()
        }
        
    }
    

    

}
//MARK:- Web Api
extension ChangePasswordViewController{
    //MARK:- change password
    func changePassApi(){
        
        let param = ["new_password":self.newPassword_txtField.text!,"confirm_password":self.cnfPassword_txtField.text!]
        Indicator.shared.showProgressView(self.view)
        
        self.conn.startConnectionWithPostType(getUrlString: "change_password", params: param,authRequired: true) { (Value) in
            Indicator.shared.hideProgressView()
            if self.conn.responseCode == 1{
                let msg = (Value["message"] as? String ?? "")
                if (Value["status"] as? Int ?? 0) == 1{
                    print(Value)
                    NSUSERDEFAULT.removeObject(forKey: kPassword)
                    NSUSERDEFAULT.setValue(self.newPassword_txtField.text!, forKey: kPassword)
                    self.showAlertWithAction(Title: "Get duma", Message: msg, ButtonTitle: "OK") {
                        self.dismiss(animated: true, completion: nil)
                    }
                }else{
                    self.showAlert("Get duma", message: msg)
                }
            }
        }
    }
}
