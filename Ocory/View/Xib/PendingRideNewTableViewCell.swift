//
//  PendingRideNewTableViewCell.swift
//  Ocory
//
//  Created by nile on 13/06/22.
//

import UIKit

class PendingRideNewTableViewCell: UITableViewCell {
    //MARK:- OUTLETS
    
    @IBOutlet weak var pickUpLocation_lbl: UILabel!
    @IBOutlet weak var dropLocation_lbl: UILabel!
    @IBOutlet weak var time_lbl: UILabel!
    @IBOutlet weak var date_lbl: UILabel!
    @IBOutlet weak var driverName_lbl: UILabel!
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
