//
//  DiaryListViewModel.swift
//  Diary
//
//  Created by 써니쿠키 on 2023/03/07.
//

import Foundation

struct DiaryListViewModelShowDetailViewAction {
    let showRegisterView: (DiaryInfo) -> Void
    let showModifyingView: (DiaryInfo) -> Void
}

final class DiaryListViewModel {

    var diaries: Observable<[DiaryInfo]> = Observable([])
    var error: Observable<String?> = Observable(nil)
    let errorTitle = "Error"
    let navigationTitle = "일기장"
    let deleteActionTitle = "delete"
    let shareActionTitle = "share"
    let barButtonTitle = "+"
    let shareImageSystemName = "square.and.arrow.up"

    private let fetchDiariesUseCase: FetchDiariesUseCase
    private let deleteDiaryUseCase: DeleteDiaryUseCase
    private let fetchWeatherUseCase: FetchWeatherUseCase
    private let fetchWeatherIconUseCase: FetchWeatherIconUseCase
    private let showDetailViewAction: DiaryListViewModelShowDetailViewAction

    init(fetchDiariesUseCase: FetchDiariesUseCase,
         deleteDiaryUseCase: DeleteDiaryUseCase,
         fetchWeatherUseCase: FetchWeatherUseCase,
         fetchWeatherIconUseCase: FetchWeatherIconUseCase,
         showDetailViewAction: DiaryListViewModelShowDetailViewAction) {
        self.fetchDiariesUseCase = fetchDiariesUseCase
        self.deleteDiaryUseCase = deleteDiaryUseCase
        self.fetchWeatherUseCase = fetchWeatherUseCase
        self.fetchWeatherIconUseCase = fetchWeatherIconUseCase
        self.showDetailViewAction = showDetailViewAction
    }

    func fetchDiaries() {
        fetchDiariesUseCase.fetch { [weak self] result in
            switch result {
            case .success(let fetchedDiaries):
                self?.diaries.value = fetchedDiaries
            case .failure:
                self?.error.value = "Failed loading diaries"
            }
        }
    }

    func setupWeatherIcon(iconName: String, completionHandler: @escaping (Data) -> Void) {
        fetchWeatherIconUseCase.fetchWeatherIcon(iconName: iconName) { result in
            if case let .success(data) = result {
                completionHandler(data)
            }
        }
    }

    func deleteDiary(index: Int) {
        deleteDiaryUseCase.delete(diaryInfo: diaries.value[index])
        diaries.value.remove(at: index)
    }

    func generateActivityItemsOfDiary(index: Int) -> [String] {
        let diary = diaries.value[index]
        let title = diary.title
        let body = diary.body
        return [title, body]
    }

    func showRegisterView() {
        generateNewDiary { [weak self] newDiary in
            self?.showDetailViewAction.showRegisterView(newDiary)
        }
    }

    func showModifyingView(index: Int) {
        showDetailViewAction.showModifyingView(diaries.value[index])
    }

    private func generateNewDiary(handler: @escaping (DiaryInfo) -> Void) {
        var diaryInfo = DiaryInfo(title: Constant.empty, body: Constant.empty, createdAt: Date(), weather: nil, id: UUID())
        fetchWeatherUseCase.fetchWeather { result in
            switch result {
            case .success(let weatherInfo):
                diaryInfo.weather = weatherInfo
                handler(diaryInfo)
            case .failure:
                handler(diaryInfo)
            }
        }
    }
}

extension DiaryListViewModel {

    private enum Constant {
        static let empty = ""
    }
}
