//
//  General.swift
//  GPA Calculator
//
//  Created by Adwait Barkale on 25/11/20.
//  Copyright © 2020 Adwait Barkale. All rights reserved.
//

import Foundation
import UIKit

//MARK:- UIViewController + Extension
extension UIViewController{
    
    func hideKeyboardOnTap()
    {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}

//MARK:- Grade

struct GradePoints {
    static var A = 4.00
    static var B = 3.00
    static var C = 2.00
    static var D = 1.00
}

struct GradeIndicator {
    static var A = "A"
    static var B = "B"
    static var C = "C"
    static var D = "D"
}
