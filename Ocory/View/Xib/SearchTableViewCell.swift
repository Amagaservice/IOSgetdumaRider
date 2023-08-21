//
//  SearchTableViewCell.swift
//  Ocory
//
//  Created by Arun Singh on 04/03/21.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    //MARK:- OUTLETS
    
    @IBOutlet weak var locationName_lbl: UILabel!
    @IBOutlet weak var countryName_lbl: UILabel!
    
    
    
    //MARK:- Default Func
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    //MARK:- Default Func
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
