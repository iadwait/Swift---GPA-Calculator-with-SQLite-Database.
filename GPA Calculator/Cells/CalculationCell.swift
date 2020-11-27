//
//  CalculationCell.swift
//  GPA Calculator
//
//  Created by Adwait Barkale on 25/11/20.
//  Copyright © 2020 Adwait Barkale. All rights reserved.
//

import UIKit

class CalculationCell: UITableViewCell {
    
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var btnHour: UIButton!
    @IBOutlet weak var btnGrade: UIButton!
    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var btnCalculate: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    var tapForHour: (() -> Void)? = nil
    var tapForGrade: (() -> Void)? = nil
    var tapForPlus: (() -> Void)? = nil
    var tapForCalculate: (() -> Void)? = nil
    
    func setData(model: Grade)
    {
        txtName.text = model.name
        
        if model.hour == nil{
            btnHour.setTitle("Hour", for: .normal)
        }else{
            btnHour.setTitle("\(model.hour!) - Hour", for: .normal)
        }
        
        if model.grade == nil{
            btnGrade.setTitle("Grade", for: .normal)
        }else{
            btnGrade.setTitle("\(model.grade!) - Grade", for: .normal)
        }
        
        btnHour.addTarget(self, action: #selector(btnHourTapped), for: .touchUpInside)
        btnGrade.addTarget(self, action: #selector(btnGradeTapped), for: .touchUpInside)
        btnPlus.addTarget(self, action: #selector(btnPlusTapped), for: .touchUpInside)
    }
    
    func setFooter()
    {
        btnCalculate.addTarget(self, action: #selector(btnCalculateTapped), for: .touchUpInside)
    }
    
    @objc func btnHourTapped()
    {
        if let tap = tapForHour{
            tap()
        }
    }
    
    @objc func btnGradeTapped()
    {
        if let tap = tapForGrade{
            tap()
        }
    }
    
    @objc func btnPlusTapped()
    {
        if let tap = tapForPlus{
            tap()
        }
    }
    
    @objc func btnCalculateTapped()
    {
        if let tap = tapForCalculate{
            tap()
        }
    }
    
    
    
}
