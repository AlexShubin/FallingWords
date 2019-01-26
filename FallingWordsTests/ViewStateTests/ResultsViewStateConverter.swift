//
//  ResultsViewStateConverter.swift
//  FallingWordsTests
//
//  Created by Alex Shubin on 26/01/2019.
//  Copyright © 2019 AlexShubin. All rights reserved.
//

import XCTest
@testable import FallingWords

class ResultsViewStateConverterTests: XCTestCase {
    func testResultsViewStateProperlyConverted() {
        // Given
        var state = AppState.initial
        state.gameResults = GameResults(rightAnswers: 1, wrongAnswers: 2, noAnswers: 3)
        // When
        let viewState = ResultsViewStateConverter().convert(from: state)
        // Then
        XCTAssertEqual(viewState,
                       ResultsViewState(rightAnswersText: L10n.ResultsScreen.rightAnswers(1),
                                        wrongAnswersText: L10n.ResultsScreen.rightAnswers(2),
                                        noAnswersText: L10n.ResultsScreen.rightAnswers(3)))
    }
}
