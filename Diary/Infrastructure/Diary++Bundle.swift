//
//  Diary++Bundle.swift
//  Diary
//
//  Created by 맹선아 on 2023/03/04.
//

import Foundation

extension Bundle {
    
    var apiKey: String {
        guard let file = self.path(forResource: "WeatherInfo", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file) else {
            return ""
        }

        guard let key = resource["API_KEY"] as? String else {
            fatalError("weatherInfo.plist에 APIKEY 설정을 해주세요")
        }
        return key
    }

}
