//
//  CurrentWeather.swift
//  SimpleWeather
//
//  Created by Petr on 06.11.17.
//  Copyright © 2017 Andi. All rights reserved.
//

import Foundation
import UIKit

class CurrentWeather {
    
    fileprivate var _cityName: String!
    fileprivate var _date: String!
    fileprivate var _weatherType: String!
    fileprivate var _currentTemp: Double!
    
    var cityName: String {
        if _cityName == nil {
            _cityName = ""
        }
        
        return _cityName
    }
    
    var date: String {
        if _date == nil {
            _date = ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        let currentDate = dateFormatter.string(from: Date())
        self._date = "Today, \(currentDate)"
        return _date
    }
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    
    var currentTemp: Double {
        if _currentTemp == nil {
            _currentTemp = 0.0
        }
        return _currentTemp
    }
    
    func downloadWeatherDetails(completed: @escaping DownloadComplete) {
        
        let session = URLSession.shared
        let url = URL(string: CURRENT_WEATHER_URL)!

        session.dataTask(with: url) { (data, response, error) in
            
            if let responseData = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.allowFragments)
                    
                    print(json)
                    if let dict = json as? Dictionary<String, AnyObject> {
                    
                        print("this is the dictionary \(dict)")
                        if let name = dict["name"] as? String {
                            self._cityName = name.capitalized
                            print("city" + self._cityName)
                        }
                        if let weather = dict["weather"] as? [Dictionary<String, AnyObject>] {
                            if let main = weather[0]["main"] as? String {
                                self._weatherType = main.capitalized
                                print(self._weatherType)
                            }
                        }
                        if let main = dict["main"] as? Dictionary<String, AnyObject> {
                            if let currentTemperature = main["temp"] as? Double {
                                let kelvinToFahrenheitPreDivision = (currentTemperature * (9/5) - 459.67)
                                let kelvinToFahrenheit = Double(round(10 * kelvinToFahrenheitPreDivision/10))
                                self._currentTemp = kelvinToFahrenheit
                                print(self._currentTemp)
                            }
                        }
                    }
                    print(json)
                } catch {
                    print("Could not serialize")
                }
                
                
            }
            completed()
            } .resume()
    }
}
