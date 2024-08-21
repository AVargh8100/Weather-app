//
//  WeatherLocationManger.swift
//  TodaysWeather
//
//  Created by Alex Varghese on 8/21/24.
//

import Foundation
import CoreLocation
import Combine

protocol WeatherLocationManagerActions{
    var currentLocation: Published<CLLocation?>.Publisher { get }
    func requestLocation()
}
class WeatherLocationManger:NSObject,ObservableObject,WeatherLocationManagerActions{
    
    @Published var usersCurrentLocation: CLLocation?

    var currentLocation: Published<CLLocation?>.Publisher {
            $usersCurrentLocation
        }
    
    
    private let cllocattionManager = CLLocationManager()
    
    override init() {
        _usersCurrentLocation = Published(initialValue: nil)

        super.init()
        cllocattionManager.requestWhenInUseAuthorization()
        cllocattionManager.delegate = self
        DispatchQueue.main.async {
            self.cllocattionManager.startUpdatingLocation()
        }
    }
    
    func requestLocation() {
        cllocattionManager.requestWhenInUseAuthorization()
    }
}

extension WeatherLocationManger:CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else{
            return
        }
        DispatchQueue.main.async {
            self.usersCurrentLocation = location
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        print("didFailWithError")
    }
}
