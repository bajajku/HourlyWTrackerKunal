//
//  CitySelectionViewModel.swift
//  HourlyWTrackerKunal
//
//  Created by Kunal Bajaj on 2024-11-28.
//

// TODO: ENCOUNTERED A BUG WHICH NEEDS TO BE FIXED

import Foundation
import SwiftUI

class CitySelectionViewModel: ObservableObject {
    @Published var citySuggestions: [String] = []
    @Published var weatherViewModel = WeatherViewModel()
    
    // Sample city database, just to demonstrate the functionality
    private let cityDatabase = [
        "New York", "Los Angeles", "Chicago", "Toronto",
        "Vancouver", "London", "Paris", "Tokyo",
        "Mumbai", "Sydney"
    ]
    
    // Function to update city suggestions based on input
    func updateCitySuggestions(for input: String) {
        if input.isEmpty {
            citySuggestions = []
        } else {
            citySuggestions = cityDatabase.filter { $0.lowercased().contains(input.lowercased()) }
        }
    }
    
    // Function to fetch weather forecast
    func fetchWeatherForecast(for cityName: String, completion: @escaping (Bool) -> Void) {
        weatherViewModel.getWeather(for: cityName, aqi: "no")
        
        // Delay the completion to allow data fetching
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            if let weather = self?.weatherViewModel.weather {
                print("Weather Data Fetched: \(weather)")
                completion(true)
            } else {
                print("Failed to fetch weather data")
                completion(false)
            }
        }
    }
}
