//
//  CKMapMarkerManager.swift
//  AMPopTip
//
//  Created by mk on 2017/12/12.
//

import UIKit

class CKMapMarkerManager: NSObject {
    private var dbManager = CKMapDBManager.sharedInstance
    private var mapName: String!
    
    init(name: String) {
        super.init()
        
        mapName = name
        if !dbManager.isExistWithTableName(mapName) {
            let _ = dbManager.createTableWithTableName(mapName, keys: ["point","title"], primaryKey: "point")
        }
    }
    
    func checkMarked(marker: CKMapMarker) -> Bool {
        if let result =  dbManager.queryWithTableName(mapName, keys: ["point"], rwhere: ["point", "=", convertPointToString(point: marker.point)]) {
            if result.count > 0 {
                return true
            }
        }
        
        return false
    }
    
    func mark(marker: CKMapMarker) -> Bool {
        return dbManager.saveObject(finalJsonObject(marker: marker), tableName: mapName, primaryKey: "point")
    }
    
    func unmark(marker: CKMapMarker) -> Bool {
        return dbManager.deleteSomeObject(mapName, twhereId: ["point", "=", convertPointToString(point: marker.point)])
    }
    
    func finalJsonObject(marker: CKMapMarker, isMark: Bool? = nil) -> [String : String] {
        var finalDic = [String : String]()
        let pointStr =  convertPointToString(point: marker.point)
        let title = marker.title
        
        finalDic["point"] = pointStr
        finalDic["title"] = title
        
        return finalDic
    }
    
    func convertPointToString(point: CGPoint) -> String {
        return "\(point.x),\(point.y)"
    }
}
