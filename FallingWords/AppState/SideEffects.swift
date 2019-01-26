//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import RxSwift
import RxFeedback

typealias FeedbackLoop = (ObservableSchedulerContext<AppState>) -> Observable<AppEvent>

protocol SideEffects {
    var provideShuffledRoundsData: (_ roundsCount: Int) -> Observable<AppEvent> { get }
}

extension SideEffects {
    var feedbackLoops: [FeedbackLoop] {
        return [
            react(query: { $0.queryShouldProvideNewRoundsOfCount }, effects: provideShuffledRoundsData)
        ]
    }
}

struct AppSideEffects: SideEffects {

    let roundsDataProvider: RoundsDataProvider

    var provideShuffledRoundsData: (Int) -> Observable<AppEvent> {
        return { roundsCount in
            .just(.roundsDataLoaded(self.roundsDataProvider.provide(roundsCount)))
        }
    }
}
