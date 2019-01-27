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

    // MARK: - Load data event

    func testRoundsDataLoadedPutsDataIntoTheState() {
        // When
        let state = AppState.reduce(state: .initial, event: .roundsDataLoaded(TestData.roundsData))
        // Then
        XCTAssertEqual(state.roundsData, TestData.roundsData)
    }

    // MARK: - StartGame event

    func testGameIsNotStartedOnInitial() {
        XCTAssertFalse(AppState.initial.gameIsStarted)
    }

    func testStartGameSetsGameStartedFlag() {
        // When
        let state = AppState.reduce(state: .initial, event: .startGame)
        // Then
        XCTAssertTrue(state.gameIsStarted)
    }

    func testStartGameResetsWholeStateAfterRandomEvents() {
        // When
        let state = AppState.applyEvents(initial: .initial, events: [
            .roundsDataLoaded(TestData.roundsData),
            .answer(.right),
            .answer(.wrong),
            .startGame
            ])
        // Then
        var expectedState = AppState.initial
        expectedState.gameIsStarted = true
        XCTAssertEqual(state, expectedState)
    }

    // MARK: - Answer event

    func testAnswerIncrementsGameRound() {
        // When
        let state = AppState.applyEvents(initial: .initial, events: [
            .roundsDataLoaded(TestData.roundsData),
            .answer(.right)
            ])
        // Then
        XCTAssertEqual(state.currentRound, AppState.initial.currentRound + 1)
    }

    // MARK: - Game results calculation

    func testInitialGameResultsAreEmpty() {
        XCTAssertEqual(AppState.initial.gameResults, GameResults.empty)
    }

    func testRightAnswerOnCorrectTranslationIncrementsResultsRightAnswer() {
        let state = AppState.applyEvents(initial: .initial, events: [
            .roundsDataLoaded([RoundData(questionWord: "", answerWord: "", isTranslationCorrect: true)]),
            .answer(.right)
            ])
        XCTAssertEqual(state.gameResults.rightAnswers, 1)
    }

    func testWrongAnswerOnWrongTranslationIncrementsResultRightAnswer() {
        let state = AppState.applyEvents(initial: .initial, events: [
            .roundsDataLoaded([RoundData(questionWord: "", answerWord: "", isTranslationCorrect: false)]),
            .answer(.wrong)
            ])
        XCTAssertEqual(state.gameResults.rightAnswers, 1)
    }

    func testRightAnswerOnWrongTranslationIncrementsResultsWrongAnswer() {
        let state = AppState.applyEvents(initial: .initial, events: [
            .roundsDataLoaded([RoundData(questionWord: "", answerWord: "", isTranslationCorrect: false)]),
            .answer(.right)
            ])
        XCTAssertEqual(state.gameResults.wrongAnswers, 1)
    }

    func testWrongAnswerOnCorrectTranslationIncrementsResultsWrongAnswer() {
        let state = AppState.applyEvents(initial: .initial, events: [
            .roundsDataLoaded([RoundData(questionWord: "", answerWord: "", isTranslationCorrect: true)]),
            .answer(.wrong)
            ])
        XCTAssertEqual(state.gameResults.wrongAnswers, 1)
    }

    func testTimeOutEventIncrementsNoAnswers() {
        let state = AppState.applyEvents(initial: .initial, events: [
            .roundsDataLoaded([RoundData(questionWord: "", answerWord: "", isTranslationCorrect: true)]),
            .answer(.timeout)
            ])
        XCTAssertEqual(state.gameResults.noAnswers, 1)
    }

    // MARK: - Game finish condition

    func testGameFinishesWhenRoundsCountExceedsAvailableRoundCount() {
        var initial = AppState.initial
        initial.roundsCount = 2
        let state = AppState.applyEvents(initial: .initial, events: [
            .roundsDataLoaded(TestData.roundsData),
            .answer(.right),
            .answer(.wrong)
            ])
        XCTAssertFalse(state.gameIsStarted)
    }

    // MARK: - Close results events

    func testCloseResultsEventSetsShouldCloseResultInTheState() {
        let state = AppState.applyEvents(initial: .initial, events: [
            .closeResults
            ])
        XCTAssertTrue(state.shouldCloseResults)
    }
}
