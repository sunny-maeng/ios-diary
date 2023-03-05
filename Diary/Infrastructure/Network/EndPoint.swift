//
//  EndPoint.swift
//  Diary
//
//  Created by 써니쿠키 on 2023/03/04.
//

import Foundation

final class EndPoint {

    private let config: NetworkConfigurable

    init(config: NetworkConfigurable) {
        self.config = config
    }

    func url() throws -> URL {
        guard let baseURL = URL(string: config.baseURL) else {
            throw NetworkError.generateUrlFailError
        }
   
        guard var urlComponents = URLComponents(string: baseURL.description) else {
            throw NetworkError.generateUrlFailError
        }

        if let path = config.path {
            path.forEach { header in
                urlComponents.path.append(contentsOf: "/\(header)")
            }
        }

        if let queryItems = config.queryItems {
            let items: [URLQueryItem] = queryItems.map { (name, value) in
                URLQueryItem(name: name, value: value)
            }

            urlComponents.queryItems = items
        }

        guard let url = urlComponents.url else {
            throw NetworkError.generateUrlFailError
        }

        return url
    }
    
}
