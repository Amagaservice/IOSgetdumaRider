//
//  helpVC.swift
//  Ocory
//
//  Created by malika saini on 01/09/22.
//

import UIKit

class helpVC: UIViewController {

    @IBOutlet weak var mHelpTV: UITableView!
    let conn = webservices()
    var completedRidesData = [RidesData]()

    override func viewDidLoad() {
        super.viewDidLoad()
        complettedRidesDetailsApi()
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "green")
        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.5058823529, green: 0.7411764706, blue: 0.09803921569, alpha: 1)
      
        self.setNavButton()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            NavigationManager.pushToLoginVC(from: self)
        }
        
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = "Help"
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = true
    }
    //MARK:- Navbar set
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
    //MARK:- Nap bar tab
    @objc func tapNavButton(){
        
        let presentedVC = self.storyboard!.instantiateViewController(withIdentifier: "SideMenuViewController")
        let nvc = UINavigationController(rootViewController: presentedVC)
        present(nvc, animated: false, pushing: true, completion: nil)
    }
}

//MARK:- Table View Datasource

extension helpVC: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.completedRidesData.count ) == 0 {
            tableView.setEmptyMessage("No Data Found")
        } else {
            tableView.removeErrorMessage()
        }
        return self.completedRidesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.mHelpTV.dequeueReusableCell(withIdentifier: "helpTableViewCellID") as! helpTableViewCell
       
        cell.mLabel.text = completedRidesData[indexPath.row].question
        
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(identifier: "helpDetailVCID") as! helpDetailVC
        vc.HelpTitle = completedRidesData[indexPath.row].question!
        vc.question_id = completedRidesData[indexPath.row].id!
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension helpVC{
    //MARK:- Completted Rides Detail's Api
    func complettedRidesDetailsApi(){
        
       // let url = "get_question_answer?question_category_id=7"
        let url = "get_question_answer?question_category_id=7"
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
                        self.mHelpTV.reloadData()
                    }catch{
                        
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}
