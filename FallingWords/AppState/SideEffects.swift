//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import RxSwift
import RxFeedback

// Feedback loop is just some feed back to app state.
typealias FeedbackLoop = (ObservableSchedulerContext<AppState>) -> Observable<AppEvent>

struct EmptyInput: Equatable {}

protocol SideEffects {
    var provideShuffledRoundsData: (_ roundsCount: Int) -> Observable<AppEvent> { get }
    var showResults: (EmptyInput) -> Observable<AppEvent> { get }
    var turnOnTimer: (EmptyInput) -> Observable<AppEvent> { get }
    var fireTimer: (_ duration: TimeInterval) -> Observable<AppEvent> { get }
    var closeResults: (EmptyInput) -> Observable<AppEvent> { get }
}

extension SideEffects {
    var feedbackLoops: [FeedbackLoop] {
        return [
            // Read like this: if something happens - then do some effects
            react(request: { $0.queryShouldProvideNewRoundsOfCount }, effects: provideShuffledRoundsData),
            react(request: { $0.queryLastRoundFinished }, effects: showResults),
            react(request: { $0.queryShouldTurnOnTimer }, effects: turnOnTimer),
            react(request: { $0.queryShouldFireTimerWithDuration }, effects: fireTimer),
            react(request: { $0.queryShouldCloseResults }, effects: closeResults)
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

    var showResults: (EmptyInput) -> Observable<AppEvent> {
        return { _ in
            self.sceneCoordinator
                .push(scene: .results)
                .flatMap { Observable.empty() }
        }
    }

    var turnOnTimer: (EmptyInput) -> Observable<AppEvent> {
        return { _ in
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

    var closeResults: (EmptyInput) -> Observable<AppEvent> {
        return { _ in
            self.sceneCoordinator
                .pop()
                .flatMap { Observable.empty() }
        }
    }
}
