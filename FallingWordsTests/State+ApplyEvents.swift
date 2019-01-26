//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import FallingWords

extension AppState {
    static func applyEvents(initial: AppState, events: [AppEvent]) -> AppState {
        return events.reduce(initial) { (result, event) -> AppState in
            reduce(state: result, event: event)
        }
    }
}
