//
//  FMDBQueueManager.swift

import UIKit
import FMDB

class FMDBQueueManager: NSObject {

    static let shareFMDBQueueManager = FMDBQueueManager()
    
    var dbQueue : FMDatabaseQueue?
    
    func openDB(_ dbName : String)  {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        print("*******************************************************  ----------- > ",path)
        
        dbQueue = FMDatabaseQueue(path: "\(path)/\(dbName)")
      
        createTable()
        
       
        
    }
    //....Keychain access value
    //let getkeyvalue = Keychain.value(forKey: kappLastVersion) ?? "Not found"
    
    /*
     * Create Table in database
     * type cause -> 0 , resolution -> 1
     * section RBU 11 -> A , RBU 100 -> B , RBU 100 Sescor -> C , TCD 750 -> D
    */
    func createTable() -> Void {
        let sql_tbl = "CREATE TABLE IF NOT EXISTS NOTE ('id' INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL  UNIQUE,'text' TEXT ,'dt' datetime)"
      
        dbQueue?.inDatabase({ (db) -> Void in
            try? db.executeUpdate(sql_tbl, values: [])
        })
       
    }
    
  
    
    func insertNOTE(getTitle:String,getdate:String)->Int {
        
        let sql = "INSERT INTO NOTE (text,dt) values ('\(getTitle)','\(getdate)')"
        
        var getId:Int = 0
        dbQueue?.inDatabase({ (db) ->Void in
            
            try? db.executeUpdate(sql, values: [])
            
             print(Int(db.lastInsertRowId))
            getId = Int(db.lastInsertRowId)
            
            
            
            
        })
        
        
        return getId
      //  return getlastid.description
    }
    
    
    func CheckNOTE(getdate:String)->NSMutableArray {
        
        let sql = "SELECT * FROM NOTE where dt = '\(getdate)' "
        
        let resultArray:NSMutableArray = []
        
        FMDBQueueManager.shareFMDBQueueManager.dbQueue?.inDatabase({ (db) in
            if let result = try? db.executeQuery(sql, values: []){
                while (result.next()) {
                    
                    let getid = result.string(forColumn: "id") ?? ""
                    let gettext = result.string(forColumn: "text") ?? ""
                    let getdt = result.string(forColumn: "dt") ?? ""
                    
                    
                    let createDic:NSMutableDictionary = NSMutableDictionary()
                    
                    createDic.setValue(getid, forKey: "id")
                    createDic.setValue(gettext, forKey: "text")
                    createDic.setValue(getdt, forKey: "dt")
                    
                    resultArray.add(createDic)
                }
            }
            
        })
        return resultArray
        
    }
    
//    func insertTodo(getTitle:String,getColor:String)->Int {
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
//        let today = dateFormatter.string(from: NSDate() as Date)
//
//        let sql = "INSERT INTO NOTE (text,dt,Type,detail,color) values ('\(getTitle)','\(today)','1','','\(getColor)')"
//
//        var getId:Int = 0
//        dbQueue?.inDatabase({ (db) ->Void in
//
//            try? db.executeUpdate(sql, values: [])
//
//           // print(Int(db.lastInsertRowId))
//            getId = Int(db.lastInsertRowId)
//        })
//
//
//
//
//
//
//        return getId
//        //  return getlastid.description
//    }
    
    
    
   
    
    //text,dt,Type,detail,color
    func GetAllCategory(bymonth:String)->NSMutableArray
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        
        
        
        
        let theDate = dateFormatter.date(from: bymonth)
        
        
        dateFormatter.dateFormat = "MM"
        
        let getMonth = dateFormatter.string(from: theDate!)
        
        dateFormatter.dateFormat = "YYYY"
        
        let getYear = dateFormatter.string(from: theDate!)
        
        let createStartingDate:String = "\(getYear)-\(getMonth)-01"
        
       // print("createStartingDate",createStartingDate)
        
