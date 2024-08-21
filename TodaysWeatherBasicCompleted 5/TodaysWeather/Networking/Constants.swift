//
//  Constants.swift
//  TodaysWeather
//
//  Created by Alex Varghese on 8/20/24.
//

import Foundation
struct APIEndPoint{
    static let openWeatherAPIKey = "5212cf290bded257ea38a6522d13a14f"
    static func getWeatherDataFromCityURL(cityName:String) ->String{
        return "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=\(openWeatherAPIKey)"
    }
    
    static func getWeatherIconURL(iconID:String) ->String{
        return "https://openweathermap.org/img/wn/\(iconID)@2x.png"
    }
    
    static func getWeatherForCurrentLocationURL(lat: Double, lon: Double) ->String{
        return "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(openWeatherAPIKey)"
    }
}
