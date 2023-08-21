//
//  RideCompletedCell.swift
//  Ocory
//
//  Created by nile on 08/07/21.
//

import UIKit

class RideCompletedCell: UITableViewCell {
    @IBOutlet weak var rateView: StarRateView!
    @IBOutlet weak var commentTF: UITextField!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var imageViw: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mNoThanks: SetButton!
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
