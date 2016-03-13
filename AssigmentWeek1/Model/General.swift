//
//  General.swift
//  AssigmentWeek1
//
//  Created by Ngoc Do on 3/12/16.
//  Copyright © 2016 com.appable. All rights reserved.
//

import Foundation
import UIKit
class General: AnyObject {
    class func heightForLabel(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text as String
        label.sizeToFit()
        //println(label.frame.height)
        return label.frame.height
        
    }
}
