//
//  APIEndPoints.swift
//  Diary
//
//  Created by 써니쿠키 on 2023/03/04.
//

import Foundation

struct APIEndpoints {

    static func getCurrentWeatherData(at location: Location) -> EndPoint {
        let apiDataNetworkConfig = ApiDataNetworkConfig(
            baseURL: "https://api.openweathermap.org",
            path: ["data", "2.5", "weather"],
            queryItems: [(name: "lat", value: String(location.latitude)),
                         (name: "lon", value: String(location.longitude)),
                         (name: "appid", value: Bundle.main.apiKey)
                                                                    ])

        return EndPoint(config: apiDataNetworkConfig)
    }

    static func getWeatherIcon(iconName: String) -> EndPoint {
        let apiDataNetworkConfig = ApiDataNetworkConfig(
            baseURL: "https://openweathermap.org",
            path: ["img", "wn", "\(iconName)@2x.png"],
            queryItems: nil)

        return EndPoint(config: apiDataNetworkConfig)
    }
}
