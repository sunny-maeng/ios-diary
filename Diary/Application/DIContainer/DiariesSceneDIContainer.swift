//
//  DiariesSceneDIContainer.swift
//  Diary
//
//  Created by 써니쿠키 on 2023/03/11.
//

import UIKit

final class DiariesSceneDIContainer: DiariesFlowCoordinatorDependencies {

    struct Dependencies {
        let locationManager: LocationManager
        let networkService: NetworkService
    }

    private let dependencies: Dependencies

    // MARK: - Storage
    let diaryCRUDStorage: DiaryCRUDStorage = CoreDataDiaryCRUDStorage()
    let weatherIconCacheStorage: CacheStorage = WeatherIconCache()
    lazy var weatherAPI: WeatherAPI = DefaultWeatherAPI(locationManager: dependencies.locationManager,
                                                         networkService: dependencies.networkService)

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    // MARK: - Use Cases
    func makeFetchDiariesUseCase() -> FetchDiariesUseCase {
        return DefaultFetchDiariesUseCase(diariesRepository: makeDiariesRepository())
    }

    func makeFetchWeatherUseCase() -> FetchWeatherUseCase {
        return DefaultFetchWeatherUseCase(weatherRepository: makeWeatherRepository())
    }

    func makeFetchWeatherIconUseCase() -> FetchWeatherIconUseCase {
        return DefaultFetchWeatherIconUseCase(weatherRepository: makeWeatherRepository())
    }

    func makeSaveDiaryUseCase() -> SaveDiaryUseCase {
        return DefaultSaveDiaryUseCase(diariesRepository: makeDiariesRepository())
    }

    func makeUpdateDiaryUseCase() -> UpdateDiaryUseCase {
        return DefaultUpdateDiaryUseCase(diariesRepository: makeDiariesRepository())
    }

    func makeDeleteDiaryUseCase() -> DeleteDiaryUseCase {
        return DefaultDeleteDiariesUseCase(diariesRepository: makeDiariesRepository())
    }

    // MARK: - Repositories
    func makeDiariesRepository() -> DiariesRepository {
        return DefaultDiariesRepository(diaryCRUDStorage: diaryCRUDStorage)
    }

    func makeWeatherRepository() -> WeatherRepository {
        return DefaultWeatherRepository(weatherAPI: weatherAPI, weatherIconCache: weatherIconCacheStorage)
    }

    // MARK: - Diaries List View
    func makeDiaryListViewController(showDetailViewAction: DiaryListViewModelShowDetailViewAction)
    -> DiaryListViewController {
        return DiaryListViewController(viewModel: makeDiaryListViewModel(showDetailViewAction: showDetailViewAction))
    }

    func makeDiaryListViewModel(showDetailViewAction: DiaryListViewModelShowDetailViewAction) -> DiaryListViewModel{
        return DiaryListViewModel(fetchDiariesUseCase: makeFetchDiariesUseCase(),
                                  deleteDiaryUseCase: makeDeleteDiaryUseCase(),
                                  fetchWeatherUseCase: makeFetchWeatherUseCase(),
                                  fetchWeatherIconUseCase: makeFetchWeatherIconUseCase(),
                                  showDetailViewAction: showDetailViewAction)
    }

    // MARK: - Diary Registration View
    func makeDiaryRegistrationViewController(diaryInfo: DiaryInfo) -> DiaryRegistrationViewController {
        return DiaryRegistrationViewController(viewModel: makeDiaryRegistrationViewModel(diaryInfo: diaryInfo))
    }

    func makeDiaryRegistrationViewModel(diaryInfo: DiaryInfo) -> DiaryRegistrationViewModel {
        return DiaryRegistrationViewModel(diaryInfo: diaryInfo,
                                          saveDiaryUseCase: makeSaveDiaryUseCase(),
                                          updateDiaryUseCase: makeUpdateDiaryUseCase())
    }

    // MARK: - Diary Modifying View
    func makeDiaryModifyingViewController(diaryInfo: DiaryInfo) -> DiaryModifyingViewController {
        return DiaryModifyingViewController(viewModel: makeDiaryModifyingViewModel(diaryInfo: diaryInfo),
                                            registeredViewModel: makeDiaryRegistrationViewModel(diaryInfo: diaryInfo))
    }

    func makeDiaryModifyingViewModel(diaryInfo: DiaryInfo) -> DiaryModifyingViewModel {
        return DiaryModifyingViewModel(diaryInfo: diaryInfo,
                                       updateDiaryUseCase: makeUpdateDiaryUseCase(),
                                       deleteDiaryUseCase: makeDeleteDiaryUseCase())
    }

    // MARK: - DiariesFlowCoordinator
    func makeDiariesFlowCoordinator(navigationController: UINavigationController) -> DiariesFlowCoordinator {
        return DiariesFlowCoordinator(navigationController: navigationController,
                                      dependencies: self)
        
    }
}
