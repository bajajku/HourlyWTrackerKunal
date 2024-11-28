import SwiftUI

struct WeatherView: View {
    @StateObject var viewModel = WeatherViewModel()
    @StateObject private var locationManager = MyLocationManager()
    let city: String
    var body: some View {
        ZStack {
            // Background gradient for app
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.blue.opacity(0.2)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Main content, wrapped in ScrollView
            ScrollView {
                HourlyForecastView(viewModel: viewModel)
                    .padding()
                VStack(spacing: 20) {
                    if let weather = viewModel.weather {
                        // Location Header
                        Text("\(weather.location?.name ?? ""), \(weather.location?.country ?? "")")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                        
                        // Weather Icon provided by API
                        VStack(spacing: 10) {
                            AsyncImage(url: URL(string: "https:\(weather.current?.condition?.icon ?? "")")) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 100, height: 100)
                            } placeholder: {
                                ProgressView()
                            }
                            
                            Text("\(String(format: "%.1f", weather.current?.temp_c ?? 0.0))°C")
                                .font(.system(size: 54, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text(weather.current?.condition?.text ?? "")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                        .padding(.vertical)
                        
                        // Weather Details
                        VStack(spacing: 15) {
                            WeatherDetailRow(icon: "thermometer", title: "Feels Like", value: "\(String(format: "%.1f", weather.current?.feelslike_c ?? 0.0))°C")
                            WeatherDetailRow(icon: "wind", title: "Wind", value: "\(String(format: "%.1f", weather.current?.wind_kph ?? 0.0)) km/h \(weather.current?.wind_dir ?? "")")
                            WeatherDetailRow(icon: "humidity", title: "Humidity", value: "\(weather.current?.humidity ?? 0)%")
                            WeatherDetailRow(icon: "sun.max", title: "UV Index", value: "\(String(format: "%.1f", weather.current?.uv ?? 0.0))")
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
        .onAppear {
            viewModel.getWeather(for: city, aqi: "no") { result in
                switch result {
                case .success:
                    print("Weather data fetched successfully.")
                case .failure(let error):
                    print("Failed to fetch weather data: \(error)")
                }
            }
        }
    }
}

//#Preview {
//    WeatherView()
//}
