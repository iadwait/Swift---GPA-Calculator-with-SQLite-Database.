//
//  ValuesViewController.swift
//  GPA Calculator
//
//  Created by Adwait Barkale on 26/11/20.
//  Copyright © 2020 Adwait Barkale. All rights reserved.
//

import UIKit

class ValuesViewController: UITableViewController {
    
    var isGrade: Bool = false
    var list : [Grade] = []
    var selectedString: String?
    var delegate: ValueSelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        configureValue()
    }
    
    func configureValue()
    {
        list.removeAll()
        if isGrade{
            self.navigationItem.title = "Select Grade"
            for i in 0...3{
                let model = Grade()
                model.id = "\(i)"
                if i == 0{
                    model.name = GradeIndicator.A
                    model.points = Float(GradePoints.A)
                }else if i == 1{
                    model.name = GradeIndicator.B
                    model.points = Float(GradePoints.B)
                }
                else if i == 2{
                    model.name = GradeIndicator.C
                    model.points = Float(GradePoints.C)
                }
                else if i == 3{
                    model.name = GradeIndicator.D
                    model.points = Float(GradePoints.D)
                }
                list.append(model)
                if selectedString != nil && model.name == selectedString{
                    model.checked = true
                }
            }
        }else{
            //Hour
            self.navigationItem.title = "Select Hour"
            for i in 0...4{
                let model = Grade()
                model.id = "\(i)"
                model.name = "\(i)"
                list.append(model)
                if selectedString != nil && model.name == selectedString{
                    model.checked = true
                }
            }
        }
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return list.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "valueSelectionCell", for: indexPath) as! valueSelectionCell
        cell.textLabel?.text = list[indexPath.row].name
        if list[indexPath.row].checked == true{
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        //self.selectedString = list[indexPath.row].name
        delegate?.callBack(str: list[indexPath.row].name!,points: list[indexPath.row].points)
        self.navigationController?.popViewController(animated: true)
    }
    
}
