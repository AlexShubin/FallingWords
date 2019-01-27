//
//  GameViewController.swift
//  FallingWords
//
//  Created by Alex Shubin on 26/01/2019.
//  Copyright © 2019 AlexShubin. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxOptional

class GameViewController: UIViewController {

    let bag = DisposeBag()

    private let _converter: GameViewStateConverter

    private let _headerLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.GameScreen.header
        label.font = GameViewController.Constants.headerFont
        return label
    }()
    private let _wordLabel = UILabel()
    private let _floatingWordLabel = UILabel()
    private var _floatingWordTopConstraint: NSLayoutConstraint?
    private let _rightButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(L10n.GameScreen.rightButton, for: .normal)
        return button
    }()
    private let _wrongButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(L10n.GameScreen.wrongButton, for: .normal)
        return button
    }()
    private let _buttonsContainer = UIView(frame: .zero)

    init(converter: GameViewStateConverter) {
        _converter = converter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        _setupLabelsLayout()
        _setupButtonsLayout()

        view.backgroundColor = .white
        title = L10n.GameScreen.title
    }

    private func _setupLabelsLayout() {
        view.addSubview(_headerLabel)
        _headerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            _headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                              constant: Constants.margin)
            ])
        view.addSubview(_wordLabel)
        _wordLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _wordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            _wordLabel.topAnchor.constraint(equalTo: _headerLabel.bottomAnchor, constant: Constants.margin)
            ])
        view.addSubview(_floatingWordLabel)
        _floatingWordLabel.translatesAutoresizingMaskIntoConstraints = false
        _floatingWordTopConstraint = _floatingWordLabel.topAnchor.constraint(equalTo: _wordLabel.bottomAnchor,
                                                                             constant: Constants.margin)
        NSLayoutConstraint.activate([
            _floatingWordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            _floatingWordTopConstraint!
            ])
    }

    private func _setupButtonsLayout() {
        view.addSubview(_buttonsContainer)
        _buttonsContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _buttonsContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                       constant: Constants.margin),
            _buttonsContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                        constant: -Constants.margin),
            _buttonsContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                      constant: -Constants.margin)
            ])
        _buttonsContainer.addSubview(_rightButton)
        _rightButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _rightButton.leadingAnchor.constraint(equalTo: _buttonsContainer.leadingAnchor,
                                                  constant: Constants.margin),
            _rightButton.bottomAnchor.constraint(equalTo: _buttonsContainer.bottomAnchor,
                                                 constant: -Constants.margin),
            _rightButton.topAnchor.constraint(equalTo: _buttonsContainer.topAnchor,
                                              constant: Constants.margin)
            ])
        _buttonsContainer.addSubview(_wrongButton)
        _wrongButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _wrongButton.trailingAnchor.constraint(equalTo: _buttonsContainer.trailingAnchor,
                                                   constant: -Constants.margin),
            _wrongButton.bottomAnchor.constraint(equalTo: _buttonsContainer.bottomAnchor,
                                                 constant: -Constants.margin),
            _wrongButton.topAnchor.constraint(equalTo: _buttonsContainer.topAnchor,
                                              constant: Constants.margin)
            ])
    }

    func render(with state: GameViewState) {
        _wordLabel.text = state.questionWord
        _floatingWordLabel.text = state.answerWord
        _animateRendering(with: state.animationDuration)
    }

    private func _animateRendering(with duration: TimeInterval) {
        _floatingWordLabel.layer.removeAllAnimations()
        _floatingWordTopConstraint?.constant = Constants.margin
        view.layoutIfNeeded()
        // Height between top label and bottom buttons
        let animationShift = _buttonsContainer.frame.origin.y - _floatingWordLabel.frame.origin.y
        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: [],
            animations: { [weak self] in
                self?._floatingWordTopConstraint?.constant = animationShift
                self?.view.layoutIfNeeded()
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2, animations: {
                    self?._floatingWordLabel.alpha = 1
                })
                UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.2, animations: {
                    self?._floatingWordLabel.alpha = 0
                })
            }
        )
    }
}

// MARK: - StateStoreBindable
extension GameViewController: StateStoreBindable {
    func subscribe(to stateStore: AppStateStore) {
        // State to view state conversion
        let viewState: Signal<GameViewState> = stateStore
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
        _rightButton.rx.tap
            .map { .answer(.right) }
            .bind(to: stateStore.eventBus)
            .disposed(by: bag)
        _wrongButton.rx.tap
            .map { .answer(.wrong) }
            .bind(to: stateStore.eventBus)
            .disposed(by: bag)
    }
}

// MARK: - Costants
extension GameViewController {
    enum Constants {
        static let margin: CGFloat = 24
        static let headerFont = UIFont.boldSystemFont(ofSize: 26)
    }
}
