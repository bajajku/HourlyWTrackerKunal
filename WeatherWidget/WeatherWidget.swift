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
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent(), weather: nil)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        let weather = await fetchWeather(for: configuration.city)
        return SimpleEntry(date: Date(), configuration: configuration, weather: weather)
    }

    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []
        let currentDate = Date()

        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let weather = await fetchWeather(for: configuration.city)
            let entry = SimpleEntry(date: entryDate, configuration: configuration, weather: weather)
            entries.append(entry)
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
}

struct WeatherWidgetEntryView: View {
    var entry: Provider.Entry
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 8) {
                // City and Date Section
                VStack(alignment: .center, spacing: 4) {
                    Spacer()
                    Text(entry.configuration.city)
                        .font(.system(size: min(geometry.size.width * 0.1, 20), weight: .bold))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5) // Allow text to scale down when necessary
                        .foregroundColor(.white) // City name color
                    
                    Text(entry.date, style: .date)
                        .font(.system(size: min(geometry.size.width * 0.08, 16)))
                        .foregroundColor(.white) // Date text color
                    Text(entry.date, style: .time)
                        .font(.system(size: min(geometry.size.width * 0.08, 16)))
                        .foregroundColor(.white) // Date text color
                }
                .frame(maxWidth: .infinity)
                
                // Weather Information Section
                if let weather = entry.weather {
                    VStack(alignment: .center, spacing: 4) {
                        // Weather Condition and Temperature
                        HStack(spacing: 8) {
                            // Weather Icon
                            if let url = weather.current?.condition?.icon,
                               let imageData = try? Data(contentsOf: URL(string: "https:\(url)")!),
                               let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: min(geometry.size.width * 0.3, 100),
                                           height: min(geometry.size.width * 0.3, 100))
                                    .background(Circle().fill(Color.blue.opacity(0.2))) // Background color for icon
                            }
                            
                            // Temperature and Condition
                            VStack(alignment: .leading, spacing: 4) {
                                
                                Text("\(String(format: "%.1f", weather.current?.temp_c ?? 0.0))°C")
                                    .font(.system(size: min(geometry.size.width * 0.12, 24), weight: .semibold))
                                    .foregroundColor(.yellow) // Temperature color
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                } else {
                    // Loading or Error State
                    Text("Loading weather...")
                        .font(.caption)
                        .foregroundColor(.gray) // Loading text color
                }
            }
            .padding(8)
            .frame(minWidth: geometry.size.width, minHeight: geometry.size.height, alignment: .center)
            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]),
                                       startPoint: .top, endPoint: .bottom)) // Background gradient
            .cornerRadius(12) // Corner radius for rounded corners
        }
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

//extension WeatherWidget {
//    fileprivate static var preview: some View {
//        WeatherWidgetEntryView(entry: SimpleEntry(date: .now, configuration: .smiley))
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
//    }
//}
//
//@main
//struct WeatherWidgetBundle: WidgetBundle {
//    @WidgetBundleBuilder
//    var body: some Widget {
//        WeatherWidget()
//        WeatherWidget.preview
//    }
//}

//extension ConfigurationAppIntent {
//    fileprivate static var smiley: ConfigurationAppIntent {
//        let intent = ConfigurationAppIntent()
//        intent.favoriteEmoji = "😀"
//        return intent
//    }
//    
//    fileprivate static var starEyes: ConfigurationAppIntent {
//        let intent = ConfigurationAppIntent()
//        intent.favoriteEmoji = "🤩"
//        return intent
//    }
//}

//#Preview(as: .systemSmall) {
//    WeatherWidget()
//} timeline: {
////    SimpleEntry(date: .now, configuration: .smiley)
////    SimpleEntry(date: .now, configuration: .starEyes)
//}
