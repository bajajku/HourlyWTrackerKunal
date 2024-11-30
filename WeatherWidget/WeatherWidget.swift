//
//  WeatherWidget.swift
//  WeatherWidget
//
//  Created by Kunal Bajaj on 2024-11-29.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent(), weather: nil, hourlyWeather: nil)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        let weather = await fetchWeather(for: configuration.city)
        return SimpleEntry(date: Date(), configuration: configuration, weather: weather, hourlyWeather: weather?.forecast?.forecastday?.first?.hour?.first)
    }

    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        guard let weather = await fetchWeather(for: configuration.city),
              let hourlyData = weather.forecast?.forecastday?.first?.hour else {
            // Handle case where weather data is unavailable
            return Timeline(entries: [], policy: .atEnd)
        }

        let currentDate = Date()
        var entries: [SimpleEntry] = []

        for hourOffset in 0..<5 {
            guard let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate) else { continue }
            let hourIndex = Calendar.current.component(.hour, from: entryDate)

            if hourIndex < hourlyData.count {
                let hourlyWeather = hourlyData[hourIndex]
                let entry = SimpleEntry(date: entryDate, configuration: configuration, weather: weather, hourlyWeather: hourlyWeather)
                entries.append(entry)
            }
        }

        return Timeline(entries: entries, policy: .atEnd)
    }

    private func fetchWeather(for city: String) async -> WeatherForecast? {
        let baseURL = "https://api.weatherapi.com/v1/forecast.json"
        let key = "0f9872779b184f46b1c185742241011"
        let urlString = "\(baseURL)?key=\(key)&q=\(city)&aqi=no&alerts=no"

        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return nil
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response from server")
                return nil
            }

            let decodedWeather = try JSONDecoder().decode(WeatherForecast.self, from: data)
            return decodedWeather
        } catch {
            print("Error fetching weather data: \(error)")
            return nil
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let weather: WeatherForecast?
    let hourlyWeather: Hour?
}

struct WeatherWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack(spacing: 5) {
            // City Name
            Text(entry.configuration.city)
                .font(.headline)
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            // Date and Time (Single Line)
            Text("\(entry.date, style: .time) • \(entry.date, style: .date)")
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            // Weather Information
            if let hourlyWeather = entry.hourlyWeather {
                HStack(spacing: 5) {
                    // Weather Icon
                    if let iconURL = hourlyWeather.condition?.icon,
                       let url = URL(string: "https:\(iconURL)"),
                       let data = try? Data(contentsOf: url),
                       let image = UIImage(data: data) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                    }

                    // Temperature and Condition
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(String(format: "%.0f", hourlyWeather.temp_c ?? 0.0))°C")
                            .font(.headline)
                        Text(hourlyWeather.condition?.text ?? "")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                    }
                }
            } else {
                // Placeholder for loading state
                Text("Loading...")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(8) // Reducing padding for compact fit
    }
}
struct WeatherWidget: Widget {
    let kind: String = "WeatherWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            WeatherWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}
