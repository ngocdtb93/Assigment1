//
//  TableViewCell.swift
//  AssigmentWeek1
//
//  Created by Ngoc Do on 3/12/16.
//  Copyright © 2016 com.appable. All rights reserved.
//

import UIKit
import Spring

class TableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var filmImage: SpringImageView!
    @IBOutlet weak var lblContent: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
