//
//  DBHelper.swift
//  weather
//
//  Created by Mimi Lundberg on 2018-03-15.
//  Copyright © 2018 Mimi Lundberg. All rights reserved.
//

import Foundation

class DBHelper {
    let key = "savedData"
    
    func getAllData() -> [String] {
        let userDefaults = UserDefaults.standard
        let saveData = userDefaults.object(forKey: key)
    
        if saveData is [String] {
            return saveData as! [String]
        } else {
            return [] // felhantera
        }
    }
    
    func save(_ data: [String]){
        let defaults = UserDefaults.standard
//        defaults.set(data!, forkey: key)
        
    }
    
    func add(){
        
    }
    
    func delete(){
        
    }
    
    func edit(){
        
    }
    
}
