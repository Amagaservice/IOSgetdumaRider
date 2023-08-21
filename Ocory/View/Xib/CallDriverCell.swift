//
//  CallDriverCell.swift
//  Ocory
//
//  Created by nile on 08/07/21.
//

import UIKit

class CallDriverCell: UITableViewCell {

    @IBOutlet weak var mPopupMinMaxPopup: UIButton!
    @IBOutlet weak var vehicleImageView: UIImageView!
    @IBOutlet weak var driverImageView: UIImageView!

    @IBOutlet weak var mPopupVieww: UIView!
    @IBOutlet weak var mViewHeight: NSLayoutConstraint!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var driverNameLabel: UILabel!
    @IBOutlet weak var driverRatingLabel: UILabel!
    @IBOutlet weak var callDriverBtn: UIButton!
    @IBOutlet weak var cancelDriverBtn: UIButton!

    @IBOutlet weak var mUserNAme: UILabel!
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
