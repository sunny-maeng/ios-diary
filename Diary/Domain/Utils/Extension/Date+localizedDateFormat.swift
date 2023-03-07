//
//  Date+localizedDateFormat.swift
//  Diary
//
//  Created by 써니쿠키 on 2023/03/05.
//

import Foundation

extension Date { //⭐️폴더 이동 예정

    var localizedDateFormat: String {
        return DateFormatter.localizedString(from: self, dateStyle: .long, timeStyle: .none)
    }
}
