//
//  RoundsDataProviderTests.swift
//  FallingWordsTests
//
//  Created by Alex Shubin on 26/01/2019.
//  Copyright © 2019 AlexShubin. All rights reserved.
//

import XCTest
@testable import FallingWords

class RoundsDataProviderTests: XCTestCase {

    func testShuffledProvider_returnsNecessaryCountOfUniqueQuestionWords() {
        // Given
        let roundsProvider = RoundsDataProvider.makeShuffledProvider(with:
            TranslatedWordsLoader(load: { TestData.translatedWords })
        )
        // When
        let roundsData = roundsProvider.provide(3)
        // Then
        let uniqueQuestionWords = Set(roundsData.map { $0.questionWord })
        print(uniqueQuestionWords)
        XCTAssertEqual(uniqueQuestionWords.count, 3)
    }

    func testShuffledProvider_returnsSubsetOfDifferentEnglishWords() {
        // Given
        let roundsProvider = RoundsDataProvider.makeShuffledProvider(with:
            TranslatedWordsLoader(load: { TestData.translatedWords })
        )
        // When
        let roundsData = roundsProvider.provide(3)
        // Then
        let allEnglishWords = TestData.translatedWords.map { $0.eng }
        let returnedQuestionWords = Set(roundsData.map { $0.questionWord })
        XCTAssertTrue(returnedQuestionWords.isSubset(of: allEnglishWords))
    }

    func testShuffledProvider_returnsSubsetOfDifferentSpanishWords() {
        // Given
        let roundsProvider = RoundsDataProvider.makeShuffledProvider(with:
            TranslatedWordsLoader(load: { TestData.translatedWords })
        )
        // When
        let roundsData = roundsProvider.provide(3)
        // Then
        let allSpanishWords = TestData.translatedWords.map { $0.spa }
        let returnedAnswerWords = Set(roundsData.map { $0.answerWord })
        XCTAssertTrue(returnedAnswerWords.isSubset(of: allSpanishWords))
    }

    func testShuffledProvider_returnsRightTranslationForOneWord() {
        // Given
        let roundsProvider = RoundsDataProvider.makeShuffledProvider(with:
            TranslatedWordsLoader(load: { [TestData.translatedWord1] })
        )
        // When
        let roundsData = roundsProvider.provide(1)
        // Then
        XCTAssertEqual(roundsData, [
            RoundData(questionWord: TestData.translatedWord1.eng,
                      answerWord: TestData.translatedWord1.spa,
                      isTranslationCorrect: true)
            ])
    }

    func testShuffledProvider_returnsMoreThan50PercentOfCorrectTranslations() {
        // Given
        let roundsProvider = RoundsDataProvider.makeShuffledProvider(with:
            TranslatedWordsLoader(load: { TestData.translatedWords })
        )
        let roundsCount = 5
        // When
        let roundsData = roundsProvider.provide(roundsCount)
        // Then
        XCTAssertGreaterThanOrEqual(roundsData.filter { $0.isTranslationCorrect }.count, roundsCount/2)
    }
}
