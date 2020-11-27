//
//  DBHelper.swift
//  GPA Calculator
//
//  Created by Adwait Barkale on 26/11/20.
//  Copyright © 2020 Adwait Barkale. All rights reserved.
//

import Foundation
import SQLite3

//Operations
/*
 1.Create DB
 2.Create Table / Check for existing table
 3.Insert
 4.Update
 5.Delete
 */

class DBHelper{
    
    var db: OpaquePointer?
    var path: String = "gpaDB.sqlite"
    
    init() {
        self.db = createDB()
        createTable()
    }
    
    func createDB() -> OpaquePointer?
    {
        let filePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(path)
        
        var db: OpaquePointer? = nil
        
        if sqlite3_open(filePath.path, &db) != SQLITE_OK{
            print("There is Error in creating DB")
            return nil
        } else{
            print("Database Created with Path = \(path)")
            print("Database Created with Path = \(filePath)")
            return db
        }
    }
    
    func createTable()
    {
        let query = "CREATE TABLE IF NOT EXISTS grade(id Integer PRIMARY KEY AUTOINCREMENT,name TEXT,result TEXT,avg INTEGER,list TEXT);"
        var createTable: OpaquePointer? = nil
        //Prepare Expression with help of query
        if sqlite3_prepare_v2(self.db, query, -1, &createTable, nil) == SQLITE_OK {
            //End Action on Create Table
            if sqlite3_step(createTable) == SQLITE_DONE{
                print("Table Creation Success")
            }else{
                print("Table Creation Fail")
            }
        }else{
            print("Step 1 Preparation Fails,Table Creation Error")
        }
    }
    
    func insertData(name: String,result: String,avg: Int,list:[Grade])
    {
        let query = "INSERT INTO grade(id, name, result, avg, list) VALUES (?, ?, ?, ?, ?)"
        var statement: OpaquePointer? = nil
        
        var isEmpty = false
        if readData(avgType: avg).isEmpty{
            isEmpty = true
        }
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK
        {
            //Way of inserting Data in Database
            if isEmpty{
                sqlite3_bind_int(statement, 1, 1) //2nd Parameter for Column,3rd for Value
            }
            sqlite3_bind_text(statement, 2, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 3, (result as NSString).utf8String, -1, nil)
            sqlite3_bind_int(statement, 4, Int32(avg))
            
            //Convert list of type Grade -> JSON -> String
            let data = try! JSONEncoder().encode(list)
            let listString = String(data: data, encoding: .utf8)
            
            //Now Bind List of type String
            
            sqlite3_bind_text(statement, 5, (listString! as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_DONE{
                print("Data Inserted Successfully.")
            }else{
                print("Data Insertion Failed")
            }
            
        } else {
            print("Query is not as per requirement")
        }
    }
    
    func readData(avgType: Int) -> [dbGrade]
    {
        var mainList = [dbGrade]()
        let query = "SELECT * FROM grade "
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK
        {
            while sqlite3_step(statement) == SQLITE_ROW{
                let id = Int(sqlite3_column_int(statement, 0))
                let name = String(describing: String(cString:sqlite3_column_text(statement, 1)))
                let result = String(describing: String(cString:sqlite3_column_text(statement, 2)))
                let avg =  Int(sqlite3_column_int(statement, 3))
                let list = String(describing: String(cString: sqlite3_column_text(statement, 4)))
                let model = dbGrade()
                model.id = id
                model.name = name
                model.result = result
                model.avgType = avg
                
                let data = try! JSONDecoder().decode([Grade].self, from: list.data(using: .utf8)!)
                model.list = data
                
                mainList.append(model)
            }
        }
        return mainList
    }
    
    func updateData(id: Int,name: String,result: String,avg: Int,list:[Grade])
    {
        let listData = try! JSONEncoder().encode(list)
        let strList = String(data: listData, encoding: .utf8)
        let query = "UPDATE grade SET name = '\(name)',result = '\(result)',avg = \(avg),list = '\(strList!)' WHERE id = \(id)"
        
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK
        {
            if sqlite3_step(statement) == SQLITE_DONE{
                print("Data Updated Successfully.")
            }else{
                print("Data Update Failed")
            }
        }
    }
    
    func deleteData(id: Int)
    {
        let query = "DELETE from grade WHERE id = \(id)"
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK
        {
            if sqlite3_step(statement) == SQLITE_DONE{
                print("ID - \(id) Deleted Successfully.")
            }else{
                print("Error Deleting ID \(id)")
            }
        }
    }
}
