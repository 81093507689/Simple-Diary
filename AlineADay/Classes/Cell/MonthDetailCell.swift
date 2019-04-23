//
//  MonthDetailCell.swift
//  AlineADay
//
//  Created by developer on 29/03/19.
//  Copyright © 2019 AlineADay. All rights reserved.
//

import UIKit

class MonthDetailCell: UITableViewCell {

    @IBOutlet weak var lbl_Day: UILabel!
    @IBOutlet weak var lbl_Month: UILabel!
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var btnEdit: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
