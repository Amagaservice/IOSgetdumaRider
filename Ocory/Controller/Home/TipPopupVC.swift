//
//  TipPopupVC.swift
//  Ocory
//
//  Created by malika on 04/10/22.
//

import UIKit

protocol tipPopup{
    func tip(amount : String?)
}
class TipPopupVC: UIViewController {

    @IBOutlet weak var mTextFLD: UITextField!
    var delegate : tipPopup?
    override func viewDidLoad() {
        super.viewDidLoad()
        mTextFLD.setLeftPaddingPoints(40)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func mSkipBTN(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func mDoneBTN(_ sender: Any) {
        if mTextFLD.text != ""{
            self.dismiss(animated: true, completion: {
                self.delegate?.tip(amount: self.mTextFLD.text)
            })
        }
        
    }
    
}
