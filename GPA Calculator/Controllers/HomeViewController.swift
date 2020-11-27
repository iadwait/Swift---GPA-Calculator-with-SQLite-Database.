//
//  HomeViewController.swift
//  GPA Calculator
//
//  Created by Adwait Barkale on 25/11/20.
//  Copyright © 2020 Adwait Barkale. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    //    @IBAction func btnSettingsTapped(_ sender: UIBarButtonItem) {
    //        let settingsVC = storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
    //        navigationController?.pushViewController(settingsVC, animated: true)
    //    }
    
    
    @IBAction func btnAvg4Tapped(_ sender: UIButton) {
        let avgVC = storyboard?.instantiateViewController(withIdentifier: "AvgViewController") as! AvgViewController
        avgVC.avgType = 4
        navigationController?.pushViewController(avgVC, animated: true)
    }
    
    @IBAction func btnAvg5Tapped(_ sender: UIButton) {
        let avgVC = storyboard?.instantiateViewController(withIdentifier: "AvgViewController") as! AvgViewController
        avgVC.avgType = 5
        navigationController?.pushViewController(avgVC, animated: true)
    }
    
    @IBAction func btnAvg100Tapped(_ sender: UIButton) {
        let avgVC = storyboard?.instantiateViewController(withIdentifier: "AvgViewController") as! AvgViewController
        avgVC.avgType = 100
        navigationController?.pushViewController(avgVC, animated: true)
    }
    
    
}
