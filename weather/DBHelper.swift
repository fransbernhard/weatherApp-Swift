//
//  DBHelper.swift
//  weather
//
//  Created by Mimi Lundberg on 2018-03-15.
//  Copyright © 2018 Mimi Lundberg. All rights reserved.
//

import Foundation

class DBHelper {
    private let key = "savedData"
    private let defaults = UserDefaults.standard
    
    func getAllData() -> [String] {
        let saveData = defaults.object(forKey: key)
    
        if saveData is [String] {
            return saveData as! [String]
        } else {
            return []
        }
    }
    
    private func save(_ data: [String]){
        defaults.set(data, forKey: key)
    }
    
    func add(city: String){
        if !isInFav(city) {
            var data = getAllData()
            data.append(city)
            save(data)
        }
    }
    
    func delete(city: String){
        let newFavorites = getAllData().filter{
            $0 != city
        }
        save(newFavorites)
    }
    
    func isInFav(_ city: String) -> Bool {
        return getAllData().contains(city)
    }
    
}
