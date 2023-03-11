//
//  DiaryCell.swift
//  Diary
//
//  Created by 써니쿠키, LJ on 2022/12/20.
//

import UIKit

final class DiaryCell: UICollectionViewListCell {

    private var viewModel: DiaryListCellViewModel?
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
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let totalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
}

extension DiaryCell {

    func configureCell(with viewModel: DiaryListCellViewModel) {
        self.viewModel = viewModel
        configureLayout()
        titleLabel.text = viewModel.title
        dateLabel.text = viewModel.date
        previewLabel.text = viewModel.preview
    }

    func setupWeatherIconView(icon: UIImage?) {
        if let icon = icon {
            weatherIconView.image = icon
        }
    }
}

// MARK: - Hierarchy & Layout & Accessories
extension DiaryCell {

    private func configureHierarchy() {
        [dateLabel, weatherIconView, previewLabel].forEach { subStackView.addArrangedSubview($0) }
        [titleLabel, subStackView].forEach { totalStackView.addArrangedSubview($0) }
        contentView.addSubview(totalStackView)
    }

    private func configureLayout() {
        configureAccessories()
        configureHierarchy()
        dateLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

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
}
