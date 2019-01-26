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
}

// MARK: - Events
enum AppEvent: Equatable {
    case roundsDataLoaded([RoundData])
}

// MARK: - Queries
extension AppState {
    var queryRoundsDataIsEmpty: Void? {
        return roundsData.isEmpty ? () : nil
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
        }
        return result
    }
}
