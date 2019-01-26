//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

// MARK: - State
struct AppState: Equatable {
    static let initial = AppState()

    /// All data required to run full game session.
    var roundsData = [RoundData]()
    /// Number of rounds in a session.
    var roundsCount = 10
    /// Game is started.
    var gameIsStarted = false
    /// Current round.
    var currentRound = 0
}

// MARK: - Events
enum AppEvent: Equatable {
    /// Answer received (correct or not).
    case answer(correct: Bool)
    /// Starts game.
    case startGame
    /// New rounds data loaded.
    case roundsDataLoaded([RoundData])
}

// MARK: - Queries
extension AppState {
    var queryShouldProvideNewRoundsOfCount: Int? {
        return roundsData.isEmpty && gameIsStarted ? roundsCount : nil
    }
}

// MARK: - Reducer
extension AppState {
    static func reduce(state: AppState, event: AppEvent) -> AppState {
        //debugPrint("EVENT: \(event)")
        var result = state
        switch event {
        case .roundsDataLoaded(let roundsData):
            result.roundsData = roundsData
        case .startGame:
            result.gameIsStarted = true
        case .answer(let correct):
            result.currentRound += 1
        }
        return result
    }
}
