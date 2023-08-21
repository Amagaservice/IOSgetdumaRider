//
//  MySpentVC.swift
//  Ocory
//
//  Created by nile on 27/07/22.
//

import UIKit
import Foundation
import Alamofire
import GoogleMaps
import GooglePlaces
import CoreLocation


class MySpentVC: UIViewController, GMSMapViewDelegate {
    @IBOutlet weak var mySpent_tableView: UITableView!
    @IBOutlet weak var mySpent_lbl: UILabel!
    let conn = webservices()
    var isDataLoading:Bool=false
    var pageNo:Int=0
    var limit:Int=10
    var offset:Int=0 //pageNo*limit
    var didEndReached:Bool=false
    let spinner = UIActivityIndicatorView(style: .gray)
    var completedRidesData = [RidesData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "green")
        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.5058823529, green: 0.7411764706, blue: 0.09803921569, alpha: 1)
       self.registerCell()
        self.mySpent_lbl.text = "Total Spend"
        self.setNavButton()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func calendarBtnAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DateRangeVC") as! DateRangeVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.dateRangeVCDelegate  = self
        present(vc, animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            NavigationManager.pushToLoginVC(from: self)
        }
        self.myspentDetailApi(from: "", to: "", pageNo: "\(pageNo)", perPage: "\(limit)")

        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = "Spend Details"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = true
        
    }
    func registerCell(){
        
        let acceptNib = UINib(nibName: "MySpendCell", bundle: nil)
        self.mySpent_tableView.register(acceptNib, forCellReuseIdentifier: "MySpendCell")
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
    @objc func filterBtnAction(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DateRangeVC") as! DateRangeVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        //vc.dateRangeVCDelegate  = self
        present(vc, animated: true, completion: nil)
        
    }
}

extension MySpentVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.completedRidesData.count ) == 0 {
            tableView.setEmptyMessage("No Data Found")
        } else {
            tableView.removeErrorMessage()
        }
        return self.completedRidesData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.mySpent_tableView.dequeueReusableCell(withIdentifier: "MySpendCell") as! MySpendCell
        cell.pickUpLocation_lbl.text = self.completedRidesData[indexPath.row].pickupAdress ?? ""
        cell.dropLocation_lbl.text = self.completedRidesData[indexPath.row].dropAddress ?? ""
        cell.amount_lbl.text =
        "$ " + (self.completedRidesData[indexPath.row].amount ?? "")
        
        cell.distance_lbl.text = (self.completedRidesData[indexPath.row].distance ?? "") +  "miles"
        cell.date_lbl.text = self.getStringFormat(date: self.completedRidesData[indexPath.row].time ?? "")
        cell.time_lbl.text = self.getStringTimeFormat(date: self.completedRidesData[indexPath.row].time ?? "")
        
            
        let  picklat = self.completedRidesData[indexPath.row].pickupLat ?? ""
        let  picklong = self.completedRidesData[indexPath.row].pickupLong ?? ""
            let lattitude : Double = Double("\(picklat)")!
            let longi : Double = Double("\(picklong)")!

            let camera = GMSCameraPosition.camera(withLatitude:lattitude, longitude:longi, zoom: 5.0)
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: lattitude, longitude: longi)
        cell.mapView.delegate = self
           
            marker.isDraggable = true
        marker.map = cell.mapView
        cell.reverseGeocoding(marker: marker, lat: "\(lattitude)", long: "\(longi)", pickupLat: picklat, pickupLong: picklong)
        cell.mapView.animate(to: camera)
        
//            self.reverseGeocoding(marker: marker)
//            self.mapView.animate(to: camera)
        
        
    
        return cell
    }
    
}


//MARK:- Web Api
extension MySpentVC{
    
    func myspentDetailApi(from:String , to:String,pageNo :String ,perPage:String){
        
        let url = "rides?status=COMPLETED"
        Indicator.shared.showProgressView(self.view)
        
        self.conn.startConnectionWithGetTypeWithParam(getUrlString: url,authRequired: true) { (value) in
            
            print(value)
            Indicator.shared.hideProgressView()
            if self.conn.responseCode == 1{
                
                if (value["status"] as? Int ?? 0) == 1{
                    self.mySpent_lbl.text =  "Spend Amount : $ " + "\( value["total_earning"] as? String ?? "")"
                    print(value)
                    let data = (value["data"] as? [[String:AnyObject]] ?? [[:]])
                    do{
                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                        self.completedRidesData = try newJSONDecoder().decode(rides.self, from: jsonData)
                        print(self.completedRidesData)
                       self.mySpent_tableView.reloadData()
                    }catch{
                        
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}


extension MySpentVC: dateRangeVCProtocal{
    func backRangeDateSelectedDate(fromDate: String, toDate: String, selectedStatus: String) {
        print("fromDateFinal\(fromDate)+++++++toDateFinal\(toDate)")
        if fromDate != "" && toDate != "" {
            self.myspentDetailApi(from: fromDate, to: toDate, pageNo: "\(pageNo)", perPage: "10")
            //self.paymentHistoryList.reloadData()
        }
    }
}


extension URLComponents {
    
    mutating func setQueryItems(with parameters: [String: String]) {
        self.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}


