//
//  MyLocationManager.swift
//  KunalWeather
//
//  Created by Kunal Bajaj on 2024-11-13.
//  991648986

import Foundation
import CoreLocation


//extension CLLocationCoordinate2D: @retroactive Equatable {
//    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
//        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
//    }
//}

class MyLocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
        
    var manager: CLLocationManager?
    
    @Published var location: CLLocation?
    @Published var myCoordinate: CLLocationCoordinate2D?
    
    override init() {
        manager = CLLocationManager()
        super.init()
        manager?.delegate = self
        manager?.desiredAccuracy = kCLLocationAccuracyBest
        manager?.requestWhenInUseAuthorization()
        manager?.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
        myCoordinate = location?.coordinate
        
        print("Location updated: \(myCoordinate?.latitude ?? 0), \(myCoordinate?.longitude ?? 0)")
    }
    
}

