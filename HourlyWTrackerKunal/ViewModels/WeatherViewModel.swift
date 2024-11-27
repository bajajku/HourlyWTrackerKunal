// Kunal Bajaj
// 991648986

import Foundation

class WeatherViewModel: ObservableObject, Identifiable {
    
    @Published var weather: WeatherForecast?
    
    
    let baseURL: String = "https://api.weatherapi.com/v1/forecast.json?"
    let key: String = "0f9872779b184f46b1c185742241011"
    
    func getWeather(for city: String , aqi: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
        let urlString = baseURL + "key=\(key)&q=\(city)&aqi=\(aqi)&alerts=no"
        print("URL: \(urlString)")
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        let task = URLSession.shared.dataTask(with: url){data, _ , error in
            if let error {
                print("Error: \(error)")
                completion(.failure(error))
                return
            }
            
            else if let data{
                print("Data: \(String(data: data, encoding: .utf8)!)")
                do{
                    let decodedWeather = try JSONDecoder().decode(WeatherForecast.self, from: data)
                    DispatchQueue.main.async {
                        self.weather = decodedWeather
                    }
                } catch{
                    print("Error Decoding data.\nError: \(error)")
                }
            }
            
        }
        task.resume()
    }
}
