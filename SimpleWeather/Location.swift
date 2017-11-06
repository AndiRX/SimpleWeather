//
//  Location.swift
//  SimpleWeather
//
//  Created by Petr on 06.11.17.
//  Copyright © 2017 Andi. All rights reserved.
//


import CoreLocation

class Location {
    static var sharedInstance = Location()
    private init() {}
    
    var latitude: Double!
    var longitude: Double!
}

