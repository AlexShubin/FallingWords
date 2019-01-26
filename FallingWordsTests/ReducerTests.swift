//
//  ReducerTests.swift
//  FallingWordsTests
//
//  Created by Alex Shubin on 26/01/2019.
//  Copyright © 2019 AlexShubin. All rights reserved.
//

import XCTest
@testable import FallingWords

class ReducerTests: XCTestCase {

    func testRoundsDataLoadedPutsDataIntoTheState() {
        // When
        let state = AppState.reduce(state: .initial, event: .roundsDataLoaded(TestData.roundsData))
        // Then
        XCTAssertEqual(state.roundsData, TestData.roundsData)
    }

    func testGameIsNotStartedOnInitial() {
        XCTAssertFalse(AppState.initial.gameIsStarted)
    }

    func testStartGameSetsGameStartedFlag() {
        // When
        let state = AppState.reduce(state: .initial, event: .startGame)
        // Then
        XCTAssertTrue(state.gameIsStarted)
    }

    func testAnswerIncrementsGameRound() {
        // Given
        let initialRound = AppState.initial.currentRound
        // When
        let state = AppState.reduce(state: .initial, event: .answer(correct: true))
        // Then
        XCTAssertEqual(state.currentRound, initialRound + 1)
    }
}
