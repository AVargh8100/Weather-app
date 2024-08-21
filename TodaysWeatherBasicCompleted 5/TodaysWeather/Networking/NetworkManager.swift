//
//  NetworkManager.swift
//  TodaysWeather
//
//  Created by Alex Varghese on 8/20/24.
//

import Foundation
import Combine

protocol NetworkManagerActions {
    func get<T: Decodable>(url: String, modelType: T.Type) -> AnyPublisher<T, Error>
}

struct NetworkManager: NetworkManagerActions {
    func get<T>(url: String, modelType: T.Type) -> AnyPublisher<T, Error> where T : Decodable {
        guard let urlObj = URL(string: url) else {
            return Fail(error: NetworkError.invalidURL)
                .eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: urlObj)
            .tryMap { data, response in
                return data
            }
            .decode(type: modelType.self, decoder: JSONDecoder())
            .mapError { error in
                return NetworkError.apiError(error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
    
}
