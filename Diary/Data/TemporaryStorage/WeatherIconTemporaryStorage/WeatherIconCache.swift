//
//  WeatherIconCache.swift
//  Diary
//
//  Created by 써니쿠키 on 2023/03/08.
//

import Foundation

class WeatherIconCache {

    private let cache: NSCache<NSString, NSData>

    init(cache: NSCache<NSString, NSData> = Cache.shared) {
        self.cache = cache
    }
}

extension WeatherIconCache: CacheStorage {

    func cacheIcon(cacheKey: NSString) -> NSData? {
        return cache.object(forKey: cacheKey)
    }

    func store(cacheKey: NSString, icon: NSData) {
        cache.setObject(icon, forKey: cacheKey)
    }
}
