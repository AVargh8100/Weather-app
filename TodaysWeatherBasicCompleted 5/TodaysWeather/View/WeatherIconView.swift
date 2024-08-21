//
//  WeatherIconView.swift
//  TodaysWeather
//
//  Created by Alex Varghese on 8/21/24.
//

import SwiftUI

struct WeatherIconView: View {
    let iconID: String

        var body: some View {
            VStack {
                if let iconUrl = URL(string: APIEndPoint.getWeatherIconURL(iconID: iconID )) {
                    AsyncImage(url: iconUrl) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                        case .failure:
                            Image(systemName: "xmark.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                        @unknown default:
                            Image(systemName: "questionmark.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                        }
                    }
                } else {
                    Image(systemName: "questionmark.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                }
            }
        }
}

#Preview {
    WeatherIconView(iconID: "")
}
