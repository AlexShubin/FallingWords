//
//  RoundsDataProvider.swift
//  FallingWords
//
//  Created by Alex Shubin on 26/01/2019.
//  Copyright © 2019 AlexShubin. All rights reserved.
//

// Didn't do classic way of making services. Because then I need 3 things - protocol, service impl., mock.
// Harder to maintain, more code etc.
// Services should be stateless so we can consider them as functions,
// and dependency injection could be done via factory method parameters.

struct RoundsDataProvider {
    let provide: (_ roundsCount: Int) -> [RoundData]

    /// Makes game data provider implemetation,
    /// which creates 50% of right answers and the other 50% are random - right/wrong🤔.
    static func makeShuffledProvider(with wordsLoader: TranslatedWordsLoader) -> RoundsDataProvider {
        return RoundsDataProvider(provide: { roundsCount in
            let allWords = wordsLoader.load()
            let shuffledPrefix = allWords.shuffled().prefix(roundsCount)
            let half = roundsCount/2
            let halfOfRoundsCorrect = shuffledPrefix.prefix(half).map {
                return RoundData(questionWord: $0.eng,
                                 answerWord: $0.spa,
                                 isTranslationCorrect: true)
            }
            let halfOfRoundsCorrectOrNot: [RoundData] = shuffledPrefix.suffix(roundsCount-half).map {
                let allPossibleTranslations = Set(allWords.map { $0.spa })
                let answerWord = allPossibleTranslations.randomElement() ?? $0.spa
                return RoundData(questionWord: $0.eng,
                                 answerWord: answerWord,
                                 isTranslationCorrect: answerWord == $0.spa)
            }
            return (halfOfRoundsCorrect + halfOfRoundsCorrectOrNot).shuffled()
        })
    }
}
