//
//  ViewController.swift
//  TodaysWeather
//
//  Created by Alex Varghese on 8/20/24.
//

import UIKit
import Combine
import SwiftUI

class ViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var weatherInfoView: UIView!
    @IBOutlet weak var errorView: UIView!
    
    @IBOutlet weak var weatherIconView: UIView!
    
    @IBOutlet weak var cityName: UILabel!
    
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var windsSpeed: UILabel!
    @IBOutlet weak var feelsLike: UILabel!
    @IBOutlet weak var temperature: UILabel!
    
    @IBOutlet weak var errorLabel: UILabel!
    private var cancellables = Set<AnyCancellable>()

    let searchBarController = UISearchController()
    private let viewModel = WeatherViewModel(networkManager: NetworkManager())
    @StateObject private var locationManager = WeatherLocationManger()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpInitalUI()
        let lastSearchedCity = UserDefaults.standard.value(forKey: "LastSearchedCity")
        if lastSearchedCity != nil{
            viewModel.searchText = lastSearchedCity as! String
        }
        
    }
    private func setUpInitalUI(){
        searchBarController.searchResultsUpdater = self
        navigationItem.searchController = searchBarController
        displayloadingView()
        // Observe the view state for changes
        viewModel.$viewState
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                self?.updateUI(state)
            }
            .store(in: &cancellables)
    }
    private func displayloadingView(){
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            self.weatherInfoView.isHidden = true
            self.errorView.isHidden = true
        }
    }
    private func updateUI(_ state:WeatherViewState){
        DispatchQueue.main.async {
        switch state{
        case .loading:
                self.displayloadingView()
            
        case .loaded(let weatherData):
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                self.weatherInfoView.isHidden = false
                self.errorView.isHidden = true
                
                //set data
                self.cityName.text = weatherData?.name
                self.temperature.text = "Temperature: \(weatherData?.main.tempMax ?? 0.0)"
                self.feelsLike.text = "Feels Like: \(weatherData?.main.feelsLike ?? 0.0)"
                self.humidity.text = "Humidity: \(weatherData?.main.humidity ?? 0)"
                self.windsSpeed.text = "Wind Speed: \(weatherData?.wind.speed ?? 0.0)"
            
            let iconView = WeatherIconView(iconID: weatherData?.weather.first?.icon ?? "")
            let hostingController = UIHostingController(rootView: iconView)
            hostingController.view.translatesAutoresizingMaskIntoConstraints = false

            self.weatherIconView.addSubview(hostingController.view)
            hostingController.didMove(toParent: self)

            NSLayoutConstraint.activate([

            hostingController.view.topAnchor.constraint(equalTo: self.weatherIconView.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: self.weatherIconView.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: self.weatherIconView.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: self.weatherIconView.bottomAnchor)
            ])



        case .error(let error):
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                self.weatherInfoView.isHidden = true
                self.errorView.isHidden = false
                self.errorLabel.text = error.debugDescription
        }
    }
    }
}

extension ViewController:UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText =  searchController.searchBar.text else{
            print("type something into searchbar")
            return
        }
        guard !searchText.isEmpty else{
            return
        }
            viewModel.searchText = searchText
        }
    
}
