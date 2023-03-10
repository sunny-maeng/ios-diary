//
//  DiaryListViewModel.swift
//  Diary
//
//  Created by 써니쿠키 on 2023/03/07.
//

import Foundation

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

    init(fetchDiariesUseCase: FetchDiariesUseCase = DefaultFetchDiaryUseCase(),
         deleteDiaryUseCase: DeleteDiaryUseCase = DefaultDeleteDiariesUseCase(),
         fetchWeatherUseCase: FetchWeatherUseCase = DefaultFetchWeatherUseCase()) {
        self.fetchDiariesUseCase = fetchDiariesUseCase
        self.deleteDiaryUseCase = deleteDiaryUseCase
        self.fetchWeatherUseCase = fetchWeatherUseCase
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

    func diaryInIndex(_ index: Int) -> DiaryInfo {
        return diaries.value[index]
    }

    func deleteDiary(index: Int) {
        deleteDiaryUseCase.delete(diaryInfo: diaries.value[index])
        diaries.value.remove(at: index)
    }

    func generateNewDiary(handler: @escaping (DiaryInfo) -> Void) {
        var diary = DiaryInfo(title: Constant.empty, body: Constant.empty, createdAt: Date(), weather: nil, id: UUID())

        fetchWeatherUseCase.fetchWeather { result in
            switch result {
            case .success(let weatherInfo):
                diary.weather = weatherInfo
                handler(diary)
            case .failure:
                handler(diary)
            }
        }
    }

    func generateActivityItemsOfDiary(index: Int) -> [String] {
        let diary = diaryInIndex(index)
        let title = diary.title
        let body = diary.body
        return [title, body]
    }
}

extension DiaryListViewModel {

    private enum Constant {
        static let empty = ""
    }
}
