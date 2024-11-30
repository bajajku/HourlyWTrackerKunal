//
//  AppIntent.swift
//  WeatherWidget
//
//  Created by Kunal Bajaj on 2024-11-29.
//

import WidgetKit
import AppIntents


struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Configuration" }
    static var description: IntentDescription { "This is an example widget." }

    // An example configurable parameter.
    
    // Add a parameter to specify the city for weather display.
    @Parameter(title: "City", default: "New York")
    var city: String
}
