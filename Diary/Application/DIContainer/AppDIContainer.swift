//
//  AppDIContainer.swift
//  Diary
//
//  Created by 써니쿠키 on 2023/03/11.
//

import Foundation

final class AppDIContainer {

    // MARK: - LocationManager, Network
    let locationManager: LocationManager = DefaultLocationManager()
    let networkService: NetworkService = DefaultNetworkService()

    func makeDiariesSceneDIContainer() -> DiariesSceneDIContainer {
        return DiariesSceneDIContainer(dependencies: DiariesSceneDIContainer.Dependencies(
            locationManager: locationManager, networkService: networkService))
    }
}
