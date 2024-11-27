//
//  Current.swift
//  KunalWeather
//
//  Created by Kunal Bajaj on 2024-11-10.
// 991648986

import Foundation

class Current: Codable {
    let last_updated: String
    let temp_c: Double
    let temp_f: Double
    let condition: Condition
    let wind_kph: Double
    let humidity: Double
    let feelslike_c: Double
    let feelslike_f: Double
    let air_quality: AirQuality?
    let wind_dir: String
    let uv: Double
    let vis_km: Double
}
