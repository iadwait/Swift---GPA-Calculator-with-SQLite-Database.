//
//  Models.swift
//  GPA Calculator
//
//  Created by Adwait Barkale on 25/11/20.
//  Copyright © 2020 Adwait Barkale. All rights reserved.
//

import Foundation

class Grade: Codable{
    
    var id: String?
    var name: String?
    var checked: Bool = false
    var hour: String?
    var grade: String?
    var points: Float = 0.0
    
}

class dbGrade: Codable{
    
    var id: Int = 1
    var name: String?
    var result: String?
    var avgType: Int = 4
    var list: [Grade]?
    
}

