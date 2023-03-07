//
//  DiaryListViewController.swift
//  Created by 써니쿠키, LJ.
//  Copyright © 써니쿠키, LJ. All rights reserved.
//

import UIKit

final class DiaryListViewController: UIViewController {
    
    private var diaryListView: DiaryListView?
    private var dataSource: UICollectionViewDiffableDataSource<Section, DiaryInfo>?
    private var diary: [DiaryInfo] = []
    private let weatherRepository: WeatherRepository = DefaultWeatherRepository()

    override func viewDidLoad() {
        super.viewDidLoad()
        diaryListView = DiaryListView()
        self.view = diaryListView
        setupNavigationBar()
        diaryListView?.diaryList?.delegate = self
        diaryListView?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        convertDiaryData()
        configureDiaryListDataSource()
        snapShot()
    }
    
    private func convertDiaryData() {
        CoreDataDiaryCRUDStorage().fetchDiaries { [weak self] result in
            switch result {
            case .success(let diaries):
                self?.diary = diaries
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func configureDiaryListDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<DiaryCell, DiaryInfo> {
            cell, _, diaryInfo in
            
            cell.configureCell(title: diaryInfo.title,
                               date: diaryInfo.createdDate,
                               preview: diaryInfo.body)
            
            guard let diaryInfoWeather = diaryInfo.weather else {
                return
            }
            
            let cacheKey = NSString(string: diaryInfoWeather.icon)
            if let cachedImage: UIImage = ImageCacheManager.shared.object(forKey: cacheKey) {
                cell.configureWeatherIcon(weatherIcon: cachedImage)
            } else {
                self.weatherRepository.fetchWeatherIcon(iconName: diaryInfoWeather.icon) { result in
                    switch result {
                    case .success(let data):
                        guard let weatherIcon = UIImage(data: data) else { return }
                        cell.configureWeatherIcon(weatherIcon: weatherIcon)
                        ImageCacheManager.shared.setObject(weatherIcon, forKey: cacheKey)
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }

        guard let diaryListView = diaryListView,
            let diaryListView = diaryListView.diaryList else {
            return
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: diaryListView,
                                                        cellProvider: {
            collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                         for: indexPath,
                                                         item: itemIdentifier)
        })
    }
    
    private func snapShot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, DiaryInfo>()
        snapshot.appendSections([.main])
        snapshot.appendItems(diary)
        dataSource?.apply(snapshot)
    }
}

extension DiaryListViewController {
    
    private enum Section {
        case main
    }
}

extension DiaryListViewController {
    
    private func setupNavigationBar() {
        self.navigationItem.title = Constant.navigationTitle
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemBackground
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        let addBarButtonItem = UIBarButtonItem(title: Constant.barButtonTitle,
                                               style: .plain,
                                               target: self,
                                               action: #selector(registerDiary))
        
        self.navigationItem.rightBarButtonItem = addBarButtonItem
    }
    
    @objc private func registerDiary() {
        weatherRepository.fetchWeatherInfo { (result: Result<WeatherInfo, Error>) in
            switch result {
            case .success(let weatherInfo):
                let registerDiaryViewController = RegisterDiaryViewController(
                                    diaryInfo: DiaryInfo(title: Constant.empty,
                                                         body: Constant.empty,
                                                         createdAt: Date(),
                                                         weather: weatherInfo))

                self.navigationController?.pushViewController(registerDiaryViewController, animated: true)
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension DiaryListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = DiaryDetailViewController(diaryInfo: diary[indexPath.item])
        
        collectionView.deselectItem(at: indexPath, animated: false)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension DiaryListViewController: DiaryListViewDelegate {
    
    func configureSwipeActions(indexPath: IndexPath) -> UISwipeActionsConfiguration {
        let deleteAction = UIContextualAction(style: .destructive,
                                              title: Constant.deleteActionTitle) {
            _, _, handler in
            CoreDataDiaryCRUDStorage().delete(self.diary[indexPath.item])
            guard let dataSource = self.dataSource,
                  let id = dataSource.itemIdentifier(for: indexPath) else {
                return
            }
            
            var currentData = dataSource.snapshot()
            currentData.deleteItems([id])
            dataSource.apply(currentData)
            handler(true)
        }
        
        let shareAction = UIContextualAction(style: .normal,
                                             title: Constant.shareActionTitle) {
            _, _, handler in
            let title = self.diary[indexPath.item].title
            let body = self.diary[indexPath.item].body
            let activityViewController = CustomActivityViewController(activityItems: [title, body])
        
            self.present(activityViewController, animated: true)
            handler(true)
        }
        
        shareAction.backgroundColor = .systemBlue
        shareAction.image = UIImage(systemName: Constant.shareIcon)
        
        return UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
    }
}

extension DiaryListViewController {
    
    private enum Constant {
        static let navigationTitle = "일기장"
        static let barButtonTitle = "+"
        static let deleteActionTitle = "delete"
        static let shareActionTitle = "share"
        static let shareIcon = "square.and.arrow.up"
        static let empty = ""
    }
}