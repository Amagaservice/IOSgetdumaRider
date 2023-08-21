//
//  SendOTPViewController.swift
//  Ocory
//
//  Created by Arun Singh on 2/11/21.
//

import UIKit

class SendOTPViewController: UIViewController {

    //MARK:- OUTLETS
    @IBOutlet weak var sendOTP_btn: UIButton!
    @IBOutlet weak var registeredMail_txtField: SetTextField!
    @IBOutlet weak var cancel_btn: UIButton!
    
    //MARK:- Variables
    let conn = webservices()
    
    //MARK:- Default Func
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setView()
      //  NotificationCenter.default.addObserver(self, selector: #selector(dismissSelf), name: .dismissForget, object: nil)
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        
//        self.dismiss(animated: true, completion: nil)
//    }
    
    //MARK:- User Defined Func
    
    func setView(){
        
        self.sendOTP_btn.layer.cornerRadius = 5
        self.cancel_btn.layer.cornerRadius = 5
    }
    
    @objc func dismissSelf(){
        
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Button Action
    @IBAction func tapSendOTP_btn(_ sender: Any) {
        
        if self.registeredMail_txtField.text == ""{
            
            self.showAlert("GetDuma", message: "Please enter registered email")
        }else{
            
            self.resendOtpApi()
        }
       
    }
    @IBAction func tapCancel_btn(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    

}
//MARK:- Web Api
extension SendOTPViewController{
    //MARK:- resent otp api 
    func resendOtpApi(){
        Indicator.shared.showProgressView(self.view)
        let param = ["email":self.registeredMail_txtField.text!]
        self.conn.startConnectionWithPostType(getUrlString: "resend", params: param) { (value) in
            Indicator.shared.hideProgressView()
            let msg = (value["message"] as? String ?? "")
            if self.conn.responseCode == 1{
                
                print(value)
                if ((value["status"] as? Int ?? 0) == 1){
                    
                    self.showAlertWithAction(Title: "GetDuma", Message: msg, ButtonTitle: "OK") {
                        
                        let vc = self.storyboard?.instantiateViewController(identifier: "ResetPasswordViewController") as! ResetPasswordViewController
                        vc.modalPresentationStyle = .overFullScreen
                        let transition = CATransition()
                        transition.duration = 0.5
                        transition.type = CATransitionType.fade
                        transition.subtype = CATransitionSubtype.fromTop
                        self.view.window!.layer.add(transition, forKey: kCATransition)
                        self.present(vc, animated: true, completion: nil)
                    }
                }else{
                    
                    self.showAlert("GetDuma", message: msg)
                }
                
            }
        }
    }
}
extension Notification.Name{
    
    static let dismissForget = Notification.Name("dismissForget")
}
