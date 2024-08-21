//
//  WeatherViewModelTests.swift
//  TodaysWeatherTests
//
//  Created by Alex Varghese on 8/21/24.
//

import XCTest
import Combine
@testable import TodaysWeather
final class WeatherViewModelTests: XCTestCase {

    var weatherViewModel: WeatherViewModel!
    var fakeNetworkManager: FakeNetworkManager!
    var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        fakeNetworkManager =  FakeNetworkManager()
        weatherViewModel = WeatherViewModel(networkManager:fakeNetworkManager)
        cancellables = Set<AnyCancellable>()

    }

    override func tearDownWithError() throws {
        fakeNetworkManager = nil
        weatherViewModel =  nil
        cancellables = nil

    }

    func testCurrentWeatherDataAPICallForWhenEveryThingGoesCorrect() throws {

        let url = "WeatherTest"
         weatherViewModel.getCurrentWeatherData(urlString:url)
        let expectation = XCTestExpectation(description: "Expecting_CorrectData")
        let waitDuration = 1.0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + waitDuration){

        XCTAssertNotNil(self.weatherViewModel)
        XCTAssertNotNil(self.weatherViewModel.viewState)

        switch self.weatherViewModel.viewState{
        case .loading:
            expectation.fulfill()
            break
            
        case .loaded(let weatherData):
            XCTAssertEqual(weatherData?.name, "New York")
            XCTAssertEqual(weatherData?.main.feelsLike, 292.67)
            XCTAssertEqual(weatherData?.main.tempMax, 294.98)
            XCTAssertEqual(weatherData?.main.humidity, 56)
            XCTAssertEqual(weatherData?.wind.speed, 7.2)
            expectation.fulfill()

        case .error(let error):
            XCTAssertNil(error)
            expectation.fulfill()
        }
        }
        wait(for: [expectation], timeout: waitDuration)

    }

    func testCurrentWeatherDataAPICallWhenFetchingWeatherDataWhenSerachWordIsEmpty()   throws {
         weatherViewModel.getCurrentWeatherData(urlString:"")
        let expectation = XCTestExpectation(description: "Expecting_NoData")
        let waitDuration = 1.0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + waitDuration){

                XCTAssertNotNil(self.weatherViewModel)
                switch self.weatherViewModel.viewState{
                case .loading:
                    break
                    
                case .loaded(let weatherData):
                    XCTAssertNil(weatherData)

                case .error(let error):
                    XCTAssertNotNil(error)

                }
                XCTAssertNotNil(self.weatherViewModel.viewState)
            expectation.fulfill()

        }
        wait(for: [expectation], timeout: waitDuration)

        }
    func testCurrentWeatherDataAPICallWhenFetchingWeatherData_WhenENDpointisCorrect_Expecting_ParsingError()  throws{
      
        //when
         weatherViewModel.getCurrentWeatherData(urlString:"WeatherTestParsingIssue")
        let expectation = XCTestExpectation(description: "Expecting_parsing issue")
        let waitDuration = 1.0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + waitDuration){

                XCTAssertNotNil(self.weatherViewModel)
                switch self.weatherViewModel.viewState{
                case .loading:
                    break
                    
                case .loaded(let weatherData):
                    XCTAssertNil(weatherData)

                case .error(let error):
                    XCTAssertNotNil(error)

                }
                XCTAssertNotNil(self.weatherViewModel.viewState)
            expectation.fulfill()

        }
        wait(for: [expectation], timeout: waitDuration)


    }
    
    func testCurrentWeatherData_WhenENDpointisCorrect_Expecting_NoData()   {
      
        //when
         weatherViewModel.getCurrentWeatherData(urlString:"somethingWrong")
        let expectation = XCTestExpectation(description: "Expecting_NoData")
        let waitDuration = 1.0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + waitDuration){


                XCTAssertNotNil(self.weatherViewModel)
                switch self.weatherViewModel.viewState{
                case .loading:
                    break
                    
                case .loaded(let weatherData):
                    XCTAssertNil(weatherData)

                case .error(let error):
                    XCTAssertNotNil(error)

                }
                XCTAssertNotNil(self.weatherViewModel.viewState)
            expectation.fulfill()

        }
        wait(for: [expectation], timeout: waitDuration)

    }
    
    ///test cases for 2nd api for getWeatherForCurrentLocation
    func testgetWeatherForCurrentLocationAPICallForWhenEveryThingGoesCorrect() throws {

        let url = "WeatherTestCurrentLocation"
         weatherViewModel.getWeatherForCurrentLocation(urlString: url)
        
        let expectation = XCTestExpectation(description: "Expecting_CorrectData")
        let waitDuration = 1.0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + waitDuration){

        XCTAssertNotNil(self.weatherViewModel)
        switch self.weatherViewModel.viewState{
        
        case .loading:
            break
            
        case .loaded(let weatherData):
            XCTAssertEqual(weatherData?.name, "Manhattan")
            XCTAssertEqual(weatherData?.main.feelsLike, 295.01)
            XCTAssertEqual(weatherData?.main.tempMax, 297.11)
            XCTAssertEqual(weatherData?.main.humidity, 46)
            XCTAssertEqual(weatherData?.wind.speed, 8.75)
            
        case .error(let error):
            XCTAssertNil(error)
        }
        XCTAssertNotNil(self.weatherViewModel.viewState)
            expectation.fulfill()

        }
        wait(for: [expectation], timeout: waitDuration)
    }

    func testgetWeatherForCurrentLocationWhenFetchingWeatherDataWhenSerachWordIsEmpty()   throws {
        weatherViewModel.getWeatherForCurrentLocation(urlString:"")
        let expectation = XCTestExpectation(description: "Expecting_NoData")
        let waitDuration = 1.0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + waitDuration){

                XCTAssertNotNil(self.weatherViewModel)
                switch self.weatherViewModel.viewState{
                case .loading:
                    break
                    
                case .loaded(let weatherData):
                    XCTAssertNil(weatherData)

                case .error(let error):
                    XCTAssertNotNil(error)

                }
                XCTAssertNotNil(self.weatherViewModel.viewState)
            expectation.fulfill()

        }
        wait(for: [expectation], timeout: waitDuration)
        }
    func testgetWeatherForCurrentLocationWhenFetchingWeatherData_WhenENDpointisCorrect_Expecting_ParsingError()  throws{
      
        //when
        weatherViewModel.getWeatherForCurrentLocation(urlString:"WeatherTestCurrentLocationParsing")
        let expectation = XCTestExpectation(description: "Expecting_parsingError")
        let waitDuration = 1.0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + waitDuration){


                XCTAssertNotNil(self.weatherViewModel)
                switch self.weatherViewModel.viewState{
                case .loading:
                    break
                    
                case .loaded(let weatherData):
                    XCTAssertNil(weatherData)

                case .error(let error):
                    XCTAssertNotNil(error)

                }
                XCTAssertNotNil(self.weatherViewModel.viewState)
        expectation.fulfill()

    }
    wait(for: [expectation], timeout: waitDuration)

    }
    
    func testgetWeatherForCurrentLocation_WhenENDpointisCorrect_Expecting_NoData()   {
      
        //when
        weatherViewModel.getWeatherForCurrentLocation(urlString:"somethingWrong")
        let expectation = XCTestExpectation(description: "Expecting_Nodata")
        let waitDuration = 1.0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + waitDuration){


                XCTAssertNotNil(self.weatherViewModel)
                switch self.weatherViewModel.viewState{
                case .loading:
                    break
                    
                case .loaded(let weatherData):
                    XCTAssertNil(weatherData)

                case .error(let error):
                    XCTAssertNotNil(error)

                }
                XCTAssertNotNil(self.weatherViewModel.viewState)
        expectation.fulfill()

    }
    wait(for: [expectation], timeout: waitDuration)
    }
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
