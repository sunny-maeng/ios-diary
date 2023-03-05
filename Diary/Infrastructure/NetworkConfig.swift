//
//  NetworkConfig.swift
//  Diary
//
//  Created by 써니쿠키 on 2023/03/04.
//

import Foundation

protocol NetworkConfigurable {

    var baseURL: URL { get }
    var path: [String]? { get }
    var queryItems: [URLQueryItem]? { get }

}

struct ApiDataNetworkConfig: NetworkConfigurable {

    var baseURL: URL
    var path: [String]?
    var queryItems: [URLQueryItem]?

    init(baseURL: URL,
         path: [String]? = nil,
         queryItems: [URLQueryItem]?) {
        self.baseURL = baseURL
        self.path = path
        self.queryItems = queryItems
    }
    
}
