//
//  AppFlowCoordinator.swift
//  Diary
//
//  Created by 써니쿠키 on 2023/03/11.
//

import UIKit

final class AppFlowCoordinator {

    var navigationController: UINavigationController
    var appDIContainer: AppDIContainer

    init(navigationController: UINavigationController, appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }

    func start() {
        let diariesSceneDIContainer = appDIContainer.makeDiariesSceneDIContainer()
        let flow = diariesSceneDIContainer.makeDiariesFlowCoordinator(navigationController: navigationController)
        flow.start()
    }
}
