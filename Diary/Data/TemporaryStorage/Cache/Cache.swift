//
//  Cache.swift
//  Diary
//
//  Created by 써니쿠키, LJ on 2023/01/06.
//

import Foundation

final class Cache {
    
    static let shared: NSCache = NSCache<NSString, NSData>()
    
    private init() {}
}
