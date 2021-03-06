//
//  ClaimsDB.swift
//  
//
//  Created by Steven Salvador on 10/10/20.
//

struct Claims : Codable {
    var claim_id : String?
    var claim_title : String?
    var claim_date : String?
    var claim_isSolved : String?
    
    init (id : String?, title : String?, date : String?, isSolved : String?){
        claim_id = id
        claim_title = title
        claim_date = date
        claim_isSolved = isSolved
    }
    init(title: String?,date : String?, isSolved : String?) {
        claim_id = UUID().uuidString
        claim_date = date
        claim_title = title
        claim_isSolved = isSolved
    }
}

class ClaimsDB {
    func addClaim(pObj : Claims) {
        let sqlStmt = String(format: "insert into Claims (claim_id,claim_title,claim_date,claim_isSolved) values ('%@','%@','%@','%@')",(pObj.claim_id!),(pObj.claim_title!),(pObj.claim_date!),(pObj.claim_isSolved!))
        let conn = Database.getInstance().getDBConn()
        if sqlite3_exec(conn, sqlStmt, nil, nil, nil) != SQLITE_OK {
            let errCode = sqlite3_errcode(conn)
            print("Failed to insert due to error \(errCode)")
        }
        sqlite3_close(conn)
    }
    func getAll() -> [Claims] {
        var pList = [Claims]()
        var resultSET : OpaquePointer?
        let sqlStr = "select claim_id, claim_title, claim_date, claim_isSolved from Claims"
        let conn = Database.getInstance().getDBConn()
        
        if sqlite3_prepare_v2(conn, sqlStr, -1, &resultSET, nil) == SQLITE_OK
        {
            while (sqlite3_step(resultSET)==SQLITE_ROW) {
                let id_val = sqlite3_column_int(resultSET, 0)
                let id = String(id_val)
                let title_val =  sqlite3_column_text(resultSET, 1)
                let title = String(cString: title_val!)
                let date_val = sqlite3_column_text(resultSET, 2)
                let date = String(cString: date_val!)
                let isSolved_val = sqlite3_column_text(resultSET, 3)
                let isSolved = String(cString: isSolved_val!)
                pList.append(Claims(id: id, title: title, date: date, isSolved: isSolved))
                
            }
        }
        return pList
    }
}
