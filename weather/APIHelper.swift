//
//  apiHelper.swift
//  weather
//
//  Created by Mimi Lundberg on 2018-03-25.
//  Copyright © 2018 Mimi Lundberg. All rights reserved.
//

import Foundation

struct CityResponse: Codable {
    let count : Int
    let list : [WeatherInfo]
}

struct WeatherResponse: Codable {
    let list: [WeatherInfo]
}

struct WeatherInfo : Codable {
    let name : String?
    let coord : [String: Double]?
    let main : [String: Double]?
    let dt : Double
    let wind : [String: Double]?
    let sys : Sys?
    let weather: [WeatherDesc]
    
    var temp: Double {
        return main!["temp"]! - 273.15
    }
    
    var country: String {
        return sys!.country!
    }
    
    var tempString: String {
        return String(format: "%.0f", temp)
    }
    
    var i: String {
        return weather[0].icon!
    }
    
    var iconImageData: Data? {
        let url = URL(string:"http://openweathermap.org/img/w/\(weather[0].icon!).png")
        if let data = try? Data(contentsOf: url!) {
            return data
        }
        return nil
    }
}

struct WeatherDesc : Codable {
    let main: String?
    let description: String?
    let icon: String?
}

struct Sys: Codable {
    let sunrise: Double?
    let sunset: Double?
    let type: Int?
    let id: Int?
    let message: Double?
    let country: String?
}
