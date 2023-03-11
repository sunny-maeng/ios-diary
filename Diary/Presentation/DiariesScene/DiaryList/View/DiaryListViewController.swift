//
//  DiaryListViewController.swift
//  Created by 써니쿠키, LJ.
//  Copyright © 써니쿠키, LJ. All rights reserved.
//

import UIKit

final class DiaryListViewController: UIViewController, Alertable {

    private let viewModel: DiaryListViewModel
    private var diaryCollectionView: UICollectionView?
    private var dataSource: UICollectionViewDiffableDataSource<Section, DiaryInfo>?

    init(viewModel: DiaryListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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

        viewModel.error.bind { [weak self] error in
            if let error = error {
                self?.showError(error)
            }
        }
    }

    private func setUpViews() {
        viewModel.fetchDiaries()
    }

    private func showError(_ error: String) {
        showAlert(title: viewModel.errorTitle, message: error)
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
        let cellRegistration = UICollectionView.CellRegistration<DiaryCell, DiaryInfo> {
            [weak self] cell, _, diaryInfo in
            cell.configureCell(with: DiaryListCellViewModel(diaryInfo: diaryInfo))
            self?.viewModel.setupWeatherIcon(iconName: diaryInfo.weather?.icon ?? "") { data in
                cell.setupWeatherIconView(icon: UIImage(data: data))
            }
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
        collectionView.deselectItem(at: indexPath, animated: false)
        viewModel.showModifyingView(index: indexPath.item)
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
        viewModel.showRegisterView()
    }
}
