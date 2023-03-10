//
//  Date+localizedDateFormat.swift
//  Diary
//
//  Created by ๋งน์ ์ on 2023/03/07.
//

import Foundation

extension Date {

    var localizedDateFormat: String {
        return DateFormatter.localizedString(from: self, dateStyle: .long, timeStyle: .none)
    }
}
