// Kunal Bajaj
// 991648986

import Foundation

class WeatherViewModel: ObservableObject, Identifiable {
    
    @Published var weather: WeatherForecast?
    
    
    let baseURL: String = "https://api.weatherapi.com/v1/forecast.json?"
    let key: String = "0f9872779b184f46b1c185742241011"
    
    func getWeather(for city: String, aqi: String) {
        DispatchQueue.main.async {
                self.weather = nil // Clear previous weather data
        }
        let urlString = baseURL + "key=\(key)&q=\(city)&aqi=\(aqi)&alerts=no"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response from server")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let decodedWeather = try JSONDecoder().decode(WeatherForecast.self, from: data)
                DispatchQueue.main.async {
                    self.weather = decodedWeather
                }
            } catch {
                print("Error Decoding data: \(error)")
            }
        }
        task.resume()
    }
}
