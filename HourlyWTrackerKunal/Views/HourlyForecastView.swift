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
            Text("Hourly Forecast")
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    if let forecastHours = viewModel.weather?.forecast?.forecastday?.first?.hour {
                        ForEach(forecastHours, id: \.time_epoch) { hour in
                            VStack {
                                Text(hour.time ?? "")
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
}

struct HourlyForecastView_Previews: PreviewProvider {
    static var previews: some View {
        HourlyForecastView(viewModel: WeatherViewModel())
    }
}
#Preview {
    HourlyForecastView(viewModel: WeatherViewModel())
}
