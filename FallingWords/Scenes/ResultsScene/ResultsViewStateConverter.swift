//
//  ResultsViewStateConverter.swift
//  FallingWords
//
//  Created by Alex Shubin on 26/01/2019.
//  Copyright © 2019 AlexShubin. All rights reserved.
//

struct ResultsViewStateConverter {
    func convert(from state: AppState) -> ResultsViewState {
        return ResultsViewState(rightAnswersText: L10n.ResultsScreen.rightAnswers(state.gameResults.rightAnswers),
                                wrongAnswersText: L10n.ResultsScreen.rightAnswers(state.gameResults.wrongAnswers),
                                noAnswersText: L10n.ResultsScreen.rightAnswers(state.gameResults.noAnswers))
    }
}
