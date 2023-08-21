//
//  CompletedTableViewCell.swift
//  Ocory
//
//  Created by Arun Singh on 23/02/21.
//

import UIKit

class CompletedTableViewCell: UITableViewCell {

    //MARK:- OUTLETS
    
    @IBOutlet weak var pickUpLocation_lbl: UILabel!
    @IBOutlet weak var dropLocation_lbl: UILabel!
    @IBOutlet weak var time_lbl: UILabel!
    @IBOutlet weak var date_lbl: UILabel!
    @IBOutlet weak var driverName_lbl: UILabel!
    
    @IBOutlet weak var viewBtnDetail: UIButton!
    @IBOutlet weak var payBtn: UIButton!
    
    
    //MARK:- Default Func
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    //MARK:- Default Func
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
