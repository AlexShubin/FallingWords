//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import RxSwift
import RxFeedback

typealias FeedbackLoop = (ObservableSchedulerContext<AppState>) -> Observable<AppEvent>

protocol SideEffects {
    var provideShuffledRoundsData: (_ roundsCount: Int) -> Observable<AppEvent> { get }
    var showResults: () -> Observable<AppEvent> { get }
}

extension SideEffects {
    var feedbackLoops: [FeedbackLoop] {
        return [
            react(query: { $0.queryShouldProvideNewRoundsOfCount }, effects: provideShuffledRoundsData),
            react(query: { $0.queryLastRoundFinished }, effects: showResults)
        ]
    }
}

struct AppSideEffects: SideEffects {

    let roundsDataProvider: RoundsDataProvider
    let sceneCoordinator: SceneCoordinatorType

    var provideShuffledRoundsData: (Int) -> Observable<AppEvent> {
        return { roundsCount in
            .just(.roundsDataLoaded(self.roundsDataProvider.provide(roundsCount)))
        }
    }

    var showResults: () -> Observable<AppEvent> {
        return {
            self.sceneCoordinator.push(scene: .results).map { .stopGame }
        }
    }
}
