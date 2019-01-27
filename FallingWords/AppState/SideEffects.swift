//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import RxSwift
import RxFeedback

typealias FeedbackLoop = (ObservableSchedulerContext<AppState>) -> Observable<AppEvent>

protocol SideEffects {
    var provideShuffledRoundsData: (_ roundsCount: Int) -> Observable<AppEvent> { get }
    var showResults: () -> Observable<AppEvent> { get }
    var turnOnTimer: () -> Observable<AppEvent> { get }
    var fireTimer: (_ duration: TimeInterval) -> Observable<AppEvent> { get }
    var closeResults: () -> Observable<AppEvent> { get }
}

extension SideEffects {
    var feedbackLoops: [FeedbackLoop] {
        return [
            react(query: { $0.queryShouldProvideNewRoundsOfCount }, effects: provideShuffledRoundsData),
            react(query: { $0.queryLastRoundFinished }, effects: showResults),
            react(query: { $0.queryShouldTurnOnTimer }, effects: turnOnTimer),
            react(query: { $0.queryShouldFireTimerWithDuration }, effects: fireTimer),
            react(query: { $0.queryShouldCloseResults }, effects: closeResults)
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
            self.sceneCoordinator
                .push(scene: .results)
                .flatMap { Observable.empty() }
        }
    }

    var turnOnTimer: () -> Observable<AppEvent> {
        return {
            .just(.turnOnTimer)
        }
    }

    var fireTimer: (_ duration: TimeInterval) -> Observable<AppEvent> {
        return { duration in
            Observable
                .just(.answer(.timeout))
                .delay(duration, scheduler: MainScheduler.instance)
        }
    }

    var closeResults: () -> Observable<AppEvent> {
        return {
            self.sceneCoordinator
                .pop()
                .flatMap { Observable.empty() }
        }
    }
}
