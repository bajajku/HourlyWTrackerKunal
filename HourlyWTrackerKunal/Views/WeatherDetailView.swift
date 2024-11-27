//
//  WeatherDetailView.swift
//  KunalWeather
//
//  Created by Kunal Bajaj on 2024-11-16.
//  991648986

import SwiftUI

// Compoenent to display the weather details
struct WeatherDetailRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 30)
                .foregroundColor(.white)
            
            Text(title)
                .foregroundColor(.white)
            
            Spacer()
            
            Text(value)
                .foregroundColor(.white)
                .bold()
        }
    }
}
