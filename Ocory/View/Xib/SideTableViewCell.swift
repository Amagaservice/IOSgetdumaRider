//
//  SideTableViewCell.swift
//  Ocory
//
//  Created by Arun Singh on 05/03/21.
//

import UIKit

class SideTableViewCell: UITableViewCell {

    //MARK:- OUTLETS
    
    @IBOutlet weak var side_icon: UIImageView!
    @IBOutlet weak var sideName_lbl: UILabel!
    
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
