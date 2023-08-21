//
//  DriverConfirmationCell.swift
//  Ocory
//
//  Created by nile on 08/07/21.
//

import UIKit

class DriverConfirmationCell: UITableViewCell {

    @IBOutlet weak var waitingBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var modalLbl: UILabel!
    @IBOutlet weak var numberLbl: UILabel!
    @IBOutlet weak var imageVw: UIImageView!
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
