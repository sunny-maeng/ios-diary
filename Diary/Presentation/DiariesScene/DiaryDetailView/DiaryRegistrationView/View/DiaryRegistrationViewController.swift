//
//  RegisterDiaryViewController.swift
//  Diary
//
//  Created by 써니쿠키, LJ on 2022/12/21.
//

import UIKit

class DiaryRegistrationViewController: UIViewController {

    private var viewModel: DiaryRegistrationViewModel

    let titleTextView = UITextView(font: .title1)
    let bodyTextView = UITextView(font: .body)

    private let titlePlaceHolder = UILabel(textColor: .systemGray2, font: .title1)
    private let bodyPlaceHolder = UILabel(textColor: .systemGray2, font: .body)

    private let diaryTextScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.keyboardDismissMode = .interactive
        scrollView.alwaysBounceVertical = true

        return scrollView
    }()

    private let diaryTextStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()

    init(viewModel: DiaryRegistrationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        configureLayout()
        addTextViewsDelegate()
        setupNavigationBar()
        setupNotification()
        viewModel.saveDiary()
        titleTextView.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupPlaceHolder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        updateDiary()
    }

    @objc private func updateDiary() {
        viewModel.updateDiary(title: titleTextView.text, body: bodyTextView.text)
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = viewModel.navigationTitle
    }
}

// MARK: - ViewHierarchy & layout
extension DiaryRegistrationViewController {

    private func configureViewHierarchy() {
        [titleTextView, bodyTextView].forEach { diaryTextStackView.addArrangedSubview($0) }
        diaryTextScrollView.addSubview(diaryTextStackView)
        self.view.addSubview(diaryTextScrollView)
    }

    private func configureLayout() {
        configureViewHierarchy()
        let readableGuide = view.readableContentGuide

        NSLayoutConstraint.activate([
            diaryTextScrollView.frameLayoutGuide.leadingAnchor.constraint(equalTo: readableGuide.leadingAnchor),
            diaryTextScrollView.frameLayoutGuide.trailingAnchor.constraint(equalTo: readableGuide.trailingAnchor),
            diaryTextScrollView.frameLayoutGuide.topAnchor.constraint(equalTo: readableGuide.topAnchor),
            diaryTextScrollView.frameLayoutGuide.bottomAnchor.constraint(equalTo: readableGuide.bottomAnchor),
            diaryTextScrollView.contentLayoutGuide.widthAnchor.constraint(
                equalTo: diaryTextScrollView.frameLayoutGuide.widthAnchor),

            diaryTextStackView.widthAnchor.constraint(equalTo: diaryTextScrollView.contentLayoutGuide.widthAnchor),
            diaryTextStackView.heightAnchor.constraint(equalTo: diaryTextScrollView.contentLayoutGuide.heightAnchor)
        ])
    }
}

// MARK: - Keyboard Handling
extension DiaryRegistrationViewController {
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(controlKeyboard),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(controlKeyboard),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateDiary),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
    }
    
    @objc private func controlKeyboard(_ notification: NSNotification) {
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
                as? NSValue else { return }
    
        let keyboardHeight = keyboardFrame.cgRectValue.height
        diaryTextScrollView.contentInset.bottom = keyboardHeight
    }
}

// MARK: - PlaceHolder
extension DiaryRegistrationViewController: UITextViewDelegate {

    func addTextViewsDelegate() {
        titleTextView.delegate = self
        bodyTextView.delegate = self
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        setupPlaceHolder()
    }

    func textViewDidChange(_ textView: UITextView) {
        removePlaceHolder()
    }

    private func setupPlaceHolder() {
        if titleTextView.text == Constant.empty {
            titleTextView.addSubview(titlePlaceHolder)
            titlePlaceHolder.text = viewModel.titlePlaceHolder

            NSLayoutConstraint.activate([
                titlePlaceHolder.leadingAnchor.constraint(equalTo: titleTextView.frameLayoutGuide.leadingAnchor,
                                                          constant: 7),
                titlePlaceHolder.trailingAnchor.constraint(equalTo: titleTextView.frameLayoutGuide.trailingAnchor),
                titlePlaceHolder.heightAnchor.constraint(equalTo: titleTextView.frameLayoutGuide.heightAnchor)
            ])
        }

        if bodyTextView.text == Constant.empty {
            bodyTextView.addSubview(bodyPlaceHolder)
            bodyPlaceHolder.text = viewModel.bodyPlaceHolder

            NSLayoutConstraint.activate([
                bodyPlaceHolder.leadingAnchor.constraint(equalTo: bodyTextView.frameLayoutGuide.leadingAnchor,
                                                         constant: 7),
                bodyPlaceHolder.trailingAnchor.constraint(equalTo: bodyTextView.frameLayoutGuide.trailingAnchor),
                bodyPlaceHolder.heightAnchor.constraint(equalTo: bodyTextView.frameLayoutGuide.heightAnchor)
            ])
        }
    }

    private func removePlaceHolder() {
        if titleTextView.text != Constant.empty {
            titlePlaceHolder.removeFromSuperview()
        }

        if bodyTextView.text != Constant.empty {
            bodyPlaceHolder.removeFromSuperview()
        }
    }
}

extension DiaryRegistrationViewController {

    private enum Constant {
        static let empty = ""
    }
}
