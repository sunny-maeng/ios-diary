//
//  DiaryListViewController.swift
//  Created by 써니쿠키, LJ.
//  Copyright © 써니쿠키, LJ. All rights reserved.
//

import UIKit

final class DiaryListViewController: UIViewController {

    private let viewModel: DiaryListViewModel = DiaryListViewModel() // ⭐️ DIC추후구현

    private var diaryCollectionView: UICollectionView?
    private var dataSource: UICollectionViewDiffableDataSource<Section, DiaryInfo>?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        configureDiaryCollectionView()
        configureLayout()
        configureDiaryListDataSource()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpViews()
    }

    private func bindViewModel() {
        viewModel.diaries.bind { [weak self] diaries in
            self?.snapShot(diaries: diaries)
        }
    }
    
    private func setUpViews() {
        viewModel.fetchDiaries()
    }
}

// MARK: - ViewHierarchy & layout
extension DiaryListViewController {

    private func createDiaryCollectionViewLayout() -> UICollectionViewLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.trailingSwipeActionsConfigurationProvider = { indexPath in
            return self.configureSwipeActions(indexPath: indexPath)
        }

        return UICollectionViewCompositionalLayout.list(using: config)
    }

    private func configureDiaryCollectionView() {
        diaryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createDiaryCollectionViewLayout())
        diaryCollectionView?.delegate = self
    }

    private func configureLayout() {
        guard let diaryCollectionView = diaryCollectionView else { return }

        self.view.addSubview(diaryCollectionView)
        diaryCollectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            diaryCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            diaryCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            diaryCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            diaryCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - collectionView DataSource
extension DiaryListViewController {

    private enum Section {
        case main
    }
    
    private func configureDiaryListDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<DiaryCell, DiaryInfo> { cell, _, diaryInfo in
            let cellViewModel = DiaryListCellViewModel(diaryInfo: diaryInfo)
            cell.configureCell(with: cellViewModel)
        }

        guard let diaryCollectionView = diaryCollectionView else { return }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: diaryCollectionView) {
            collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
    }
    
    private func snapShot(diaries: [DiaryInfo]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, DiaryInfo>()
        snapshot.deleteAllItems()
        snapshot.appendSections([.main])
        snapshot.appendItems(diaries)
        dataSource?.apply(snapshot)
    }
}

// MARK: - UICollectionViewDelegate
extension DiaryListViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let diaryInfo = viewModel.diaryInIndex(indexPath.item)
        let detailViewController = DiaryDetailViewController(diaryInfo: diaryInfo)

        collectionView.deselectItem(at: indexPath, animated: false)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

// MARK: - CellSwipeAction
extension DiaryListViewController {

    func configureSwipeActions(indexPath: IndexPath) -> UISwipeActionsConfiguration {
        let deleteAction = UIContextualAction(style: .destructive,
                                              title: viewModel.deleteActionTitle) { [weak self] _, _, _ in
            self?.viewModel.deleteDiary(index: indexPath.item)
        }

        let shareAction = UIContextualAction(style: .normal,
                                             title: viewModel.shareActionTitle) { [weak self] _, _, handler in
            guard let self = self else { return }
            let activityItems = self.viewModel.generateActivityItemsOfDiary(index: indexPath.item)
            let activityViewController = UIActivityViewController(activityItems: activityItems)

            self.present(activityViewController, animated: true)
            handler(true)
        }

        shareAction.backgroundColor = .systemBlue
        shareAction.image = UIImage(systemName: viewModel.shareImageSystemName)

        return UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
    }
}

// MARK: - NavigationBar
extension DiaryListViewController {
    
    private func setupNavigationBar() {
        self.navigationItem.title = viewModel.navigationTitle
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemBackground
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        let addBarButtonItem = UIBarButtonItem(title: viewModel.barButtonTitle,
                                               style: .plain,
                                               target: self,
                                               action: #selector(registerDiary))
        
        self.navigationItem.rightBarButtonItem = addBarButtonItem
    }
    
    @objc private func registerDiary() {
        viewModel.generateNewDiary { newDiary in
            let registerDiaryViewController = RegisterDiaryViewController(diaryInfo: newDiary)
            self.navigationController?.pushViewController(registerDiaryViewController, animated: true)
        }
    }
}
