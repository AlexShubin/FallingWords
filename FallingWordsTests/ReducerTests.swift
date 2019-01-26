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
        // When
        let state = AppState.applyEvents(initial: .initial, events: [
            .roundsDataLoaded(TestData.roundsData),
            .answer(correct: true)
            ])
        // Then
        XCTAssertEqual(state.currentRound, AppState.initial.currentRound + 1)
    }

    func testInitialGameResultsAreEmpty() {
        XCTAssertEqual(AppState.initial.gameResults, GameResults.empty)
    }

    func testRightAnswerOnCorrectTranslationIncrementsResultsRightAnswer() {
        let state = AppState.applyEvents(initial: .initial, events: [
            .roundsDataLoaded([RoundData(questionWord: "", answerWord: "", isTranslationCorrect: true)]),
            .answer(correct: true)
            ])
        XCTAssertEqual(state.gameResults.rightAnswers, 1)
    }

    func testWrongAnswerOnWrongTranslationIncrementsResultRightAnswer() {
        let state = AppState.applyEvents(initial: .initial, events: [
            .roundsDataLoaded([RoundData(questionWord: "", answerWord: "", isTranslationCorrect: false)]),
            .answer(correct: false)
            ])
        XCTAssertEqual(state.gameResults.rightAnswers, 1)
    }

    func testRightAnswerOnWrongTranslationIncrementsResultsWrongAnswer() {
        let state = AppState.applyEvents(initial: .initial, events: [
            .roundsDataLoaded([RoundData(questionWord: "", answerWord: "", isTranslationCorrect: false)]),
            .answer(correct: true)
            ])
        XCTAssertEqual(state.gameResults.wrongAnswers, 1)
    }
}
