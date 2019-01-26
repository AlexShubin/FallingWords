//
//  GameViewStateConverter.swift
//  FallingWords
//
//  Created by Alex Shubin on 26/01/2019.
//  Copyright © 2019 AlexShubin. All rights reserved.
//

struct GameViewStateConverter {
    func convert(from state: AppState) -> GameViewState {
        guard state.currentRound < state.roundsData.count else {
            return .empty
        }
        let currentRound = state.roundsData[state.currentRound]
        return GameViewState(questionWord: currentRound.questionWord,
                             answerWord: currentRound.answerWord)
    }
}
