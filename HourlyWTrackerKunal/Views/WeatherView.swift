//
//  WeatherView.swift
//  KunalWeather
//
//  Created by Kunal Bajaj on 2024-11-10.
//  991648986

import SwiftUI

struct WeatherView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @StateObject private var locationManager = MyLocationManager()
    @State private var showingCoordinateInput = false
    @State private var latitudeText = ""
    @State private var longitudeText = ""
    
    var body: some View {
        ZStack {
            // Background gradient for app,
            // kept colors as bluish to match weather theme.
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.blue.opacity(0.2)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Main content, wrapped in ScrollView
            ScrollView {
                VStack(spacing: 20) {
                    if let weather = viewModel.weather {
                        // Location Header
                        Text("\(weather.location.name), \(weather.location.country)")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                        
                        // Custom Location Button which let user input custom coordinates toi fetch weather
                        Button(action: {
                            showingCoordinateInput = true
                        }) {
                            HStack {
                                Image(systemName: "location.circle")
                                Text("Change Location")
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(20)
                        }
                        
                        // Weather Icon provided by API
                        VStack(spacing: 10) {
                            AsyncImage(url: URL(string: "https:\(weather.current.condition.icon)")) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 100, height: 100)
                            } placeholder: {
                                ProgressView()
                            }
                            
                            Text("\(String(format: "%.1f", weather.current.temp_c))°C")
                                .font(.system(size: 54, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text(weather.current.condition.text)
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                        .padding(.vertical)
                        
                        // Weather Details nested in VStack displaying various weather details, necessary for user.
                        VStack(spacing: 15) {
                            WeatherDetailRow(icon: "thermometer", title: "Feels Like", value: "\(String(format: "%.1f", weather.current.feelslike_c))°C")
                            WeatherDetailRow(icon: "wind", title: "Wind", value: "\(String(format: "%.1f", weather.current.wind_kph)) km/h \(weather.current.wind_dir)")
                            WeatherDetailRow(icon: "humidity", title: "Humidity", value: "\(weather.current.humidity)%")
                            WeatherDetailRow(icon: "sun.max", title: "UV Index", value: "\(String(format: "%.1f", weather.current.uv))")
                            WeatherDetailRow(icon: "eye", title: "Visibility", value: "\(String(format: "%.1f", weather.current.vis_km)) km")
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(15)
                        .padding(.horizontal)
                        
                    } else {
                        VStack(spacing: 20) {
                            ProgressView()
                                .scaleEffect(1.5)
                            Text("Fetching weather data...")
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding()
            }
        }
        .sheet(isPresented: $showingCoordinateInput) {
            // UI for custom coordinate input form
            NavigationStack {
                Form {
                    Section(header: Text("Enter Coordinates")) {
                        TextField("Latitude", text: $latitudeText)
                            .keyboardType(.decimalPad)
                        TextField("Longitude", text: $longitudeText)
                            .keyboardType(.decimalPad)
                    }
                    
                    Button("Update Weather") {
                        if let lat = Double(latitudeText),
                           let lon = Double(longitudeText) {
                            viewModel.getWeather(for: (lat, lon), aqi: "no") { _ in }
                            showingCoordinateInput = false
                        }
                    }
                    .disabled(Double(latitudeText) == nil || Double(longitudeText) == nil)
                }
                .navigationTitle("Custom Location")
                .navigationBarItems(trailing: Button("Cancel") {
                    showingCoordinateInput = false
                })
            }
        }
        // Fetch weather data when location changes, and update weather data.
        .onChange(of: locationManager.myCoordinate) { oldValue, newValue in
            if let coord = newValue {
                viewModel.getWeather(for: (coord.latitude, coord.longitude), aqi: "no") { _ in }
            }
        }
    }
}

#Preview {
    WeatherView()
}
