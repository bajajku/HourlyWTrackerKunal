//
//  CitySelectionView.swift
//  HourlyWTrackerKunal
//
//  Created by Kunal Bajaj on 2024-11-27.
//

import SwiftUI

struct CitySelectionView: View {
    @State private var cityName: String = ""

    var body: some View {
        VStack(spacing: 20) {
            // City Input Field
            TextField("Enter city name", text: $cityName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // Search Button
            Button(action: {
                // Placeholder for action
            }) {
                Text("Search")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .disabled(cityName.isEmpty)

            // Placeholder for Weather Info or Error Message
            Text("Weather information or error message will appear here.")
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding()

            Spacer()
        }
        .padding()
    }
}

struct CitySelectionView_Previews: PreviewProvider {
    static var previews: some View {
        CitySelectionView()
    }
}
