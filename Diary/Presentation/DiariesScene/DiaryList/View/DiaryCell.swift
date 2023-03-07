//
//  DiaryCell.swift
//  Diary
//
//  Created by 써니쿠키, LJ on 2022/12/20.
//

import UIKit

final class DiaryCell: UICollectionViewListCell {
    
    private let titleLabel = UILabel()
    private let dateLabel = UILabel(font: .subheadline)
    private let previewLabel = UILabel(font: .caption2)
    private var weatherIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let subStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 5
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let totalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 5
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()

    private func configureDiaryCellLayout() {
        configureAccessories()
        dateLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        [dateLabel, weatherIconView, previewLabel].forEach { subStackView.addArrangedSubview($0) }
        [titleLabel, subStackView].forEach { totalStackView.addArrangedSubview($0) }
        contentView.addSubview(totalStackView)
        
        NSLayoutConstraint.activate([
            weatherIconView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.1),
            weatherIconView.heightAnchor.constraint(equalTo: weatherIconView.widthAnchor),
            
            totalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            totalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            totalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            totalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }
    
    private func configureAccessories() {
        self.accessories = [.disclosureIndicator(options: .init(tintColor: .systemGray))]
    }
    
    func configureCell(title: String, date: String, preview: String) {
        configureDiaryCellLayout()
        titleLabel.text = title
        dateLabel.text = date
        previewLabel.text = preview
    }
    
    func configureWeatherIcon(weatherIcon: UIImage) {
        weatherIconView.image = weatherIcon
    }
}