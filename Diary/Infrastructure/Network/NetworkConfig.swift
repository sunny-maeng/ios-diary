//
//  NetworkConfig.swift
//  Diary
//
//  Created by 써니쿠키 on 2023/03/04.
//

import Foundation

protocol NetworkConfigurable {

    var baseURL: String { get }
    var path: [String]? { get }
    var queryItems: [(name: String, value: String)]? { get }
}

struct ApiDataNetworkConfig: NetworkConfigurable {

    var baseURL: String
    var path: [String]?
    var queryItems: [(name: String, value: String)]?

    init(baseURL: String,
         path: [String]? = nil,
         queryItems: [(name: String, value: String)]?) {
        self.baseURL = baseURL
        self.path = path
        self.queryItems = queryItems
    }
}
