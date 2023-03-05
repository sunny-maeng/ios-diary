//
//  APIEndPoints.swift
//  Diary
//
//  Created by 써니쿠키 on 2023/03/04.
//

import Foundation

struct APIEndpoints {

    final class Location {
        let latitude: Double
        let longitude: Double

        init(latitude: Double, longitude: Double) {
            self.latitude = latitude
            self.longitude = longitude
        }
    }

    static func generateCurrentWeatherDataUrl(at location: Location) throws -> URL {
        let apiKey = Bundle.main.apiKey

        guard let baseURL = URL(string: "https://api.openweathermap.org") else {
            throw NetworkError.generateUrlFailError
        }

        let apiDataNetworkConfig = ApiDataNetworkConfig(
            baseURL: baseURL,
            path: ["data", "2.5", "weather"],
            queryItems: [URLQueryItem(name: "lat", value: String(location.latitude)),
                         URLQueryItem(name: "lon", value: String(location.longitude)),
                         URLQueryItem(name: "appid", value: apiKey)
                        ])

        return try EndPoint.url(with: apiDataNetworkConfig)
    }

    static func generateWeatherIconUrl(iconName: String) throws -> URL {
        guard let baseURL = URL(string: "https://openweathermap.org") else {
            throw NetworkError.generateUrlFailError
        }

        let apiDataNetworkConfig = ApiDataNetworkConfig( baseURL: baseURL,
                                                         path: ["img", "wn", "\(iconName)@2x.png"],
                                                         queryItems: nil)

        return try EndPoint.url(with: apiDataNetworkConfig)
    }

}
