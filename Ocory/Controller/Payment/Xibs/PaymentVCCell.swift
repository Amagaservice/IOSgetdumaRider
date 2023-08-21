//
//  PaymentVCCell.swift
//  Ocory
//
//  Created by nile on 20/09/21.
//

import UIKit

class PaymentVCCell: UITableViewCell {

    @IBOutlet weak var numberLbl: UILabel!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var expiryLbl: UILabel!
    @IBOutlet weak var defaultBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
    var callBackDropDown : ((IndexPath) -> Void)?
    var callCheckBox : ((IndexPath) -> Void)?
    var index = IndexPath()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func actionDropDown(_ sender: Any) {
          callBackDropDown?(self.index)
      }
    @IBAction func checkBoxBtnAction(_ sender: Any) {
        callCheckBox?(self.index)
      }
    func configure(indexPath:IndexPath){
          self.index = indexPath
      }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
