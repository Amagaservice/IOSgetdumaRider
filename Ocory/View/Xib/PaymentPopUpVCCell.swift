//
//  PaymentPopUpVCCell.swift
//  Ocory
//
//  Created by nile on 28/09/21.
//

import UIKit

class PaymentPopUpVCCell: UITableViewCell {

    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var mTotalLBL: UILabel!
    
    @IBOutlet weak var mCancellationLBL: UILabel!
    @IBOutlet weak var PayNowBtn: UIButton!
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
