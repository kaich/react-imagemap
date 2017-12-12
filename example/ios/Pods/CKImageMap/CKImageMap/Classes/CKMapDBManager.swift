//
//  CKMapMarkManager.swift
//  AMPopTip
//
//  Created by mk on 2017/12/12.
//

import UIKit
import SQLite
let SQLITE_NAME = "MapDB.sqlite3"

class CKMapDBManager: NSObject {
    
    static let sharedInstance = CKMapDBManager()
    var db: Connection?
    override init() {
        let filename = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).last!+"/\(SQLITE_NAME)"
        
        print("\(filename)")
        do {
            db = try Connection(filename)
        } catch  {
            print("创建数据库出错")
        }
    }
    
    
    /**
     根据表名，字段和主键创建表
     
     */
    func createTableWithTableName(_ name: String, keys: [String], primaryKey: String) -> (Bool) {
        if keys.count == 0 {
            print("字段数组不能为空")
            return false
        }
        if db == nil {
            print("数据库不存在")
            return false
        }
        let users = Table(name)
        
        do {
            try db?.run(users.create(ifNotExists: true, block:{ (t) in
                for key in keys {
                    let sqlite_key = Expression<String?>(key)
                    if key == primaryKey {
                        let primaryKeyExpression = Expression<String>(key)
                        t.column(primaryKeyExpression, primaryKey: true)
                    }else {
                        t.column(sqlite_key)
                    }
                }
            }))
            return true
        } catch  {
            return false
        }
        
    }
    
    func isExistWithTableName(_ tname: String) -> (Bool) {
        if db == nil {
            print("数据库不存在")
            return false
        }
        
        let sqliteMaster = Table("sqlite_master")
        let type = Expression<String>("type")
        let name = Expression<String>("name")
        
        do {
            let tableCount = try db!.scalar(sqliteMaster.filter(type == "table" && name == tname).count)
            return tableCount == 1
        } catch {
            return false
        }
        
    }
    
    //插入数据
    func insertIntoTableName(_ name: String, dict: [String:String]) -> Bool{
        if dict.count==0 {
            print("插入值字典不能为空")
            return false
        }
        if db == nil {
            print("数据库不存在")
            return false
        }
        let keys = dict.keys
        
        self.updateColumns(name, keys: Array(dict.keys))
        var values = [String]()
        let SQL = NSMutableString()
        SQL.append("INSERT INTO \(name) (")
        var i = 0
        for key in keys {
            SQL.append(key)
            if i == keys.count-1 {
                SQL.append(") ")
            }else {
                SQL.append(",")
            }
            values.append(dict[key]!)
            i+=1
        }
        
        SQL.append("VALUES (")
        i = 0
        for _ in keys {
            SQL.append("?")
            if i == keys.count-1 {
                SQL.append(")")
            }else {
                SQL.append(",")
            }
            i+=1
        }
        
        let stmt = try! db!.prepare(SQL as String)
        try! stmt.run(values)
        
        
        return true
    }
    
    //查询数据
    func queryWithTableName(_ name: String, keys: [String], rwhere: [String]?) -> [[String: String]]? {
        
        if db == nil {
            print("数据库不存在")
            return nil
        }
        
        if self.isExistWithTableName(name) == false {
            return nil
        }
        
        self.updateColumns(name, keys: keys)
        var tArray = [[String: String]]()
        
        let SQL = NSMutableString()
        SQL.append("SELECT ")
        var i = 0
        
        for key in keys {
            SQL.append(key)
            if i != keys.count-1 {
                SQL.append(",")
            }
            i+=1
        }
        
        SQL.append(" FROM \(name)")
        
        i = 0
        if let twhere = rwhere {
            if twhere.count%3 == 0 {
                SQL.append(" WHERE ")
                while i<twhere.count {
                    SQL.append("\(twhere[i])\(twhere[i+1])'\(twhere[i+2])'")
                    if i != twhere.count-3 {
                        SQL.append(" AND ")
                    }
                    i+=3
                }
            }
        }
        
        for row in try! db!.prepare(SQL as String) {
            i = 0
            var tDict = [String:String]()
            for key in keys {
                tDict[key] = row[i] as! String?
                i+=1
            }
            tArray.append(tDict)
            
        }
        return tArray
    }
    
    //更新数据
    func updateWithTableName(_ name: String, valueDict:[String: String], rwhere:[String]?) -> Bool {
        if db == nil {
            print("数据库不存在")
            return false
        }
        
        self.updateColumns(name, keys: Array(valueDict.keys))
        let SQL = NSMutableString()
        SQL.append("UPDATE \(name) SET ")
        var i = 0
        for key in valueDict.keys {
            if let tValue = valueDict[key] {
                let tempValue = tValue.replacingOccurrences(of: "'", with: "''")
                if tempValue.count == 0 {
                    SQL.append("\(key)=''")
                }else {
                    SQL.append("\(key)='\(tempValue)'")
                }
                
            }else {
                SQL.append("\(key)=''")
            }
            
            if i != valueDict.keys.count-1 {
                SQL.append(",")
                i+=1
            }
        }
        i = 0
        if let twhere = rwhere {
            if twhere.count%3 == 0 {
                SQL.append(" WHERE ")
                while i<twhere.count {
                    SQL.append("\(twhere[i])\(twhere[i+1])'\(twhere[i+2])'")
                    if i != twhere.count-3 {
                        SQL.append(" AND ")
                    }
                    i+=3
                }
            }
        }
        let stmt = try! db!.prepare(SQL as String)
        try! stmt.run()
        return true
    }
    
    func updateColumns(_ name: String, keys: [String]) {//更新表的列
        
        do {
            let users = Table(name)
            let expression = users.expression
            let columnNames = try db!.prepare(expression.template, expression.bindings).columnNames
            
            for key in keys {
                var isExist = false
                for columnName in columnNames {
                    if key == columnName {
                        isExist = true
                        break
                    }
                }
                if !isExist {
                    do {
                        try db!.run(users.addColumn(Expression<String?>(key)))
                    } catch  {
                        
                    }
                }
            }
            
        } catch  {
            
        }
        
    }
    
    
    
    //存储对象
    func saveObject(_ object: [String : String], tableName: String, primaryKey: String) -> Bool {
        
        if db == nil {
            print("数据库不存在")
            return false
        }
        
        let dict = object
        var keys = [String]()
        for key in dict.keys {
            keys.append(key)
        }
        
        if self.isExistWithTableName(tableName) == false {
            _ = self.createTableWithTableName(tableName, keys: keys, primaryKey: primaryKey)
        }
        let users = Table(tableName)
        let primary_key = Expression<String>(primaryKey)
        let alice = users.filter(primary_key == object[primaryKey]!)
        var t = 0
        do {
            t = try db!.scalar(alice.count)
        } catch  {
            print("查询出错")
            return false
        }
        if t == 0 {
            if self.insertIntoTableName(tableName, dict: dict) == false {
                return false
            }
        }else {
            let twhere = [primaryKey,"=",dict[primaryKey]!]
            if self.updateWithTableName(tableName, valueDict: dict, rwhere: twhere) == false {
                return false
            }
        }
        return true
    }
    
    //查询所有对象
    func queryAllObject(_ name: String, keys: [String], rwhere:[String]?) -> [[String : String]] {
        
        var modelArray = [[String : String]]()
        if self.isExistWithTableName(name) {
            let array = self.queryWithTableName(name, keys: keys, rwhere: rwhere)
            if array != nil {
                for dict in array! {
                    
                    var tDict = dict
                    for key in dict.keys {
                        if dict[key] == nil || dict[key] == "" {
                            tDict.removeValue(forKey: key)
                        }
                    }
                    
                    modelArray.append(tDict)
                }
            }
        }
        
        return modelArray
    }
    
    
    /**
     删除对象
     
     - parameter name:     表名
     - parameter twhereId: 约束条件,例如 ["id","=","123"],目前只能根据单个条件删除对象
     
     - returns:
     */
    func deleteSomeObject(_ name: String, twhereId:[String]) -> Bool {
        if db == nil {
            print("数据库不存在")
            return false
        }
        if self.isExistWithTableName(name) {
            let users = Table(name)
            if twhereId.count==3 {
                let id = Expression<String>(twhereId[0])
                let alice = users.filter(id == twhereId[2])
                do {
                    _ = try db!.run(alice.delete())
                    return true
                } catch  {
                    print("删除对象失败")
                    return false
                }
            }else {
                print("条件错误")
                return false
            }
            
        }else {
            return false
        }
    }
    
    func deleteAllObject(_ name: String) -> Bool {
        if db == nil {
            print("数据库不存在")
            return false
        }
        let SQL = "DELETE FROM \(name)"
        let stmt = try! db!.prepare(SQL as String)
        try! stmt.run()
        return true
    }
}

