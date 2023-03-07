//
//  UITextView+ConvenienceInit.swift
//  Diary
//
//  Created by 써니쿠키, LJ on 2022/12/20.
//

import UIKit

extension UITextView {
    
    convenience init(font: UIFont.TextStyle = .body) {
        self.init(frame: .zero)
        self.font = .preferredFont(forTextStyle: font)
        self.isEditable = true
        self.isScrollEnabled = false
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
