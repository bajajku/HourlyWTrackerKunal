//
//  Location.swift
//  KunalWeather
//
//  Created by Kunal Bajaj on 2024-11-10.
//  991648986

import Foundation

class Location: Codable{
    let name: String
    let region: String
    let country: String
    let lat: Double
    let lon: Double
    let tz_id: String
    let localtime: String
}
