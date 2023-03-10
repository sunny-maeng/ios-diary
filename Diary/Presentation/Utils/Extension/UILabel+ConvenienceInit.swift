//
//  UILabel+ConvenienceInit.swift
//  Diary
//
//  Created by 맹선아 on 2023/03/07.
//

import UIKit

extension UILabel {

    convenience init(text: String = "", textColor: UIColor = .black, font: UIFont.TextStyle = .body) {
        self.init(frame: .zero)
        self.text = text
        self.textColor = textColor
        self.font = .preferredFont(forTextStyle: font)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
