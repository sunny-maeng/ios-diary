//
//  WeatherResponseDTO.swift
//  Diary
//
//  Created by 써니쿠키 on 2023/03/05.
//

import Foundation

struct WeatherResponseDTO: Decodable {

    let main: String
    let icon: String

    enum CodingKeys: String, CodingKey {
        case main, icon, weather
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var weatherContainer = try container.nestedUnkeyedContainer(forKey: .weather)
        let nestedContainer = try weatherContainer.nestedContainer(keyedBy: CodingKeys.self)

        main = try nestedContainer.decode(String.self, forKey: .main)
        icon = try nestedContainer.decode(String.self, forKey: .icon)
    }

}

extension WeatherResponseDTO {
    
    func toDomain() -> WeatherInfo {
        return .init(main: self.main, icon: self.icon)
    }

}
