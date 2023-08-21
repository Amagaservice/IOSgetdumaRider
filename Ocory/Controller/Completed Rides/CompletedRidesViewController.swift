//
//  CompletedRidesViewController.swift
//  Ocory
//
//  Created by Arun Singh on 23/02/21.
//

import UIKit

class CompletedRidesViewController: UIViewController {
    
    //MARK:- OUTLETS
    
    @IBOutlet weak var completedRides_tableView: UITableView!
    
    
    //MARK:- Variables
    
    let conn = webservices()
    var completedRidesData = [RidesData]()
    var vcCome = comeFrom.CompletedRequest
    //MARK:- Default Func
    override func viewDidLoad() {
        super.viewDidLoad()
        self.completedRides_tableView.dataSource = self
        self.completedRides_tableView.delegate = self
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "green")
        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.5058823529, green: 0.7411764706, blue: 0.09803921569, alpha: 1)
        self.registerCell()
        self.setNavButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            NavigationManager.pushToLoginVC(from: self)
        }
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = "Completed Rides"
        self.complettedRidesDetailsApi()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    //MARK:- User Defined Func
    
    func registerCell(){
        
        let compNib = UINib(nibName: "CompletedTableViewCell", bundle: nil)
        self.completedRides_tableView.register(compNib, forCellReuseIdentifier: "CompletedTableViewCell")
        let compPayNib = UINib(nibName: "CompletedPaymentTableViewCell", bundle: nil)
        self.completedRides_tableView.register(compPayNib, forCellReuseIdentifier: "CompletedPaymentTableViewCell")
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

    
}
//MARK:- Table View Datasource

extension CompletedRidesViewController: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.completedRidesData.count ) == 0 {
            tableView.setEmptyMessage("No Data Found")
        } else {
            tableView.removeErrorMessage()
        }
        return self.completedRidesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let paymentStatus = self.completedRidesData[indexPath.row].paymentStatus ?? ""
        if paymentStatus == "COMPLETED"{
          //  cell.payBtn.isHidden = true
            let cell = self.completedRides_tableView.dequeueReusableCell(withIdentifier: "CompletedTableViewCell") as! CompletedTableViewCell
            cell.pickUpLocation_lbl.text = self.completedRidesData[indexPath.row].pickupAdress ?? ""
            cell.dropLocation_lbl.text = self.completedRidesData[indexPath.row].dropAddress ?? ""
            cell.driverName_lbl.text = self.completedRidesData[indexPath.row].driverName ?? ""
            cell.date_lbl.text = self.getStringFormat(date: self.completedRidesData[indexPath.row].time ?? "")
            cell.time_lbl.text = self.getStringTimeFormat(date: self.completedRidesData[indexPath.row].time ?? "")
         //   cell.viewBtnDetail.tag = indexPath.row
            //cell.payBtn.tag = indexPath.row
         //   cell.viewBtnDetail.addTarget(self, action: #selector(viewDetailBtnAvtion), for: .touchUpInside)
         //   cell.payBtn.addTarget(self, action: #selector(payBtnAvtion), for: .touchUpInside)
           
            return cell
        }
        else{
          //  cell.payBtn.isHidden = false
            let cell = self.completedRides_tableView.dequeueReusableCell(withIdentifier: "CompletedPaymentTableViewCell") as! CompletedPaymentTableViewCell
            cell.pickUpLocation_lbl.text = self.completedRidesData[indexPath.row].pickupAdress ?? ""
            cell.dropLocation_lbl.text = self.completedRidesData[indexPath.row].dropAddress ?? ""
            cell.driverName_lbl.text = self.completedRidesData[indexPath.row].driverName ?? ""
            cell.date_lbl.text = self.getStringFormat(date: self.completedRidesData[indexPath.row].time ?? "")
            cell.time_lbl.text = self.getStringTimeFormat(date: self.completedRidesData[indexPath.row].time ?? "")
         //   cell.viewBtnDetail.tag = indexPath.row
            cell.payBtn.tag = indexPath.row
         //   cell.viewBtnDetail.addTarget(self, action: #selector(viewDetailBtnAvtion), for: .touchUpInside)
            cell.payBtn.addTarget(self, action: #selector(payBtnAvtion), for: .touchUpInside)
           
            return cell
        }
        
       
    }
    @objc func viewDetailBtnAvtion(sender : UIButton){
        let vc = self.storyboard?.instantiateViewController(identifier: "RideDetailsViewController") as! RideDetailsViewController
        vc.ridesStatusData = self.completedRidesData[sender.tag]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func payBtnAvtion(sender : UIButton){
        let vc = self.storyboard?.instantiateViewController(identifier: "PaymentVC") as! PaymentVC
        vc.ridesStatusData = self.completedRidesData[sender.tag]
        vc.vcCome = comeFrom.CompletedRequest
        self.navigationController?.pushViewController(vc, animated: true)
    }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let vc = self.storyboard?.instantiateViewController(identifier: "RideDetailsViewController") as! RideDetailsViewController
            vc.ridesStatusData = self.completedRidesData[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
}
//MARK:- Table View Datasource
//MARK:- Web Api
extension CompletedRidesViewController{
    // MARK:- Completted Rides Api
    func complettedRidesDetailsApi(){
        
        let url = "rides?status=COMPLETED"
        Indicator.shared.showProgressView(self.view)
        
        self.conn.startConnectionWithGetTypeWithParam(getUrlString: url,authRequired: true) { (value) in
            
            print(value)
            Indicator.shared.hideProgressView()
            if self.conn.responseCode == 1{
                
                if (value["status"] as? Int ?? 0) == 1{
                    
                    print(value)
                    let data = (value["data"] as? [[String:AnyObject]] ?? [[:]])
                    do{
                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                        self.completedRidesData = try newJSONDecoder().decode(rides.self, from: jsonData)
                        print(self.completedRidesData)
                        self.completedRides_tableView.reloadData()
                    }catch{
                        
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}
