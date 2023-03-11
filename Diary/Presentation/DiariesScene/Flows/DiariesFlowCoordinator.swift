//
//  DiariesFlowCoordinator.swift
//  Diary
//
//  Created by 써니쿠키 on 2023/03/11.
//

import UIKit

protocol DiariesFlowCoordinatorDependencies {

    func makeDiaryListViewController(showDetailViewAction: DiaryListViewModelShowDetailViewAction)
    -> DiaryListViewController
    func makeDiaryRegistrationViewController(diaryInfo: DiaryInfo) -> DiaryRegistrationViewController
    func makeDiaryModifyingViewController(diaryInfo: DiaryInfo) -> DiaryModifyingViewController
}

final class DiariesFlowCoordinator {

    private weak var navigationController: UINavigationController?
    private let dependencies: DiariesFlowCoordinatorDependencies

    private weak var diaryListVC: DiaryListViewController?

    init(navigationController: UINavigationController,
         dependencies: DiariesFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    func start() {
        let action = DiaryListViewModelShowDetailViewAction(showRegisterView: showRegisterView,
                                                            showModifyingView: showModifyingView)
        let diaryListViewController = dependencies.makeDiaryListViewController(showDetailViewAction: action)

        navigationController?.pushViewController(diaryListViewController, animated: false)
        diaryListVC = diaryListViewController
    }

    private func showRegisterView(diaryInfo: DiaryInfo) {
        let diaryRegisterViewController = dependencies.makeDiaryRegistrationViewController(diaryInfo: diaryInfo)
        navigationController?.pushViewController(diaryRegisterViewController, animated: true)
    }

    private func showModifyingView(diaryInfo: DiaryInfo) {
        let diaryModifyingViewController = dependencies.makeDiaryModifyingViewController(diaryInfo: diaryInfo)
        navigationController?.pushViewController(diaryModifyingViewController, animated: true)
    }
}
