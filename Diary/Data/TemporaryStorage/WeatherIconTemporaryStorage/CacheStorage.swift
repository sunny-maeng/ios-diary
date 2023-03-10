//
//  CacheStorage.swift
//  Diary
//
//  Created by 써니쿠키 on 2023/03/08.
//

import Foundation

protocol CacheStorage {
    
    func cacheIcon(cacheKey: NSString) -> NSData?
    func store(cacheKey: NSString, icon: NSData) 
}
