//
//  helpDetailVC.swift
//  Ocory
//
//  Created by malika saini on 01/09/22.
//

import UIKit

class helpDetailVC: UIViewController {

    @IBOutlet weak var mContactnoBTN: UIButton!
    @IBOutlet weak var mEmailBTN: UIButton!
    @IBOutlet weak var mHelpTitleLBL: UILabel!
    @IBOutlet weak var mDetailTF: UITextView!
    let conn = webservices()

    var HelpTitle = ""
    var question_id = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        mDetailTF.contentInset = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
        mHelpTitleLBL.text = HelpTitle
        mDetailTF.delegate = self
        mDetailTF.text = "Write Short Description"
        mDetailTF.textColor = UIColor.lightGray
        mDetailTF.delegate = self
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            NavigationManager.pushToLoginVC(from: self)
        }
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "green")
        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.5058823529, green: 0.7411764706, blue: 0.09803921569, alpha: 1)
      
        self.setNavButton()
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = "Help"
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    // Mark : set nav bar button
    func setNavButton(){
        
        let logoBtn = UIButton(type: .custom)
        logoBtn.setImage(UIImage(named: "shape_28"), for: .normal)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.5058823529, green: 0.7411764706, blue: 0.09803921569, alpha: 1)
        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.5058823529, green: 0.7411764706, blue: 0.09803921569, alpha: 1)

        
        logoBtn.addTarget(self, action: #selector(tapNavButton), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: logoBtn)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    @objc func tapNavButton(){
        
        let presentedVC = self.storyboard!.instantiateViewController(withIdentifier: "SideMenuViewController")
        let nvc = UINavigationController(rootViewController: presentedVC)
        present(nvc, animated: false, pushing: true, completion: nil)
    }
    @IBAction func mEmailBTN(_ sender: Any) {
        // create an actionSheet
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        // create an action
        let firstAction: UIAlertAction = UIAlertAction(title: "Email", style: .default) { action -> Void in
            
            print("First Action pressed")
            let email = "info@getduma.com"
            if let url = URL(string: "mailto:\(email)") {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }

        let secondAction: UIAlertAction = UIAlertAction(title: "Gmail", style: .default) { action -> Void in

            print("Second Action pressed")
            let email = "info@getduma.com"
            let googleUrlString = "googlegmail://"

            if let googleUrl = URL(string: googleUrlString) {
                UIApplication.shared.open(googleUrl, options: [:]) {
                    success in
                    if !success {
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(googleUrl)
                        } else {
                            UIApplication.shared.openURL(googleUrl)
                        }
                    }
                }
            }
            else {
                print("Could not get URL from string")
            }
        }

        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }

        // add actions
        actionSheetController.addAction(firstAction)
        actionSheetController.addAction(secondAction)
        actionSheetController.addAction(cancelAction)


        // present an actionSheet...
        // present(actionSheetController, animated: true, completion: nil)   // doesn't work for iPad

        present(actionSheetController, animated: true) {
            print("option menu presented")
        }
        
        

        
    }
    @IBAction func mCAllBTN(_ sender: Any) {
        let url: NSURL = URL(string: "TEL://802-375-5793")! as NSURL
           UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        
//      //  let number = mContactnoBTN.currentTitle as! String
//        if let url = URL(string: "tel:// 802-375-5793"),
//          UIApplication.shared.canOpenURL(url) {
//             if #available(iOS 10, *) {
//               UIApplication.shared.open(url, options: [:], completionHandler:nil)
//              } else {
//                  UIApplication.shared.openURL(url)
//              }
//          } else {
//                   // add error message here
//          }
      
        
    }
    @IBAction func mSubmitBTN(_ sender: Any) {
        
        if mDetailTF.text == "Write Short Description" || mDetailTF.text == ""{
            self.showAlert("GetDuma", message: "Please enter Description to submit")
        }else{
            helpPOST()
        }
        
    }
    
}

extension helpDetailVC : UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        
        if mDetailTF.textColor == UIColor.lightGray {
           
            mDetailTF.text = ""
            mDetailTF.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if mDetailTF.text.isEmpty {
            mDetailTF.text = "Write Short Description"
            mDetailTF.textColor = UIColor.lightGray
        }
    }
}

//MARK:- Web Api
extension helpDetailVC{
    //MARK:- save answer api 
    func helpPOST() {
        let param = ["question_id":self.question_id,"answer":self.mDetailTF.text!, "ride_id": kRideId] as [String : Any]
        Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithPostType(getUrlString: "save_answer", params: param,authRequired: true) { (value) in
            //   print(value)
            let msg = (value["message"] as? String ?? "")
            Indicator.shared.hideProgressView()
            if self.conn.responseCode == 1{
                print(value)
                if (value["status"] as? Int ?? 0) == 1{
                   // self.navigationController?.popViewController(animated: true)
                    self.showAlert("GetDuma", message: "Your answer has been saved successfully")
                }
                else{
                    self.showAlert("GetDuma", message: msg)
                }
            }
            else{
                print("No Ride Available")
                guard var stat = value["Error"] as? String, stat == "ok" else {
                //    self.showAlert("GetDuma", message: "\(String(describing: stat))")
                    return
                }
            }
        }
    }
    
    
//
//    func helpPOST(){
//        let param = ["question_id":self.question_id,"answer":self.mDetailTF.text!, "ride_id": kRideId] as [String : Any]
//        Indicator.shared.showProgressView(self.view)
//        self.conn.startConnectionWithPostType(getUrlString: "save_answer", params: param, outputBlock: { (value) in
//            Indicator.shared.hideProgressView()
//            if self.conn.responseCode == 1{
//                print(value)
//                let msg = (value["message"] as? String ?? "")
//                if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: value["data"] as? [String:Any] ?? "", requiringSecureCoding: false) {
//                    UserDefaults.standard.set(savedData, forKey: "loginInfo")
//                }
//                if ((value["status"] as? Int ?? 0) == 1){
//
//                    self.showAlert("GetDuma", message: "Submit Done")
//
//                }else{
//                    self.showAlert("GetDuma", message: msg)
//                }
//            }
//        })
//    }
}
