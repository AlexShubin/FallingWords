//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import RxSwift
import RxCocoa
import RxFeedback

// Super-simple idea here
// - eventBus is to accept events from any `StateStoreBindable`, e.g. view controller
// - stateBus emits state and any `StateStoreBindable` can subscribe, e.g. view controller

struct AppStateStore {

    let eventBus: PublishRelay<AppEvent>
    let stateBus: Signal<AppState>

    init(sideEffects: SideEffects,
         scheduler: SchedulerType = MainScheduler.instance,
         initialState: AppState = .initial) {
        let events = PublishRelay<AppEvent>()
        eventBus = events
        let eventBusFeedback: FeedbackLoop = { _ -> Observable<AppEvent> in
            events.asObservable()
        }
        var feedBacks = sideEffects.feedbackLoops
        feedBacks.append(eventBusFeedback)
        stateBus = Observable.system(initialState: initialState,
                                     reduce: AppState.reduce,
                                     scheduler: scheduler,
                                     scheduledFeedback: feedBacks)
            .asSignal(onErrorSignalWith: .never())
    }
}
