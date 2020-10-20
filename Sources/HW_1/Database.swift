import SQLite3
import Foundation

class Database {
    //Database Wrapper
    static var dbObj : Database!
    
    /*
     Please change this path to where ever this project was downloaded to with.
     To check where this directory is open a terminal app of your choice and type pwd.
     Take that path by copying it and pasting it to dbName
     */
    let dbName = "../ClaimsDB.sqlite"
    
    var conn : OpaquePointer?
    init() {
        //1. create db
        //2. create tables
        if sqlite3_open(dbName,&conn) == SQLITE_OK {
            initializeDB()
            sqlite3_close(conn)
        }
        else {
            let errcode = sqlite3_errcode(conn)
            print("Open database failed due to error \(errcode)")
        }
    }
    private func initializeDB(){
        let sqlSmt = "create table if not exists Claims(claim_id,claim_title, claim_date,claim_isSolved)"
        if sqlite3_exec(conn, sqlSmt, nil, nil, nil) != SQLITE_OK {
            let errCode = sqlite3_errcode(conn)
            print("Create Table failed due to error \(errCode)")
        }
    }
    func getDBconn() -> OpaquePointer? {
        var conn : OpaquePointer?
        if sqlite3_open(dbName,&conn) == SQLITE_OK {
           return conn
        }
        else {
            let errcode = sqlite3_errcode(conn)
            let errmsg = sqlite3_errmsg(conn)
            print("Open database failed due to error \(errcode)")
            print("Open database failed due to error \(errmsg!)")
            let _ = String(format:"%@", errmsg!)
        }
        return conn
    }
    static func getInstance() -> Database{
        if dbObj == nil{
            dbObj = Database()
        }
        return dbObj
    }
}
