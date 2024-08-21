//
//  FakeNetworkManager.swift
//  TodaysWeatherTests
//
//  Created by Alex Varghese on 8/21/24.
//

import Foundation
import Combine
@testable import TodaysWeather

class FakeNetworkManager:NetworkManagerActions{
   
    func get<T: Decodable>(url: String, modelType: T.Type) -> AnyPublisher<T, Error>{
        let bundle = Bundle(for: FakeNetworkManager.self)
        if url.isEmpty{
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        guard let urlObj = bundle.url(forResource: url, withExtension: "json") else{
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        do{
            let data = try Data(contentsOf: urlObj)
            let weatherdata = try JSONDecoder().decode(modelType.self, from: data)
            return Just(weatherdata)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }catch{
            print(error.localizedDescription)
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    
}
