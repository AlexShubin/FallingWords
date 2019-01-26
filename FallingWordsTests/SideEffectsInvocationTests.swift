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

    func testProvidesRoundsDataOnInitialState() {
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
            Recorded.next(210, "provideShuffledRoundsData")
            ])
    }
}
