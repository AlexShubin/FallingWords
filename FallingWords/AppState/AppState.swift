//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import Foundation

// MARK: - State
struct AppState: Equatable {
    static let initial = AppState()

    /// All data required to run a full game session.
    var roundsData = [RoundData]()
    /// Number of rounds in a session.
    var roundsCount = 10
    /// Game is started.
    var gameIsStarted = false
    /// Current round.
    var currentRound = 0
    /// Accumulated results of the game session.
    var gameResults = GameResults.empty
    /// Round duration.
    let roundDuration: TimeInterval = 4
    /// Timer is on.
    var isTimerOn = false
    /// Should close results.
    var shouldCloseResults = false
}

// MARK: - Events
enum AppEvent: Equatable {
    enum AnswerType { case right, wrong, timeout }
    /// Answer received.
    case answer(AnswerType)
    /// Starts game.
    case startGame
    /// New rounds data loaded.
    case roundsDataLoaded([RoundData])
    /// Turn on timer.
    case turnOnTimer
    /// Close results.
    case closeResults
}

// MARK: - Queries
extension AppState {
    var queryShouldProvideNewRoundsOfCount: Int? {
        return roundsData.isEmpty && gameIsStarted ? roundsCount : nil
    }
    var queryLastRoundFinished: EmptyInput? {
        return currentRound >= roundsCount ? EmptyInput() : nil
    }
    var queryShouldTurnOnTimer: EmptyInput? {
        return gameIsStarted && !isTimerOn ? EmptyInput() : nil
    }
    var queryShouldFireTimerWithDuration: TimeInterval? {
        return isTimerOn ? roundDuration : nil
    }
    var queryShouldCloseResults: EmptyInput? {
        return shouldCloseResults ? EmptyInput() : nil
    }
}

// MARK: - Reducer
extension AppState {
    static func reduce(state: AppState, event: AppEvent) -> AppState {
        print("EVENT: \(event)")
        var result = state
        switch event {
        case .roundsDataLoaded(let roundsData):
            result.roundsData = roundsData
        case .startGame:
            result = AppState.initial
            result.gameIsStarted = true
        case .answer(let type):
            if type == .timeout {
                result.gameResults.noAnswers += 1
            } else if (type == .right && state.currentRoundData.isTranslationCorrect)
                || (type == .wrong && !state.currentRoundData.isTranslationCorrect) {
                result.gameResults.rightAnswers += 1
            } else {
                result.gameResults.wrongAnswers += 1
            }
            print(result.gameResults)
            result.currentRound += 1
            result.isTimerOn = false
            if result.currentRound >= result.roundsCount {
                result.gameIsStarted = false
            }
        case .turnOnTimer:
            result.isTimerOn = true
        case .closeResults:
            result.shouldCloseResults = true
        }
        return result
    }
}

// MARK: - Helpers
extension AppState {
    var currentRoundData: RoundData {
        return roundsData[currentRound]
    }
}
