import Kitura
import Cocoa

let router = Router()
let dbObj = Database.getInstance()
router.all("/ClaimsService/add",middleware: BodyParser())
router.all("/"){
    request, response, next in
    response.send("Hello! Welcome to the Service")
    next()
}
router.get("/ClaimsService/getAll"){
    request, response, next in
    let pList = ClaimsDB().getAll()
    let jsonData : Data = try JSONEncoder().encode(pList)
    let jsonStr =  String(data: jsonData, encoding: .utf8)
    response.status(.OK)
    response.headers["Content-Type"] = "application/json"
    response.send(jsonStr)
    next()
}
router.post("/ClaimsService/add"){
    request, response, next in
    let body = request.body
    let jObj = body?.asJSON
    if let jDict = jObj as? [String:String]{
        if let title = jDict["title"], let date = jDict["date"],let isSolved = jDict["isSolved"]{
            let uuid = UUID().uuidString
            let cObj = Claims(id: uuid, title_: title, date_: date, isSolved_: isSolved)
            ClaimsDB().addClaim(pObj: cObj)
        }
    }
    response.send("Claim has been sent VIA postMethod")
    next()
}
router.get("/ClaimsService/add"){
    request,response,next in
    let isSolved = request.queryParameters["isSolved"]
    let date = request.queryParameters["date"]
    if let title =  request.queryParameters["title"]{
        let pObj = Claims(title_: title, date_: date, isSolved_: isSolved)
        ClaimsDB().addClaim(pObj: pObj)
        response.send("The Claim Record inserted!")
    }
    else{
        
    }
    next()
}
Kitura.addHTTPServer(onPort: 8080, with: router)
Kitura.run()
