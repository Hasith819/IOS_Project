//
//  LocationService.swift
//  ios-project
//
//  Created by student6 on 2026-07-07.
//
import Foundation
import CoreLocation
import Combine


final class LocationService: NSObject, ObservableObject {
    
    static let shared = LocationService()
    
    
    private let manager = CLLocationManager()
    
    
    @Published var currentLocation: CLLocation?
    
    
    private override init() {
        super.init()
        
        manager.delegate = self
        
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
    }
    
    
    func requestPermission() {
        
        manager.requestWhenInUseAuthorization()
        
        manager.startUpdatingLocation()
    }
    
    
    func stopUpdating() {
        manager.stopUpdatingLocation()
    }
}



extension LocationService: CLLocationManagerDelegate {
    
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        
        guard let location = locations.last else {
            return
        }
        
        DispatchQueue.main.async {
            self.currentLocation = location
        }
    }
    
    
    func locationManagerDidChangeAuthorization(
        _ manager: CLLocationManager
    ) {
        
        switch manager.authorizationStatus {
            
        case .authorizedWhenInUse,
             .authorizedAlways:
            
            manager.startUpdatingLocation()
            
        default:
            break
        }
    }
}
