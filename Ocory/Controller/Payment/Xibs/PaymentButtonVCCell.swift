//
//  PaymentButtonVCCell.swift
//  Ocory
//
//  Created by nile on 28/09/21.
//

import UIKit

class PaymentButtonVCCell: UITableViewCell {
    @IBOutlet weak var stackHeight: NSLayoutConstraint!
    @IBOutlet weak var paymentBtn: UIButton!
    @IBOutlet weak var addCardBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
