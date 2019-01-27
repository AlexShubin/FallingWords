//
//  SideEffectsInvocationTests.swift
//  FallingWordsTests
//
//  Created by Alex Shubin on 26/01/2019.
//  Copyright © 2019 AlexShubin. All rights reserved.
//

@testable import FallingWords
import XCTest
import RxTest
import RxSwift

class SideEffectsInvocationTests: XCTestCase {

    let sideEffectsMock = SideEffectsMock()
    let testScheduler = TestScheduler(initialClock: 0)
    let bag = DisposeBag()

    var stateStore: AppStateStore!

    override func setUp() {
        super.setUp()
        stateStore = AppStateStore(sideEffects: sideEffectsMock, scheduler: testScheduler)
    }

    func testProvidesRoundsDataOnStartGameAndStartsTheTimer() {
        // Given
        let effectsObserver = testScheduler.createObserver(String.self)
        testScheduler.createColdObservable([
            Recorded.next(210, .startGame)
            ])
            .bind(to: stateStore.eventBus)
            .disposed(by: bag)
        sideEffectsMock.effects
            .subscribe(effectsObserver)
            .disposed(by: bag)
        // When
        _ = testScheduler.start { [unowned self] in
            self.stateStore.stateBus.asObservable()
        }
        // Then
        XCTAssertEqual(effectsObserver.events, [
            Recorded.next(210, "provideShuffledRoundsData"),
            Recorded.next(210, "turnOnTimer")
            ])
    }

    func testShowsResultWhenMaximumRoundsCountAchieved() {
        // Given
        var state = AppState.initial
        state.roundsCount = 3
        stateStore = AppStateStore(sideEffects: sideEffectsMock, scheduler: testScheduler, initialState: state)
        let effectsObserver = testScheduler.createObserver(String.self)
        testScheduler.createColdObservable([
            Recorded.next(220, .roundsDataLoaded(TestData.roundsData)),
            Recorded.next(230, .answer(.right)),
            Recorded.next(240, .answer(.right)),
            Recorded.next(250, .answer(.right))
            ])
            .bind(to: stateStore.eventBus)
            .disposed(by: bag)
        sideEffectsMock.effects
            .subscribe(effectsObserver)
            .disposed(by: bag)
        // When
        _ = testScheduler.start { [unowned self] in
            self.stateStore.stateBus.asObservable()
        }
        // Then
        XCTAssertEqual(effectsObserver.events, [
            Recorded.next(250, "showResults")
            ])
    }

    func testFiresTimerOnTurnOnTimerEvent() {
        // Given
        let effectsObserver = testScheduler.createObserver(String.self)
        testScheduler.createColdObservable([
            Recorded.next(220, .turnOnTimer)
            ])
            .bind(to: stateStore.eventBus)
            .disposed(by: bag)
        sideEffectsMock.effects
            .subscribe(effectsObserver)
            .disposed(by: bag)
        // When
        _ = testScheduler.start { [unowned self] in
            self.stateStore.stateBus.asObservable()
        }
        // Then
        XCTAssertEqual(effectsObserver.events, [
            Recorded.next(220, "fireTimer")
            ])
    }

    func testCloseResultsInvokedOnCloseResultsEvent() {
        // Given
        let effectsObserver = testScheduler.createObserver(String.self)
        testScheduler.createColdObservable([
            Recorded.next(220, .closeResults)
            ])
            .bind(to: stateStore.eventBus)
            .disposed(by: bag)
        sideEffectsMock.effects
            .subscribe(effectsObserver)
            .disposed(by: bag)
        // When
        _ = testScheduler.start { [unowned self] in
            self.stateStore.stateBus.asObservable()
        }
        // Then
        XCTAssertEqual(effectsObserver.events, [
            Recorded.next(220, "closeResults")
            ])
    }
}
