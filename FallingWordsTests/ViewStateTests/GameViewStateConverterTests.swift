//
//  GameViewStateConverterTests.swift
//  FallingWordsTests
//
//  Created by Alex Shubin on 26/01/2019.
//  Copyright © 2019 AlexShubin. All rights reserved.
//

import XCTest
@testable import FallingWords

class GameViewStateConverterTests: XCTestCase {

    func testConvertedToEmptyStateFromIntialAppState() {
        let state = GameViewStateConverter().convert(from: AppState.initial)
        XCTAssertEqual(state, GameViewState.empty)
    }

    func testQuestionWordConverted() {
        // Given
        let appState = AppState.reduce(state: .initial, event: .roundsDataLoaded([TestData.roundData1]))
        // When
        let state = GameViewStateConverter().convert(from: appState)
        // Then
        XCTAssertEqual(state.questionWord, TestData.roundData1.questionWord)
    }

    func testAnswerWordConverted() {
        // Given
        let appState = AppState.reduce(state: .initial, event: .roundsDataLoaded([TestData.roundData1]))
        // When
        let state = GameViewStateConverter().convert(from: appState)
        // Then
        XCTAssertEqual(state.answerWord, TestData.roundData1.answerWord)
    }

    func testAnimationDurationConverted() {
        // Given
        let appState = AppState.reduce(state: .initial, event: .roundsDataLoaded([TestData.roundData1]))
        // When
        let state = GameViewStateConverter().convert(from: appState)
        // Then
        XCTAssertEqual(state.animationDuration, appState.roundDuration)
    }
}
