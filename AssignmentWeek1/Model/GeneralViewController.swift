//
//  generalFunction.swift
//  AlphaPlus
//
//  Created by Ngoc Do on 12/16/15.
//  Copyright © 2015 Sunny Jade. All rights reserved.
//

import UIKit

class GeneralViewController: UIViewController {
    
    @IBOutlet weak var bottomContraint: NSLayoutConstraint!
    
    //keyboard
    func keyboardFunction(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWasShowed:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWasHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    //MARK: -keyboard
    
    func keyboardWasShowed(notification:NSNotification){
        let info:NSDictionary = notification.userInfo!
        let keyboardFrame:CGRect = (info["UIKeyboardFrameBeginUserInfoKey"] as! NSValue).CGRectValue()
        
            bottomContraint.constant = keyboardFrame.size.height
        
        
    }
    func keyboardWasHide(notification:NSNotification){
        
        bottomContraint.constant = 0
    }
    
    //MARK: -navigation function

    
    }
