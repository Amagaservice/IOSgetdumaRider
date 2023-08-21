//
//  PaymentVC.swift
//  Ocory
//
//  Created by nile on 20/09/21.
//

import UIKit
import Stripe
import Alamofire

class PaymentVC: UIViewController {
    @IBOutlet weak var payment_tableView: UITableView!
    @IBOutlet weak var paymentBtn: UIButton!
    @IBOutlet weak var addCardBtn: UIButton!
    @IBOutlet weak var stackHeight: NSLayoutConstraint!
    
    let conn = webservices()
    var completedRidesData = [RidesData]()
    var ridesStatusData : RidesData?
    var cardData = [cardDataModal]()
    var vcCome = comeFrom.AddCard
    var vcCard = paymentType.withoutCard
    var  checkBtnStatus = false
    var isSelected = false
    var selectedIndex  = 0
    var completedRideId = ""
    var completedAmount = ""
    var completedStatus = false
    var completedFromPaynowStatus = false
    var lastRideData : LastRideModal?
    var screen = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        print(vcCome)
        self.payment_tableView.dataSource = self
        self.payment_tableView.delegate = self
        self.registerCell()
        self.navigationController?.isNavigationBarHidden = false
        self.setNavButton()
        if vcCome == .AddCard{
            addCardBtn.isHidden = false
            paymentBtn.isHidden = true
            stackHeight.constant = 60
        }
        else{
            paymentBtn.isHidden = false
            addCardBtn.isHidden = false
            stackHeight.constant = 120
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            NavigationManager.pushToLoginVC(from: self)
        }
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = "Payment Method"
        self.savedCardApi()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        
      
    }
    //MARK:- User Defined Func
    
    func registerCell(){
        let compNib = UINib(nibName: "PaymentVCCell", bundle: nil)
        self.payment_tableView.register(compNib, forCellReuseIdentifier: "PaymentVCCell")
    }
    
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
 
    @IBAction func addCardBtnAction(_ sender: Any) {
        vcCard = .withoutCard
        let vc = self.storyboard?.instantiateViewController(identifier: "PaymentDetailVC") as! PaymentDetailVC
        vc.ridesStatusData = ridesStatusData
        if vcCome == .AddCard{
            vc.vcCome = .AddCard
            vc.goBackDelegate = self
        }
        else{
            vc.vcCome = .CompletedRequest
            vc.goBackDelegate = self
        }
        if vcCard == .withoutCard{
            vc.vcCard = .withoutCard
        }
        vc.modalPresentationStyle = .overFullScreen
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.fade
        transition.subtype = CATransitionSubtype.fromTop
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func makePaymentBtnAction(_ sender: UIButton) {
        print(kCardId)
        vcCard = .withCard

        if kCardId != ""{

            if screen == "tip"{
                self.TIPApi(rideId: completedRideId, amount: completedAmount, card_id: kCardId)
            }else{
                if completedStatus == true {
                    print("Completed from Home PopUp")
                    if completedStatus && completedFromPaynowStatus  == true {
                        self.payApi(rideId: completedRideId, amount: completedAmount, card_id: kCardId)
                    }
                    else{
                        self.payApi(rideId: lastRideData?.ride_id ?? "", amount: lastRideData?.amount ?? "", card_id: kCardId)
                    }
                }
                else{
                    print("Completed from list")
                    self.payApi(rideId: ridesStatusData?.rideID ?? "", amount: ridesStatusData?.amount ?? "", card_id: kCardId)
                }
            }
            
            
           
        }
        else{
            print("Please Select the Card")
        }
    }
}
extension PaymentVC : goBackProtocal{
    func backButtonAction(selectedStatus: Bool) {
        if selectedStatus == true {
            self.savedCardApi()
        }
    }
}
