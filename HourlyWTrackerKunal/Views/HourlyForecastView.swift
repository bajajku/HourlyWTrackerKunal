//
//  HourlyForecastView.swift
//  HourlyWTrackerKunal
//
//  Created by Kunal Bajaj on 2024-11-27.
//

import SwiftUI

struct HourlyForecastView: View {
    @ObservedObject var viewModel: WeatherViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Hourly Forecast (Next 7 Hours)")
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    if let forecastHours = getNextSevenHours(from: viewModel.weather?.forecast?.forecastday?.first?.hour) {
                        ForEach(forecastHours, id: \.time_epoch) { hour in
                            VStack {
                                Text(getFormattedTime(from: hour.time))
                                    .font(.caption)
                                    .foregroundColor(.white)
                                
                                AsyncImage(url: URL(string: "https:\(hour.condition?.icon ?? "")")) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 50, height: 50)
                                } placeholder: {
                                    ProgressView()
                                }
                                
                                Text("\(String(format: "%.1f", hour.temp_c ?? 0.0))°C")
                                    .font(.title3)
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .background(Color.blue.opacity(0.3))
                            .cornerRadius(10)
                        }
                    } else {
                        Text("No forecast data available")
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical)
    }
    
    // Function to filter and get the next 7 hours of forecast
    private func getNextSevenHours(from hours: [Hour]?) -> [Hour]? {
        guard let hours = hours else { return nil }
        let currentEpoch = Date().timeIntervalSince1970
        let sevenHoursLater = currentEpoch + (7 * 60 * 60)
        return hours.filter { $0.time_epoch ?? 0 >= Int(currentEpoch) && $0.time_epoch ?? 0 <= Int(sevenHoursLater) }
    }
    
    // Function to format the time string
    private func getFormattedTime(from time: String?) -> String {
        guard let time = time else { return "N/A" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        if let date = dateFormatter.date(from: time) {
            dateFormatter.dateFormat = "h a" // Example: "2 PM"
            return dateFormatter.string(from: date)
        }
        return time
    }
}
