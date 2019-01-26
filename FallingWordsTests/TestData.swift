//
//  TestData.swift
//  FallingWordsTests
//
//  Created by Alex Shubin on 26/01/2019.
//  Copyright © 2019 AlexShubin. All rights reserved.
//

@testable import FallingWords

enum TestData {
    static let translatedWord1 = TranslatedWord(eng: "eng1", spa: "spa1")
    static let translatedWord2 = TranslatedWord(eng: "eng2", spa: "spa2")
    static let translatedWord3 = TranslatedWord(eng: "eng3", spa: "spa3")
    static let translatedWord4 = TranslatedWord(eng: "eng4", spa: "spa4")
    static let translatedWord5 = TranslatedWord(eng: "eng5", spa: "spa5")

    static let translatedWords = [
        translatedWord1, translatedWord2, translatedWord3, translatedWord4, translatedWord5
    ]

    static let roundData1 = RoundData(questionWord: "eng1", answerWord: "spa1", isTranslationCorrect: true)
    static let roundData2 = RoundData(questionWord: "eng2", answerWord: "spa2", isTranslationCorrect: false)
    static let roundData3 = RoundData(questionWord: "eng3", answerWord: "spa3", isTranslationCorrect: true)

    static let roundsData = [
        roundData1, roundData2, roundData3
    ]
}
