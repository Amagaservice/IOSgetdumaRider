//
//  SearchLocationViewController.swift
//  Ocory
//
//  Created by Arun Singh on 04/03/21.
//

import UIKit
import GooglePlaces
import GoogleMaps

class SearchLocationViewController: UIViewController {
    
    //MARK:- OUTLETS
    
    @IBOutlet weak var location_tableView: UITableView!
    //MARK:- Variables
    
    let searchController = UISearchController(searchResultsController: nil)
    
    //MARK:- Default Func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.topItem?.title = ""
        self.location_tableView.dataSource = self
        self.location_tableView.delegate = self
        self.registerCell()
    }
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            NavigationManager.pushToLoginVC(from: self)
        }
        self.setSearchBar()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.view.setNeedsLayout()
        self.navigationController?.view.layoutIfNeeded()
    }
    
    //MARK:- User Defined Func
    func setSearchBar(){
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
    }
    func registerCell(){
        let searchNib = UINib(nibName: "SearchTableViewCell", bundle: nil)
        self.location_tableView.register(searchNib, forCellReuseIdentifier: "SearchTableViewCell")
    }
}
//MARK:- Table View Datasource
extension SearchLocationViewController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.location_tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell") as! SearchTableViewCell
        
        return cell
    }
    
}

//MARK:- Table View Delegate
extension SearchLocationViewController:UITableViewDelegate{
    
    
}

