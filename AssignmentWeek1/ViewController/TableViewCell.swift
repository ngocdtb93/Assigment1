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

//    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblTitle: SpringLabel!
    @IBOutlet weak var filmImage: SpringImageView!
    @IBOutlet weak var lblContent: UILabel!
    override func awakeFromNib() {
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        //set background if selected
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(red: 237.0/255, green: 85.0/255, blue: 8/255, alpha: 1.0)
        self.selectedBackgroundView = bgColorView
    }
    

}
