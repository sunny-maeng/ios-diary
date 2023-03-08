//
//  DiaryModifyingViewModel.swift
//  Diary
//
//  Created by 써니쿠키 on 2023/03/07.
//

import Foundation

struct DiaryModifyingViewModel {

    private(set) var diaryInfo: DiaryInfo {
        didSet {
            updateDiaryUseCase.update(diaryInfo: diaryInfo)
        }
    }

    var title: String { return diaryInfo.title }
    var body: String { return diaryInfo.body }
    let titlePlaceHolder: String = "일기 제목"
    let bodyPlaceHolder: String = "일기 내용"
    let actionSheetShareTitle = "Share"
    let actionSheetDeleteTitle = "Delete"
    let actionSheetCancelTitle = "Cancel"
    let shareImageSystemName = "square.and.arrow.up"
    let deleteAlertTitle = "진짜요?"
    let deleteAlertMessage = "정말로 삭제하시겠어요?"
    let alertActionCancelTitle = "취소"
    let alertActionOkTitle = "삭제"

    private let updateDiaryUseCase: UpdateDiaryUseCase
    private let deleteDiaryUseCase: DeleteDiaryUseCase

    init(diaryInfo: DiaryInfo,
         updateDiaryUseCase: UpdateDiaryUseCase = DefaultUpdateDiaryUseCase(),
         deleteDiaryUseCase: DeleteDiaryUseCase = DefaultDeleteDiariesUseCase()) {
        self.diaryInfo = diaryInfo
        self.updateDiaryUseCase = updateDiaryUseCase
        self.deleteDiaryUseCase = deleteDiaryUseCase
    }

    mutating func updateDiary(title: String, body: String) {
        diaryInfo.title = title
        diaryInfo.body = body
        updateDiaryUseCase.update(diaryInfo: diaryInfo)
    }

    func deleteDiary() {
        deleteDiaryUseCase.delete(diaryInfo: diaryInfo)
    }

    func generateActivityItems() -> [String] {
        return [title, body]
    }
}
