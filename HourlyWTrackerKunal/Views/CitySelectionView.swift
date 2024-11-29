import SwiftUI

struct CitySelectionView: View {
    @State private var cityName: String = ""
    @State private var citySuggestions: [String] = []
    @StateObject private var citySelectionViewModel = CitySelectionViewModel()
    @State private var errorMessage: String? = nil
    @State private var showWeatherView: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // City Input Field
                TextField("Enter city name", text: $cityName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .onChange(of: cityName) { newValue in
                        citySelectionViewModel.updateCitySuggestions(for: newValue)
                        citySuggestions = citySelectionViewModel.citySuggestions
                    }
                
                // City Suggestions List
                if !citySuggestions.isEmpty {
                    List(citySuggestions, id: \.self) { suggestion in
                        Button(action: {
                            cityName = suggestion
                            citySuggestions = [] // Clear suggestions after selection
                        }) {
                            Text(suggestion)
                        }
                    }
                    .listStyle(PlainListStyle())
                    .frame(height: 150) // Adjust height as needed
                }
                
                // Search Button
                Button("Search") {
                    citySelectionViewModel.fetchWeatherForecast(for: cityName) { success in
                        if success {
                            showWeatherView = true
                            errorMessage = nil
                        } else {
                            errorMessage = "Failed to fetch weather data for \(cityName). Please try again."
                            showWeatherView = false // Ensure it doesn't navigate to the WeatherView
                        }
                    }
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(cityName.isEmpty ? Color.gray : Color.blue)
                .cornerRadius(8)
                .disabled(cityName.isEmpty)
                
                // Error Message
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                
                Spacer()
            }
            .sheet(isPresented: $showWeatherView) {
                WeatherView(viewModel: citySelectionViewModel.weatherViewModel)
            }
            .padding()
        }
    }
}

struct CitySelectionView_Previews: PreviewProvider {
    static var previews: some View {
        CitySelectionView()
    }
}
