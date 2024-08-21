//
//  NetworkError.swift
//  TodaysWeather
//
//  Created by Alex Varghese on 8/20/24.
//

import Foundation
enum NetworkError: Error {
    case invalidURL
    case apiError(String)
}
