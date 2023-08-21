//
//  PendingViewController.swift
//  Ocory
//
//  Created by nile on 03/09/21.
//

import UIKit

class PendingViewController: UIViewController {
    @IBOutlet weak var pendingReq_tableView: UITableView!
    //MARK:- Variables
    let conn = webservices()
    var acceptedReqData = [RidesData]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor.red
        self.registerCell()
        self.setNavButton()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            NavigationManager.pushToLoginVC(from: self)
        }
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = "Pending Rides"
        self.pendingRidesDetailsApi()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    //MARK:- User Defined Func
    
    func registerCell(){
        
        let acceptNib = UINib(nibName: "PendingRideNewTableViewCell", bundle: nil)
        self.pendingReq_tableView.register(acceptNib, forCellReuseIdentifier: "PendingRideNewTableViewCell")
    }
    
    func setNavButton(){
        
        let logoBtn = UIButton(type: .custom)
        logoBtn.setImage(UIImage(named: "shape_28"), for: .normal)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
       // self.navigationController?.navigationBar.barTintColor = UIColor.red
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
//MARK:- Table View
extension PendingViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.acceptedReqData.count ) == 0 {
            tableView.setEmptyMessage("No Data Found")
        } else {
            tableView.removeErrorMessage()
        }
        return self.acceptedReqData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.pendingReq_tableView.dequeueReusableCell(withIdentifier: "PendingRideNewTableViewCell") as! PendingRideNewTableViewCell
        cell.pickUpLocation_lbl.text = self.acceptedReqData[indexPath.row].pickupAdress ?? ""
        cell.dropLocation_lbl.text = self.acceptedReqData[indexPath.row].dropAddress ?? ""
        cell.driverName_lbl.text = self.acceptedReqData[indexPath.row].driverName ?? ""
        cell.date_lbl.text = self.getStringFormat(date: self.acceptedReqData[indexPath.row].time ?? "")
        cell.time_lbl.text = self.getStringTimeFormat(date: self.acceptedReqData[indexPath.row].time ?? "")
       
        return cell
    }
   
    
}
//MARK:- Table View Delegate

extension PendingViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(identifier: "RideDetailsViewController") as! RideDetailsViewController
        vc.ridesStatusData = self.acceptedReqData[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


//MARK:- Web Api
extension PendingViewController{
    
    //MARK:- Pending Rides Api
    func pendingRidesDetailsApi(){
        
        let url = "rides?status=PENDING"
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
                        self.acceptedReqData = try newJSONDecoder().decode(rides.self, from: jsonData)
                        print(self.acceptedReqData)
                        self.pendingReq_tableView.reloadData()
                    }catch{
                        
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}
