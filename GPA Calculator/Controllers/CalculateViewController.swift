//
//  CalculateViewController.swift
//  GPA Calculator
//
//  Created by Adwait Barkale on 25/11/20.
//  Copyright © 2020 Adwait Barkale. All rights reserved.
//

import UIKit

class CalculateViewController: UIViewController {
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    let db = DBHelper()
    
    var avgType: Int = 0
    var modelList:[Grade] = []
    var isGrade: Bool = false
    var indexPath: IndexPath?
    var id: Int = -1
    var name: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "New Stork"
        tableView.delegate = self
        tableView.dataSource = self
        //tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        self.hideKeyboardOnTap()
        configureTableView(status: false)
        
        //Handle Keyboard during Scroll show calculate button also
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        if id != -1{
            txtName.text = self.name
        }
    }
    
    var isScrolled = false
    
    @objc func KeyboardWillShow()
    {
        if !isScrolled{
            self.tableView.contentSize = CGSize(width: 0, height: tableView.contentSize.height + 300)
            self.isScrolled = true
        }
    }
    
    @objc func KeyboardWillHide()
    {
        self.tableView.contentSize = CGSize(width: 0, height: tableView.contentSize.height - 300)
        self.isScrolled = false
    }
    
    func configureTableView(status: Bool)
    {
        if modelList.isEmpty{
            let model = Grade()
            model.id = "\(modelList.count + 1)"
            model.name = ""
            modelList.append(model)
            
        }
        
        tableView.reloadData()

    }
    
    func calculateResult()
    {
        let totalRows = tableView.numberOfRows(inSection: 0)
        var sumOfHours = 0.0
        var sumOfPoints = 0.0
        
        for row in 0..<totalRows{
            guard let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? CalculationCell else { return }
            
            if cell.reuseIdentifier != nil && cell.reuseIdentifier == "cell"
            {
                if modelList[row].hour != nil{
                    sumOfHours = sumOfHours + Double(modelList[row].hour!)!
                }
                sumOfPoints = sumOfPoints + Double(modelList[row].points)
            }
        }
        
        let gpa = sumOfPoints/sumOfHours
        print("GPA = \(gpa)")
        let result = "GPA Result = \(gpa)"
        //print("txtName = \(txtName.text!)")
        
//        guard let name = txtName.text else {
//            let alert = UIAlertController(title: "Enter Name", message: "Please Enter Name", preferredStyle: .alert)
//            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//            alert.addAction(okAction)
//            self.present(alert,animated: true,completion: nil)
//            return
//        }
//
        if id == -1{
            //New Record
            self.db.insertData(name: txtName.text!, result: result, avg: self.avgType, list: modelList)
        }else{
            //Update
            self.db.updateData(id: self.id, name: txtName.text!, result: result, avg: self.avgType, list: modelList)
        }
    }
    
    
}

extension CalculateViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelList.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == modelList.count
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "footer") as! CalculationCell
            cell.tapForCalculate = {
                self.validateData()
                self.calculateResult()
            }
            cell.setFooter()
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CalculationCell
            print("Cell IndexPath.row = \(indexPath.row)")
            print("ModelList.count = \(modelList.count)")
            if indexPath.row == modelList.count - 1{
                cell.btnPlus.isHidden = false
            }else{
                cell.btnPlus.isHidden = true
            }
            cell.setData(model: modelList[indexPath.row])
            cell.tapForPlus = {
                self.configureTableView(status: true)
            }
            
            cell.tapForHour = {
                self.modelList[indexPath.row].name = cell.txtName.text!
                self.indexPath = indexPath
                self.isGrade = false
                guard let valuesVC = self.storyboard?.instantiateViewController(withIdentifier: "ValuesViewController") as? ValuesViewController else{ return }
                if self.modelList[indexPath.row].hour != nil{
                    valuesVC.selectedString = self.modelList[indexPath.row].hour
                }
                valuesVC.isGrade = false
                valuesVC.delegate = self
                self.navigationController?.pushViewController(valuesVC, animated: true)
            }
            
            cell.tapForGrade = {
                self.modelList[indexPath.row].name = cell.txtName.text!
                self.indexPath = indexPath
                self.isGrade = true
                guard let valuesVC = self.storyboard?.instantiateViewController(withIdentifier: "ValuesViewController") as? ValuesViewController else{ return }
                if self.modelList[indexPath.row].grade != nil{
                    valuesVC.selectedString = self.modelList[indexPath.row].grade
                }
                valuesVC.isGrade = true
                valuesVC.delegate = self
                self.navigationController?.pushViewController(valuesVC, animated: true)
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func validateData()
    {
        
    }
    
}


extension CalculateViewController: ValueSelectionDelegate{
    
    func callBack(str: String, points: Float) {
        print("points Received - \(points)")
        if self.isGrade{
            self.modelList[indexPath!.row].grade = str
            self.modelList[indexPath!.row].points = points
        }else{
            self.modelList[indexPath!.row].hour = str
        }
        tableView.reloadRows(at: [self.indexPath!], with: .none)
    }
}
