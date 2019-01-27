//
//  ResultsViewController.swift
//  FallingWords
//
//  Created by Alex Shubin on 26/01/2019.
//  Copyright © 2019 AlexShubin. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxOptional

class ResultsViewController: UIViewController {

    let bag = DisposeBag()

    private let _converter: ResultsViewStateConverter

    private let _headerLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.ResultsScreen.header
        label.font = Constants.headerFont
        return label
    }()
    private let _rightAnswersLabel = UILabel()
    private let _wrongAnswersLabel = UILabel()
    private let _noAnswersLabel = UILabel()
    private let _restartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(L10n.ResultsScreen.restartButton, for: .normal)
        return button
    }()

    init(converter: ResultsViewStateConverter) {
        _converter = converter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        _setupLayout()

        view.backgroundColor = .white
        title = L10n.ResultsScreen.title
        navigationItem.leftBarButtonItem = UIBarButtonItem()
    }

    private func _setupLayout() {
        let stack = UIStackView(arrangedSubviews: [
            _headerLabel,
            _rightAnswersLabel,
            _wrongAnswersLabel,
            _noAnswersLabel,
            _restartButton
            ]
        )
        stack.spacing = Constants.margin
        stack.axis = .vertical
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .center
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                       constant: Constants.margin)
            ])
    }

    func render(with state: ResultsViewState) {
        _rightAnswersLabel.text = state.rightAnswersText
        _wrongAnswersLabel.text = state.wrongAnswersText
        _noAnswersLabel.text = state.noAnswersText
    }
}

// MARK: - StateStoreBindable
extension ResultsViewController: StateStoreBindable {
    func subscribe(to stateStore: AppStateStore) {
        // State to view state conversion
        let viewState: Signal<ResultsViewState> = stateStore
            .stateBus
            .distinctUntilChanged()
            .map { [weak self] in
                self?._converter.convert(from: $0)
            }.filterNil()
        // State render
        viewState
            .emit(onNext: { [weak self] in
                self?.render(with: $0)
            })
            .disposed(by: bag)
        // UI Events
        _restartButton.rx.tap
            .flatMap { Observable.of(.closeResults, .startGame) }
            .bind(to: stateStore.eventBus)
            .disposed(by: bag)
    }
}

// MARK: - Costants
extension ResultsViewController {
    enum Constants {
        static let margin: CGFloat = 24
        static let headerFont = UIFont.boldSystemFont(ofSize: 26)
    }
}
