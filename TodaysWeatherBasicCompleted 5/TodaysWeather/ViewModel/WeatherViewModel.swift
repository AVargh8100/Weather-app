//
//  WeatherViewModel.swift
//  TodaysWeather
//
//  Created by Alex Varghese on 8/20/24.
//

import Foundation
import Combine

enum WeatherViewState{
    case loading
    case loaded(WeatherRespone?)
    case error(String)
}

final class WeatherViewModel:ObservableObject{
    private let networkManager: NetworkManagerActions
    private let locationManager: WeatherLocationManagerActions

    @Published var viewState = WeatherViewState.loading
    private var anyCancellable = Set<AnyCancellable>()
    @Published var searchText: String = ""

    init(networkManager: NetworkManagerActions,locationManager:WeatherLocationManagerActions = WeatherLocationManger()) {
        self.networkManager = networkManager
        self.locationManager = locationManager
        
        if let lastSearchedCity = UserDefaults.standard.string(forKey: "LastSearchedCity") {
            let apiString = APIEndPoint.getWeatherDataFromCityURL(cityName: lastSearchedCity)
            UserDefaults.standard.setValue(searchText, forKey: "LastSearchedCity")
            self.getCurrentWeatherData(urlString: apiString)
        } else {
            // If no last searched city, start listening for location updates
            observeLocationUpdates()
            UserDefaults.standard.removeObject(forKey: "LastSearchedCity")
        }
        
        // Observe searchText and debounce the input
        $searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                guard let self = self, !searchText.isEmpty else { return }
                let apiString = APIEndPoint.getWeatherDataFromCityURL(cityName: searchText)
                     self.getCurrentWeatherData(urlString: apiString)
            }
            .store(in: &anyCancellable)
    }
    private func observeLocationUpdates() {
        // Observe location changes
        locationManager.currentLocation
            .compactMap { $0 } // Filter out nil values
            .sink { [weak self] location in
                let urlString = APIEndPoint.getWeatherForCurrentLocationURL(lat: location.coordinate.latitude, lon: location.coordinate.longitude)

                self?.getWeatherForCurrentLocation(urlString: urlString)
            }
            .store(in: &anyCancellable)
}
    
    func getCurrentWeatherData(urlString:String) {
        viewState = .loading

        networkManager.get(url:urlString , modelType: WeatherRespone.self)
            .receive(on: DispatchQueue.main)

            .sink { [weak self] completion in
                switch completion{
                case .finished:
                    print("finished")
                case .failure(let error):
                    self?.viewState = WeatherViewState.error(error.localizedDescription)
                }
            } receiveValue: { [weak self] weather  in
                self?.viewState = WeatherViewState.loaded(weather)
            }.store(in: &anyCancellable)
    }
    
    func getWeatherForCurrentLocation(urlString:String) {
        viewState = .loading
        
        networkManager.get(url: urlString, modelType: WeatherRespone.self)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    print("Finished loading weather data.")
                case .failure(let error):
                    self?.viewState = .error(error.localizedDescription)
                }
            } receiveValue: { [weak self] weather in
                self?.viewState = .loaded(weather)
            }
            .store(in: &anyCancellable)
    }

}