       // let sql = "SELECT * from NOTE "
       let sql = "select * from NOTE where dt between '\(createStartingDate)' and '\(bymonth)' ORDER BY dt asc"
        //ASC|DESC;"
        
        let resultArray:NSMutableArray = []
        
        FMDBQueueManager.shareFMDBQueueManager.dbQueue?.inDatabase({ (db) in
            if let result = try? db.executeQuery(sql, values: []){
                while (result.next()) {
                    
                    let getid = result.string(forColumn: "id") ?? ""
                    let gettext = result.string(forColumn: "text") ?? ""
                    let getdt = result.string(forColumn: "dt") ?? ""
                   
                    
                    let createDic:NSMutableDictionary = NSMutableDictionary()
                    
                    createDic.setValue(getid, forKey: "id")
                    createDic.setValue(gettext, forKey: "text")
                    createDic.setValue(getdt, forKey: "dt")
                 
                    resultArray.add(createDic)
                }
            }
            
        })
        return resultArray
    }
    
    func GetAllTodo(byid:String)->NSMutableArray
    {
        let sql = "SELECT * from TODO where noteid = '\(byid)'"
        
        let resultArray:NSMutableArray = []
        
        FMDBQueueManager.shareFMDBQueueManager.dbQueue?.inDatabase({ (db) in
            if let result = try? db.executeQuery(sql, values: []){
                while (result.next()) {
                    
                    let getid = result.string(forColumn: "id") ?? ""
                    let gettext = result.string(forColumn: "text") ?? ""
                    let getdt = result.string(forColumn: "iscompleted") ?? ""
                  
                    
                    let createDic:NSMutableDictionary = NSMutableDictionary()
                    
                    createDic.setValue(getid, forKey: "id")
                    createDic.setValue(gettext, forKey: "text")
                    createDic.setValue(getdt, forKey: "com")
                   
                    resultArray.add(createDic)
                }
            }
            
        })
        return resultArray
    }
    
    
    func GetAllDataBEtweenDate(bymonth:String,byStartingDate:String)->NSMutableArray
    {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "YYYY-MM-dd"
//
//
//
//
//
//        let theDate = dateFormatter.date(from: bymonth)
//
//
//        dateFormatter.dateFormat = "MM"
//
//        let getMonth = dateFormatter.string(from: theDate!)
//
//        dateFormatter.dateFormat = "YYYY"
//
//        let getYear = dateFormatter.string(from: theDate!)
//
//        let createStartingDate:String = "\(getYear)-\(getMonth)-01"
//
//        print("createStartingDate",createStartingDate)
        
        // let sql = "SELECT * from NOTE "
        let sql = "select * from NOTE where dt between '\(byStartingDate)' and '\(bymonth)' ORDER BY dt asc"
        //ASC|DESC;"
        print(sql)
        let resultArray:NSMutableArray = []
        
        FMDBQueueManager.shareFMDBQueueManager.dbQueue?.inDatabase({ (db) in
            if let result = try? db.executeQuery(sql, values: []){
                while (result.next()) {
                    
                    let getid = result.string(forColumn: "id") ?? ""
                    let gettext = result.string(forColumn: "text") ?? ""
                    let getdt = result.string(forColumn: "dt") ?? ""
                    
                    
                    let createDic:NSMutableDictionary = NSMutableDictionary()
                    
                    createDic.setValue(getid, forKey: "id")
                    createDic.setValue(gettext, forKey: "text")
                    createDic.setValue(getdt, forKey: "dt")
                    
                    resultArray.add(createDic)
                }
            }
            
        })
        return resultArray
    }
    
    

    func UpdateNotes(getTitle:String,getdate:String,getID:String) {
        
        
        let sql = "UPDATE NOTE SET text = '\(getTitle)',dt = '\(getdate)' where id = '\(getID)'"
        
        
        dbQueue?.inDatabase({ (db) ->Void in
            
            try? db.executeUpdate(sql, values: [])
            
        })
        
        
        
        //  return getlastid.description
    }
    
  
    
  
    
  
    
}
