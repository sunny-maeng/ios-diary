//
//  EndPoint.swift
//  Diary
//
//  Created by 써니쿠키 on 2023/03/04.
//

import Foundation

final class EndPoint {

    static func url(with config: ApiDataNetworkConfig) throws -> URL {
        let baseURL = config.baseURL.description
        
        guard var urlComponents = URLComponents(string: baseURL) else {
            throw NetworkError.generateUrlFailError
        }

        if let path = config.path {
            path.forEach { header in
                urlComponents.path.append(contentsOf: "/\(header)")
            }
        }

        if let queryItems = config.queryItems {
            urlComponents.queryItems = queryItems
        }

        guard let url = urlComponents.url else {
            throw NetworkError.generateUrlFailError
        }

        return url
    }
    
}
