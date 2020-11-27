//
//  AvgViewController.swift
//  GPA Calculator
//
//  Created by Adwait Barkale on 25/11/20.
//  Copyright © 2020 Adwait Barkale. All rights reserved.
//

import UIKit

class AvgViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var avgType:Int = 0
    var list = [dbGrade]()
    let db = DBHelper()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var btnNewStork: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        if avgType == 4{
            navigationItem.title = "Average 4"
        }else if avgType == 5{
            navigationItem.title = "Average 5"
        }else if avgType == 100{
            navigationItem.title = "Average 100"
        }
        
        configureNavBarIcon()
        
        btnNewStork.addTarget(self, action: #selector(btnNewStorkTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
      configureTable()
        
    }
    
    func configureTable()
    {
        
        self.tableView.tableFooterView = UIView()
        list = db.readData(avgType: self.avgType)
        tableView.reloadData()
    }
    
    func configureNavBarIcon()
    {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(handleSettings))
    }
    
    @objc func handleSettings()
    {
        let settingsVC = storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        self.navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    @objc func btnNewStorkTapped()
    {
        let calculateVC = storyboard?.instantiateViewController(withIdentifier: "CalculateViewController") as! CalculateViewController
        calculateVC.avgType = self.avgType
        navigationController?.pushViewController(calculateVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = list[indexPath.row].name
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let calculateVC = storyboard?.instantiateViewController(withIdentifier: "CalculateViewController") as! CalculateViewController
        calculateVC.avgType = self.avgType
        calculateVC.modelList = list[indexPath.row].list!
        calculateVC.id = list[indexPath.row].id
        calculateVC.name = list[indexPath.row].name!
        navigationController?.pushViewController(calculateVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            self.db.deleteData(id: list[indexPath.row].id)
            list.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}


