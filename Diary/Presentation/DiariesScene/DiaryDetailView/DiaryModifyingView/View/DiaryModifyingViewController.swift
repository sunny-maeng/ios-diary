//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by 써니쿠키, LJ on 2022/12/21.
//

import UIKit

// MARK: - DiaryRegistrationViewController 상속
final class DiaryModifyingViewController: DiaryRegistrationViewController {

    private var viewModel: DiaryModifyingViewModel

    init(viewModel: DiaryModifyingViewModel) {
        self.viewModel = viewModel
        super.init(viewModel: DiaryRegistrationViewModel(diaryInfo: viewModel.diaryInfo))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        titleTextView.resignFirstResponder()
        configureDiary()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        updateDiary()
    }

    private func updateDiary() {
        viewModel.updateDiary(title: titleTextView.text, body: bodyTextView.text)
    }

    private func configureDiary() {
        titleTextView.text = viewModel.title
        titleTextView.textColor = .black
        bodyTextView.text = viewModel.body
        bodyTextView.textColor = .black
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()

        let alphaBarButtonItem = UIBarButtonItem(image: UIImage(systemName: viewModel.shareImageSystemName),
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(showActionSheet))

        self.navigationItem.rightBarButtonItem = alphaBarButtonItem
    }
}

extension DiaryModifyingViewController {

    @objc private func showActionSheet() {
        let actionSheet = UIAlertController()
        actionSheet.addAction(UIAlertAction(title: viewModel.actionSheetShareTitle,
                                            style: .default) { _ in
            self.showActivityView()
        })
        actionSheet.addAction(UIAlertAction(title: viewModel.actionSheetDeleteTitle,
                                            style: .destructive) { _ in
            self.showDeleteAlert()
        })
        actionSheet.addAction(UIAlertAction(title: viewModel.actionSheetCancelTitle,
                                            style: .cancel))

        self.present(actionSheet, animated: true)
    }

    private func showActivityView() {
        let activityItems = viewModel.generateActivityItems()
        let activityViewController = UIActivityViewController(activityItems: activityItems)

        self.present(activityViewController, animated: true)
    }

    private func showDeleteAlert() {
        let alertController = UIAlertController(title: viewModel.deleteAlertTitle,
                                                message: viewModel.deleteAlertMessage,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: viewModel.alertActionCancelTitle,
                                                style: .cancel))
        alertController.addAction(UIAlertAction(title: viewModel.alertActionOkTitle,
                                                style: .destructive) { [weak self] _ in
            self?.viewModel.deleteDiary()
            self?.navigationController?.popViewController(animated: true)
        })

        self.present(alertController, animated: true)
    }
}
